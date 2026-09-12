#!/usr/bin/env python3
"""Export opencode session history to readable markdown.

Usage: python3 export.py [--db PATH] [--out DIR]
Defaults: db = ~/.local/share/opencode/opencode.db, out = script dir.
Read-only DB access; safe to run while opencode is running.
"""
import argparse
import json
import os
import re
import sqlite3
from datetime import datetime

DB = os.path.expanduser("~/.local/share/opencode/opencode.db")
OUT = os.path.dirname(os.path.abspath(__file__))

XML_RE = re.compile(r"<[a-z][^>]*>", re.IGNORECASE)

# Secrets occasionally appear verbatim in captured tool output.
# Redact before writing so the archive is safe to commit/share.
SECRET_PATTERNS = [
    re.compile(r"(?<![\w-])fbu_[0-9a-zA-Z]{16,}"),
    re.compile(r"(?<![\w-])(?:sk|csk)-[A-Za-z0-9_-]{16,}"),
    re.compile(r"(?<![\w-])gsk_[A-Za-z0-9]{16,}"),
    re.compile(r"(?<![\w-])gh[pousr]_[A-Za-z0-9]{20,}"),
    re.compile(r"(?<![\w-])github_pat_[A-Za-z0-9_]{20,}"),
    re.compile(r"(?<![\w-])hf_[A-Za-z0-9]{20,}"),
    re.compile(r"(?<![\w-])fw_[A-Za-z0-9]{16,}"),
    re.compile(r"(?<![\w-])glpat_[A-Za-z0-9_-]{16,}"),
    re.compile(r"(?<![\w-])AKIA[0-9A-Z]{16}"),
    re.compile(r"(?<![\w-])xox[baprs]-[A-Za-z0-9-]{10,}"),
]
REDACTED = "***REDACTED***"


def redact(text: str) -> str:
    for pat in SECRET_PATTERNS:
        text = pat.sub(REDACTED, text)
    return text


def looks_like_xml_context(text: str) -> bool:
    """Heuristic: opencode wraps injected context in XML-ish tags."""
    tags = XML_RE.findall(text)
    if not tags:
        return False
    return len(tags) >= 3


def fmt_time(ms: int) -> str:
    return datetime.fromtimestamp(ms / 1000).strftime("%Y-%m-%d %H:%M:%S")


def fmt_duration(start_ms: int, end_ms: int) -> str:
    if not end_ms or end_ms < start_ms:
        return ""
    secs = round((end_ms - start_ms) / 1000, 1)
    if secs >= 60:
        return f" ({secs / 60:.1f}m)"
    return f" ({secs}s)"


def fmt_part(p: dict) -> str:
    """Render one message part as markdown. Returns '' to skip."""
    t = p.get("type")
    if t == "text":
        text = p.get("text", "")
        if not text.strip():
            return ""
        return text
    if t == "reasoning":
        text = p.get("text", "").strip()
        if not text:
            return ""
        return "\n".join(f"> {line}" for line in text.splitlines())
    if t == "tool":
        state = p.get("state", {}) or {}
        status = state.get("status", "?")
        tool = p.get("tool", "?")
        inp = state.get("input", {}) or {}
        # compact one-line summary of the input
        summary = "; ".join(f"{k}={str(v)[:80]}" for k, v in list(inp.items())[:3])
        out = state.get("output", "")
        title = state.get("title", "")
        lines = [f"**tool:{tool}** ({status}) {title}", "", "```"]
        if summary:
            lines.append(summary)
        if isinstance(out, str) and out.strip():
            out_text = out.strip()
            lines.append("--- output ---")
            lines.extend(out_text.splitlines()[:200])
        lines.append("```")
        return "\n".join(lines)
    if t == "step-start" or t == "step-finish":
        return ""
    if t == "snapshot":
        return ""
    return f"*(part type: {t})*"


def render_session(sess, messages, parts_by_msg):
    sid, title, directory, created, updated, nmsg = sess
    lines = []
    lines.append(f"# {title}")
    lines.append("")
    lines.append(f"- **Session ID:** `{sid}`")
    lines.append(f"- **Directory:** {directory}")
    lines.append(f"- **Started:** {fmt_time(created)}")
    lines.append(f"- **Last activity:** {fmt_time(updated)}")
    lines.append(f"- **Messages:** {nmsg}")
    lines.append("")
    lines.append("---")
    lines.append("")

    for (mid, mdata, mtime) in messages:
        m = json.loads(mdata)
        role = m.get("role", "?")
        mstart = m.get("time", {}) or {}
        label = {"user": "🧑 User", "assistant": "🤖 Assistant"}.get(role, f"⚙️ {role}")
        dur = ""
        # assistant duration from step-finish parts
        if role == "assistant":
            finish = None
            for (pd,) in parts_by_msg[mid]:
                p = json.loads(pd)
                if p.get("type") == "step-finish":
                    finish = p
            if finish and isinstance(mstart, dict):
                fin_time = (finish.get("time") or {}).get("end")
                if fin_time and mstart.get("start"):
                    dur = fmt_duration(mstart["start"], fin_time)
        lines.append(f"### {label} — {fmt_time(mtime)}{dur}")
        lines.append("")
        for (pd,) in parts_by_msg[mid]:
            p = json.loads(pd)
            chunk = fmt_part(p)
            if chunk:
                lines.append(chunk)
                lines.append("")
        lines.append("---")
        lines.append("")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DB)
    ap.add_argument("--out", default=OUT)
    args = ap.parse_args()

    db = sqlite3.connect(f"file:{args.db}?mode=ro", uri=True)
    db.row_factory = sqlite3.Row
    cur = db.cursor()

    sessions = cur.execute(
        "SELECT id, title, directory, time_created, time_updated,"
        " (SELECT COUNT(*) FROM message WHERE message.session_id = session.id) AS nmsg"
        " FROM session ORDER BY time_created"
    ).fetchall()

    os.makedirs(args.out, exist_ok=True)

    index_rows = []
    exported = 0
    skipped_empty = 0
    for sess in sessions:
        if sess["nmsg"] == 0:
            skipped_empty += 1
            continue
        messages = cur.execute(
            "SELECT id, data, time_created FROM message WHERE session_id=? ORDER BY time_created",
            (sess["id"],),
        ).fetchall()
        parts_by_msg = {}
        for mid in [m[0] for m in messages]:
            parts_by_msg[mid] = cur.execute(
                "SELECT data FROM part WHERE message_id=? ORDER BY time_created", (mid,)
            ).fetchall()

        md = redact(render_session(sess, messages, parts_by_msg))

        # filename: date + slug + short id
        date = datetime.fromtimestamp(sess["time_created"] / 1000).strftime("%Y-%m-%d")
        slug = re.sub(r"[^a-z0-9]+", "-", (sess["title"] or "session").lower()).strip("-")[:40]
        fname = f"{date}_{slug}_{sess['id'][4:12]}.md"
        with open(os.path.join(args.out, fname), "w", encoding="utf-8") as f:
            f.write(md)
        index_rows.append((sess, fname))
    exported = len(index_rows)

    # INDEX.md
    lines = ["# OpenCode Session History Archive", ""]
    lines.append(f"Exported: {fmt_time(datetime.now().timestamp() * 1000)}")
    lines.append("")
    lines.append(f"**{exported} sessions** with content "
                 f"({skipped_empty} empty sessions skipped).")
    lines.append("")
    lines.append("> Note: secret-like strings (API keys/tokens) found in captured tool "
                 "output are redacted as `***REDACTED***`.")
    lines.append("")
    lines.append("| Date | Title | Dir | Msgs | File |")
    lines.append("|---|---|---|---|---|")
    for sess, fname in index_rows:
        date = datetime.fromtimestamp(sess["time_created"] / 1000).strftime("%Y-%m-%d %H:%M")
        d = sess["directory"].replace("/home/x3", "~")
        title = (sess["title"] or "session").replace("|", "\\|")
        lines.append(
            f"| {date} | {title} | {d} | {sess['nmsg']} | [{fname}]({fname}) |"
        )
    with open(os.path.join(args.out, "INDEX.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    print(f"Exported {exported} sessions to {args.out} "
          f"({skipped_empty} empty skipped). INDEX.md written.")


if __name__ == "__main__":
    main()
