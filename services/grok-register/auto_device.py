#!/usr/bin/env python3
"""
Automate grok2api Device OAuth registration using DrissionPage.
Opens x.ai verification URL, logs in, enters device code, waits for auth.

Usage:
  python3 auto_device.py --email user@gmail.com --password xxx [--count 5] [--proxy http://127.0.0.1:7898]
"""

import argparse
import json
import time
import sys
import os
import subprocess
import requests
from pathlib import Path

GROK2API_URL = "http://127.0.0.1:8093"
ADMIN_USER = "admin"
ADMIN_PASS = "hh95CHkFdg1SPsAf"


def admin_login(session: requests.Session) -> str | None:
    """Login to grok2api admin panel, return access token."""
    r = session.post(f"{GROK2API_URL}/api/admin/v1/auth/login", json={
        "username": ADMIN_USER,
        "password": ADMIN_PASS
    })
    if r.status_code == 200:
        token = r.json()["data"]["tokens"]["accessToken"]
        print("[+] Admin login OK")
        return token
    print(f"[-] Admin login failed: {r.status_code} {r.text[:200]}")
    return None


def start_device(session: requests.Session, token: str) -> dict | None:
    """Start Device OAuth flow, get verification URL + user code."""
    r = session.post(f"{GROK2API_URL}/api/admin/v1/accounts/device/start",
        headers={"Authorization": f"Bearer {token}"})
    if r.status_code != 201:
        print(f"[-] Device start failed: {r.status_code} {r.text[:200]}")
        return None
    data = r.json().get("data", r.json())
    print(f"[+] Device started: userCode={data.get('userCode')}")
    print(f"    Verification: {data.get('verificationUriComplete') or data.get('verificationUri')}")
    return data


def poll_device(session: requests.Session, token: str, session_id: str, interval: int = 5, timeout: int = 300) -> dict | None:
    """Poll until device auth completes."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        r = session.post(f"{GROK2API_URL}/api/admin/v1/accounts/device/{session_id}/poll",
            headers={"Authorization": f"Bearer {token}"})
        if r.status_code == 200:
            data = r.json()
            status = data.get("data", {}).get("status") or data.get("status")
            if status in ("succeeded", "syncFailed"):
                print(f"[+] Device auth succeeded!")
                return data.get("data", data)
            elif status == "pending":
                time.sleep(interval)
                continue
        elif r.status_code == 202:
            time.sleep(interval)
            continue
        elif r.status_code == 429:
            print("[!] Rate limited, waiting 30s...")
            time.sleep(30)
            continue
        elif r.status_code == 410:
            print("[-] Device auth expired/denied")
            return None
        else:
            print(f"[-] Poll error: {r.status_code} {r.text[:200]}")
            time.sleep(interval)
    print("[-] Device auth timed out")
    return None


def automate_browser(verification_url: str, user_code: str, email: str, password: str, proxy: str = None):
    """
    Use DrissionPage to:
    1. Open verification URL
    2. Login to x.ai if needed
    3. Enter device code
    4. Authorize
    """
    from DrissionPage import ChromiumPage, ChromiumOptions
    import subprocess

    # Launch a fresh Chrome with remote debugging on port 9333
    chrome_cmd = [
        "google-chrome",
        "--remote-debugging-port=9333",
        "--no-sandbox",
        "--disable-gpu",
        "--no-first-run",
        "--disable-default-apps",
        # Isolated profile: never touch the user's Vivaldi/Chrome sessions
        "--user-data-dir=/tmp/xai-mint-profile",
    ]
    if proxy:
        chrome_cmd.append(f"--proxy-server={proxy}")
    chrome_cmd.append("about:blank")

    print("[*] Launching Chrome...")
    chrome_proc = subprocess.Popen(chrome_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(3)  # Wait for Chrome to start

    co = ChromiumOptions()
    co.set_local_port(9333)

    page = ChromiumPage(co)

    try:
        print(f"[*] Opening verification URL: {verification_url}")
        page.get(verification_url)

        def settle(max_wait=30):
            """Wait for CF challenge to clear / page to render."""
            for _ in range(max_wait // 2):
                time.sleep(2)
                html = (page.html or "").lower()
                if "<input" in html or "<button" in html:
                    return True
            return False

        def need_login():
            # Judge by URL PATH only — return_to params can contain "oauth2/device"
            u = (page.url or "").split("?", 1)[0].lower()
            if u.endswith("/oauth2/device") or "/device/done" in u:
                return False
            return ("sign-in" in u or "signin" in u or "login" in u)

        def do_login():
            print(f"[*] LOGIN: url={page.url[:90]}")
            # Best-effort: dismiss OneTrust cookie banner so it can't eat clicks
            for b in page.eles("tag:button"):
                try:
                    t = (b.text or "").strip().lower()
                except Exception:
                    continue
                if t in ("close", "accept all", "accept all cookies"):
                    try:
                        b.click()
                        time.sleep(1)
                        print("[*] LOGIN: dismissed cookie banner")
                    except Exception:
                        pass
                    break
            # Sign-in page is an SSO chooser: email form lives behind its button
            email_btn = None
            for b in page.eles("tag:button"):
                try:
                    t = (b.text or "").strip().lower()
                except Exception:
                    continue
                if "login with email" in t:
                    email_btn = b
                    break
            if email_btn:
                print("[*] LOGIN: clicking 'Login with email'")
                try:
                    email_btn.click()
                except Exception as e:
                    print(f"[-] LOGIN: email button click failed: {e}")
                    return False
                time.sleep(3)
            # Email field (retry on re-render)
            ei = None
            for _ in range(3):
                try:
                    ei = page.ele("css:input[type='email'], input[name='email'], input[name='username']", timeout=8)
                    if ei:
                        break
                except Exception:
                    time.sleep(2)
            if not ei:
                print("[-] LOGIN: no email field found")
                return False
            ei.clear(); ei.input(email); time.sleep(1)
            b = page.ele("css:button[type='submit']", timeout=4) or page.ele("tag:button", timeout=4)
            if b:
                b.click()
            time.sleep(3)
            pi = page.ele("css:input[type='password']", timeout=10)
            if pi:
                pi.clear(); pi.input(password); time.sleep(1)
                b = page.ele("css:button[type='submit']", timeout=4) or page.ele("tag:button", timeout=4)
                if b:
                    b.click()
            for _ in range(20):
                time.sleep(2)
                u = (page.url or "").lower()
                if "oauth2/device" in u or ("sign-in" not in u and "login" not in u):
                    print(f"[*] LOGIN done, url={page.url[:90]}")
                    return True
            return False

        def shot(name):
            try:
                page.get_screenshot(path=f"/tmp/mint_{name}.png", full_page=True)
            except Exception:
                pass

        settle()
        print(f"[*] After settle: url={page.url[:90]} title={page.title!r}")
        shot("01_open")

        # Login may be required immediately, or after the first Continue click
        for _ in range(2):
            if need_login():
                if not do_login():
                    print("[-] LOGIN failed")
                    shot("02_login_fail")
                    break
                settle()
            else:
                break

        # Device page: type the code if there's an empty input (URL param may pre-fill)
        # The page re-renders (React/CF), so elements can go stale — retry with relookup.
        typed = False
        for attempt in range(3):
            try:
                code_inputs = page.eles("css:input[type='text'], input[type='tel'], input[inputmode='numeric']")
                if code_inputs:
                    target = next((i for i in code_inputs if not (i.value or "").strip()), code_inputs[0])
                    print("[*] Typing user code")
                    target.clear()
                    target.input(user_code)
                    time.sleep(1)
                else:
                    print("[*] No code input found (code likely pre-filled from URL)")
                typed = True
                break
            except Exception as e:
                print(f"[-] code entry attempt {attempt} failed: {str(e)[:80]} — retrying")
                time.sleep(3)
                settle()
        shot("02_code")

        # Click through: Continue / Authorize / Allow, watching for completion
        confirmed = False
        COOKIE_NOISE = ["allow all", "allow selection", "reject all", "cookie",
                        "manage preferences", "confirm my choices"]
        for round_ in range(8):
            # (Re)enter the code if we're back on the device page with an empty input
            try:
                if (page.url or "").split("?", 1)[0].lower().endswith("/oauth2/device"):
                    empties = [i for i in page.eles("css:input[type='text'], input[type='tel']")
                               if not (i.value or "").strip()]
                    if empties:
                        print("[*] (Re)typing user code after login")
                        empties[0].clear()
                        empties[0].input(user_code)
                        time.sleep(1)
            except Exception:
                pass
            clicked = False
            try:
                buttons = page.eles("css:button")
            except Exception:
                time.sleep(2)
                settle()
                continue
            for btn in buttons:
                try:
                    text = (btn.text or "").strip().lower()
                except Exception:
                    continue
                if any(k in text for k in COOKIE_NOISE):
                    continue  # OneTrust banner, not the auth button
                    print(f"[*] Clicking: {btn.text.strip()!r}")
                    try:
                        btn.click()
                    except Exception as e:
                        print(f"[-] click failed: {e}")
                    clicked = True
                    time.sleep(3)
                    break
            u = (page.url or "").lower()
            h = (page.html or "").lower()
            path = u.split("?", 1)[0]
            print(f"[*] round {round_}: url={page.url[:90]} login_needed={need_login()}")
            # Login gate first: the sign-in page itself contains "you can close
            # this window", so success keywords are only trusted OFF sign-in.
            if need_login():
                print("[*] Login page appeared mid-flow")
                if not do_login():
                    print("[-] LOGIN failed mid-flow")
                    shot(f"04_login_fail_{round_}")
                    break
                settle()
                continue
            # Success ONLY on the real done state: /device/done path, or explicit
            # confirmation text while NOT on the device-entry page (its footer
            # boilerplate also says "you can close this window").
            if "/device/done" in path or (("all done" in h or "congratulations" in h) and "/oauth2/device" not in path):
                print("[*] DONE state reached")
                confirmed = True
                break
            if not clicked:
                time.sleep(2)
        shot("03_result")
        print(f"[*] Final url={page.url[:90]}")
        print(f"[*] Authorization page outcome: {'confirmed' if confirmed else 'unconfirmed'}")

        print("[*] Browser automation complete. Waiting for authorization...")
        print("[*] If login/CAPTCHA needed, complete manually in the browser window.")

        # Keep browser open for manual intervention
        time.sleep(30)

    except Exception as e:
        print(f"[-] Browser error: {e}")
    finally:
        try:
            page.quit()
        except:
            pass
        try:
            chrome_proc.terminate()
            chrome_proc.wait(timeout=5)
        except:
            pass


def main():
    parser = argparse.ArgumentParser(description="Automate grok2api Device OAuth registration")
    parser.add_argument("--email", required=True, help="x.ai account email")
    parser.add_argument("--password", required=True, help="x.ai account password")
    parser.add_argument("--count", type=int, default=1, help="Number of accounts to register")
    parser.add_argument("--proxy", default=None, help="HTTP proxy (e.g. http://127.0.0.1:7898)")
    parser.add_argument("--browser-only", action="store_true", help="Skip DrissionPage, just start device and show URL")
    args = parser.parse_args()

    session = requests.Session()
    # Note: proxy only for browser (x.ai), NOT for local grok2api API calls

    token = admin_login(session)
    if not token:
        sys.exit(1)

    for i in range(args.count):
        print(f"\n{'='*50}")
        print(f"[{i+1}/{args.count}] Starting Device OAuth...")
        print(f"{'='*50}")

        device = start_device(session, token)
        if not device:
            print("[-] Failed to start device, skipping...")
            continue

        session_id = device.get("sessionId")
        user_code = device.get("userCode")
        verify_url = device.get("verificationUriComplete") or device.get("verificationUri")
        interval = device.get("intervalSeconds", 5)

        if args.browser_only:
            print(f"\n[MANUAL] Visit: {verify_url}")
            print(f"[MANUAL] Enter code: {user_code}")
            print(f"[MANUAL] Press Enter when done...")
            input()
        else:
            # Run browser automation in background
            import threading
            t = threading.Thread(target=automate_browser, args=(verify_url, user_code, args.email, args.password, args.proxy), daemon=True)
            t.start()

        # Poll for completion
        print(f"[*] Polling for authorization (timeout: 5 min)...")
        result = poll_device(session, token, session_id, interval=interval, timeout=300)
        if result:
            account = result.get("account", {})
            print(f"[+] Account registered: {account.get('name', 'unknown')} (ID: {account.get('id', '?')})")
        else:
            print(f"[-] Registration failed for this attempt")

        if i < args.count - 1:
            print("[*] Waiting 5s before next attempt...")
            time.sleep(5)

    print(f"\n[+] Done! Check grok2api dashboard: http://127.0.0.1:8093")


if __name__ == "__main__":
    main()
