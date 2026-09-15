# GitHub compare pool libs (@general subagent)

- **Session ID:** `ses_f60f497a0ffe5rn0cMcZSClLob`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-14 16:32:00
- **Last activity:** 2026-09-14 16:35:57
- **Messages:** 19

---

### 🧑 User — 2026-09-14 16:32:00

Using gh CLI (gh repo view, gh api) compare these Go SOCKS proxy-pool projects head-to-head: yunginnanet/prox5, jacklul/proxy-manager (if exists, else find closest name match via gh search), and search GitHub for "socks5 proxy pool validation go" (gh search repos) to surface 3 more contenders. For each: stars, open issues, last push date, license, go.mod module path + Go version, test coverage signals (CI badge/workflow present?), API surface for embedding (list exported pool/validator/dialer types via gh api contents). Deliver a comparison table + one-line verdict each on embed-fit vs prox5 v1.3.0. Under 1200 words.

---

### 🤖 Assistant — 2026-09-14 16:32:04

Using evaluate-candidates to deep-dive proxy-pool contenders and search-repos to surface more options.

**tool:skill** (completed) Loaded skill: evaluate-candidates

```
name=evaluate-candidates
--- output ---
<skill_content name="evaluate-candidates">
# Skill: evaluate-candidates

# Evaluate GitHub Candidate Repos

After a search surfaces plausible candidates, the user typically wants a close look at 2–5 finalists before committing. This skill produces a structured side-by-side evaluation using `gh api` to inspect each repo.

## When to use

Trigger phrases include:
- "Compare these repos"
- "Look closer at X and Y"
- "Which of these should I use?"
- "Evaluate this project before I fork it"

Accept candidates as either a list of `owner/repo` identifiers or the output of a previous `search-repos` / `search-ai-tools` run.

## Procedure

For each candidate, collect the following signals. Run these in parallel where possible.

### 1. Core metadata

```bash
gh api repos/<owner>/<repo> --jq '{
  full_name, description, homepage,
  stars: .stargazers_count, forks: .forks_count,
  open_issues: .open_issues_count,
  created: .created_at, pushed: .pushed_at, updated: .updated_at,
  language, license: .license.spdx_id,
  default_branch, archived, disabled,
  has_issues, has_wiki, has_discussions
}'
```

### 2. README

```bash
gh api repos/<owner>/<repo>/readme --jq '.content' | base64 -d | head -200
```

Summarize in 2–3 sentences: what it does, who it's for, and installation/usage shape (library vs CLI vs service).

### 3. Maintenance health

- **Recent commits** (last 10):
  ```bash
  gh api "repos/<owner>/<repo>/commits?per_page=10" --jq '.[] | {date: .commit.author.date, msg: .commit.message | split("\n")[0], author: .commit.author.name}'
  ```
- **Contributor count**:
  ```bash
  gh api "repos/<owner>/<repo>/contributors?per_page=100" --jq 'length'
  ```
  Solo-maintainer projects are higher risk.
- **Releases**:
  ```bash
  gh api "repos/<owner>/<repo>/releases?per_page=5" --jq '.[] | {tag: .tag_name, date: .published_at}'
  ```
  Regular releases are a strong positive signal.
- **Open vs closed issue ratio**:
  ```bash
  gh api "search/issues?q=repo:<owner>/<repo>+type:issue+state:open" --jq '.total_count'
  gh api "search/issues?q=repo:<owner>/<repo>+type:issue+state:closed" --jq '.total_count'
  ```
  A huge open pile with few closes suggests the maintainer has disengaged.

### 4. Code-quality signals

Check the tree for common markers:

```bash
gh api "repos/<owner>/<repo>/contents" --jq '.[].name'
```

Look for:
- `tests/`, `test/`, `__tests__/`, `*_test.go`, `spec/` → tests exist
- `.github/workflows/` → CI configured
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` → project welcomes contribution
- `CHANGELOG.md` → actively tracked history
- Lockfiles (`package-lock.json`, `poetry.lock`, `Cargo.lock`, `go.sum`) → reproducible builds
- `Dockerfile`, `docker-compose.yml` → deploy story
- Documentation site (`docs/`, mkdocs, docusaurus) → serious project

### 5. License clarity

Flag: missing license, non-OSI license, license mismatch between package metadata and repo, copyleft (GPL/AGPL) vs permissive (MIT/Apache-2.0/BSD). This matters if the user plans to integrate.

### 6. Issues: look at the last 5 open

```bash
gh api "repos/<owner>/<repo>/issues?state=open&per_page=5" --jq '.[] | {title, created: .created_at, labels: [.labels[].name], author: .user.login}'
```

Are they user-facing bugs with no maintainer response? That's a red flag.

### 7. Produce a recommendation

For each candidate output:

- **Verdict** — one of: *recommend*, *maybe*, *avoid*, with one-line reason.
- **Strengths** — 2–3 bullets.
- **Concerns** — 2–3 bullets (or fewer if clean).
- **Fit** — does it match what the user described needing?

End with a summary ranking across the candidates and a clear recommendation of which to try first, or a "none are great, here's why" honest verdict if applicable.

## Guidance

- **Don't oversell.** If none of the candidates look good, say so and suggest widening the search or building from scratch.
- **Solo-maintainer risk is real** for anything load-bearing. Note it.
- **Recent activity matters more than star count** for production decisions.
- **License problems are deal-breakers** for integration — surface these prominently, not as footnotes.

Base directory for this skill: /home/x3/.opencode/skills/evaluate-candidates
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

**tool:skill** (completed) Loaded skill: search-repos

```
name=search-repos
--- output ---
<skill_content name="search-repos">
# Skill: search-repos

# Search GitHub Repos

Help the user discover existing GitHub projects that address a stated need, so they can evaluate whether to use, fork, or integrate one instead of building from scratch.

## When to use

Trigger phrases include:
- "Is there already a tool/library/CLI/plugin for X?"
- "Search GitHub for Y"
- "What are the top projects for Z?"
- "Before I build this, check if it already exists"

## Procedure

### 1. Clarify the query if needed

Ask the user at most one short clarifying question only if the target is genuinely ambiguous. Otherwise translate their request into search terms directly.

### 2. Run the search

Use `gh search repos` with sensible defaults. Start broad, then narrow if results are too noisy.

```bash
gh search repos "<keywords>" \
  --sort stars \
  --limit 20 \
  --json name,owner,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt
```

Use `--language=<lang>` when the user specified a language. Use topic filters (`--topic=<topic>`) when a canonical topic tag applies (e.g. `--topic=cli`, `--topic=mcp`).

For richer queries (e.g. combining topic with minimum stars), use `gh api`:

```bash
gh api -X GET search/repositories \
  -f q='<keywords> stars:>100 pushed:>2025-01-01' \
  -f sort=stars -f order=desc --jq '.items[] | {name, full_name: .full_name, stars: .stargazers_count, pushed: .pushed_at, language, license: .license.spdx_id, open_issues: .open_issues_count, description, url: .html_url}'
```

### 3. Rank and filter

From the returned set, build a shortlist of the top 5–10 candidates. For each candidate, capture:

- Full name (`owner/repo`)
- Stars
- Last push date (convert to "N months ago" for readability)
- Open issues
- License (flag missing/unclear licenses)
- Primary language
- One-sentence description

Drop candidates that are obviously off-topic (wrong language, archive/mirror, gist-style one-liners) unless the user explicitly wants all results.

### 4. Present results

Output a compact table or list, ordered by stars, but call out any candidates that look abandoned (last push > 12 months ago) with a ⚠️ marker. Offer the user a next step: dive deeper on a specific candidate (hand off to `evaluate-candidates`), broaden/narrow the search, or document findings to `planning/` (hand off to `document-findings`).

### 5. Keep the exact query

Preserve the exact `gh` command you ran. If the user later asks to document the findings, that query must be recorded alongside the research date so results are reproducible.

## Guidance

- **Stars are a rough signal, not the whole story.** A 500-star repo updated last week often beats a 10k-star repo abandoned in 2022.
- **Archived repos** (`--archived=false` by default on newer `gh`) should be excluded unless the user wants historical context.
- **Forks with more stars than the upstream** sometimes indicate the project has moved — note this.
- Do not invent repository names. Only report what the CLI actually returned.

Base directory for this skill: /home/x3/.opencode/skills/search-repos
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

**tool:skill** (completed) Loaded skill: document-findings

```
name=document-findings
--- output ---
<skill_content name="document-findings">
# Skill: document-findings

# Document GitHub Research Findings

The tooling landscape on GitHub evolves quickly — a top project today may be abandoned in six months, and new entrants appear constantly. Any research write-up must be **date-stamped** so future readers (including future-you) know the context in which the recommendation was made.

## When to use

Trigger phrases include:
- "Save these findings"
- "Document this research"
- "Write this to the planning folder"
- "Add a note in the repo about this research"

## Procedure

### 1. Locate or create the planning folder

In the current repository (working directory), look for one of:
- `planning/`
- `docs/planning/`
- `.planning/`

If none exist, create `planning/` at the repo root.

Inside the planning folder, create or reuse a subfolder:

```
planning/github-research/
```

This keeps research artefacts grouped and out of the way of general planning docs.

### 2. Name the file with the date

File naming convention:

```
planning/github-research/YYYY-MM-DD-<short-topic-slug>.md
```

Examples:
- `planning/github-research/2026-04-16-mcp-server-frameworks.md`
- `planning/github-research/2026-04-16-markdown-to-pdf-cli.md`

Use `date +%Y-%m-%d` to get today's date — never hard-code a year.

If a file for the same topic already exists on the same date, append a short suffix (e.g. `-v2`) rather than overwriting.

### 3. Write the document

Use this template:

```markdown
# GitHub Research: <Topic>

**Research date:** YYYY-MM-DD
**Researcher:** Claude Code (github-research plugin)
**Goal:** <one-sentence statement of what the user was trying to find / decide>

> ⚠️ Note on freshness: GitHub's tooling landscape evolves quickly. Findings below reflect repository state on the research date. Re-run the queries before acting on recommendations more than ~3 months old, especially for AI/ML projects.

## Queries run

Exact `gh` / `gh api` commands used, so the research is reproducible:

```bash
<paste each command>
```

## Top candidates

| Repo | Stars | Last push | Open issues | License | Language | Notes |
|------|------:|-----------|------------:|---------|----------|-------|
| owner/repo | 1.2k | 3 days ago | 14 | MIT | Python | Active, strong CI |
| ... | ... | ... | ... | ... | ... | ... |

## Detailed evaluation

### owner/repo

- **Verdict:** recommend / maybe / avoid
- **Strengths:** ...
- **Concerns:** ...
- **Fit for our use case:** ...

(Repeat per candidate)

## Recommendation

<Concrete, opinionated recommendation. Which to try first, or "none are a good fit — build from scratch, here's why".>

## Open questions / follow-ups

- <things the user should check before committing>
```

### 4. Commit hygiene (do not auto-commit)

Write the file only. Do **not** run `git add` / `git commit` unless the user explicitly asked. Let the user review the document first.

After writing, report the path of the created file so the user can open it.

### 5. Link back from the repo's CLAUDE.md (optional)

If the repo has a `CLAUDE.md` and the user indicates this research will inform ongoing work, offer (don't auto-apply) to add a line under a "Prior research" section:

```markdown
## Prior research
- [YYYY-MM-DD: <Topic>](planning/github-research/YYYY-MM-DD-<slug>.md)
```

## Guidance

- **Always include the date** in both the filename and the document body. The whole point of this skill is reproducibility across time.
- **Always include the exact queries run.** Without them the findings cannot be re-verified when they age.
- **Be honest about limits.** If the search was narrow, say so. If results were sparse, say so. Do not invent projects to pad the list.
- **Prefer opinionated recommendations** over neutral catalogues. The user asked for research to make a decision, not a Wikipedia article.

Base directory for this skill: /home/x3/.opencode/skills/document-findings
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

---

### 🤖 Assistant — 2026-09-14 16:32:17

Loaded 3 skills. Will run head-to-head eval per evaluate-candidates + search-repos flow.

**tool:todowrite** (completed) 4 todos

```
todos=[{'content': 'Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh 
--- output ---
[
  {
    "content": "Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh api",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "gh search repos socks5 proxy pool validation go",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Collect metadata: stars/issues/push/license/go.mod/CI/API surface",
    "status": "pending",
    "priority": "high"
  },
  {
    "content": "Deliver comparison table + verdicts under 1200 words",
    "status": "pending",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-14 16:32:41

**tool:bash** (completed) gh api repos/yunginnanet/prox5 --jq '{full_name, description, stars: .stargazers_count, forks: .forks_count, open_issues: .open_issues_count, pushed: .pushed_at, language, license: .license.spdx_id, default_branch, archived}' 2>&1; echo "---PROXY-MAN---"; gh api repos/jacklul/proxy-manager --jq '{full_name, description, stars: .stargazers_count, forks: .forks_count, open_issues: .open_issues_count, pushed: .pushed_at, language, license: .license.spdx_id, default_branch, archived}' 2>&1

```
command=gh api repos/yunginnanet/prox5 --jq '{full_name, description, stars: .stargazers
--- output ---
{"archived":false,"default_branch":"main","description":"🧮 SOCKS5/4/4a 🌾 validating proxy pool and upstream SOCKS5 server for 🤽 LOLXDsoRANDum connections 🎋 ","forks":8,"full_name":"yunginnanet/prox5","language":"Go","license":"MIT","open_issues":3,"pushed":"2024-10-07T16:01:27Z","stars":81}
---PROXY-MAN---
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/repos/repos#get-a-repository","status":"404"}gh: Not Found (HTTP 404)
```

---

### 🤖 Assistant — 2026-09-14 16:33:03

**tool:bash** (completed) gh search repos "proxy-manager jacklul" --sort stars --limit 10 --json name,owner,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt 2>&1; echo "===JACKLUL-OWNER==="; gh search repos "jacklul proxy" --sort stars --limit 10 --json name,owner,description,stargazersCount,updatedAt,language,url 2>&1

```
command=gh search repos "proxy-manager jacklul" --sort stars --limit 10 --json name,owne
--- output ---
[]
===JACKLUL-OWNER===
[]
```

---

### 🤖 Assistant — 2026-09-14 16:33:14

**tool:bash** (completed) gh api -X GET search/repositories -f q='jacklul in:name user:jacklul' -f sort=stars -f order=desc --jq '.items[] | {full_name, stars: .stargazers_count, pushed: .pushed_at, language, description}' 2>&1 | head -n 100; echo "===API-USER-REPOS==="; gh api users/jacklul/repos --jq '.[] | {full_name, stars: .stargazers_count, pushed: .pushed_at, language, description}' 2>&1 | head -n 150

```
command=gh api -X GET search/repositories -f q='jacklul in:name user:jacklul' -f sort=st
--- output ---
{"description":"Update Pi-hole's lists from remote sources easily","full_name":"jacklul/pihole-updatelists","language":"PHP","pushed":"2026-06-20T08:52:59Z","stars":1653}
{"description":"Collection of scripts that can run on stock Asus routers (also on Merlin's firmware and forks)","full_name":"jacklul/asuswrt-scripts","language":"Shell","pushed":"2026-08-23T07:38:41Z","stars":157}
{"description":"A Telegram bot providing games that can be played in any chat via inline keyboards.","full_name":"jacklul/inlinegamesbot","language":"PHP","pushed":"2026-08-08T06:40:29Z","stars":130}
{"description":"This prefab adds subtitles support to USharpVideo (or any other video player) in VRChat","full_name":"jacklul/USharpVideo-Subtitles","language":"C#","pushed":"2026-08-18T14:58:15Z","stars":61}
{"description":"Perform reverse search for all images in a directory (using e621.net/iqdb_queries, saucenao.com, fuzzysearch.net)","full_name":"jacklul/e621-Batch-Reverse-Search","language":"PHP","pushed":"2022-03-19T07:54:10Z","stars":61}
{"description":"Scripts to control NVIDIA GPUs using NVML API","full_name":"jacklul/nvml-scripts","language":"Python","pushed":"2026-05-01T17:27:26Z","stars":39}
{"description":"Pi-hole as an Entware package – run it on a router, older NAS, or other devices!","full_name":"jacklul/entware-pi-hole","language":"Shell","pushed":"2026-09-13T02:18:49Z","stars":31}
{"description":"Monolog handler that sends logs through Telegram bot to any chat in HTML format","full_name":"jacklul/monolog-telegram","language":"PHP","pushed":"2026-08-08T17:03:48Z","stars":25}
{"description":"Connect Raspberry Pi to Asus router through USB port using Ethernet Gadget functionality","full_name":"jacklul/asuswrt-usb-raspberry-pi","language":"Shell","pushed":"2026-06-12T15:12:40Z","stars":20}
{"description":"Script making downloading and updating image pools from e621.net easier","full_name":"jacklul/e621-Pool-Downloader","language":"PHP","pushed":"2020-07-06T07:58:28Z","stars":19}
{"description":"Simple library for querying Quake 3 based master servers and it's game servers","full_name":"jacklul/q3serverlist","language":"PHP","pushed":"2023-06-04T17:44:13Z","stars":17}
{"description":"Installing Pi-hole on read-only rootfs system to prevent SD card corruption problem (with data partition for write-required stuff)","full_name":"jacklul/pihole-readonly-rootfs","language":"Shell","pushed":"2024-03-26T16:11:52Z","stars":16}
{"description":"Simple script to backup files to the cloud service using rclone","full_name":"jacklul/rclone-backup","language":"Shell","pushed":"2025-10-13T15:40:22Z","stars":12}
{"description":"A simple inventory editor for Sons Of The Forest game","full_name":"jacklul/Sons-Of-The-Forest-Inventory-Editor","language":"PHP","pushed":"2023-03-24T08:21:12Z","stars":8}
{"description":"Bash script to provide puush.me screenshot and file upload functionality for linux users.","full_name":"jacklul/puush-linux","language":"Shell","pushed":"2014-10-31T21:18:06Z","stars":5}
{"description":"Simple Telegram bot that serves stuff from e621.net","full_name":"jacklul/e621-telegram-bot","language":"PHP","pushed":"2021-01-04T12:27:32Z","stars":5}
{"description":"Helper application for using ALVR through USB connection","full_name":"jacklul/ALVR-USB","language":"C#","pushed":"2023-03-12T08:07:43Z","stars":4}
{"description":"Various scripts that do not need their own repository. Most of them are for Linux / Raspberry Pi, Pi-hole or WireGuard","full_name":"jacklul/scripts","language":"Shell","pushed":"2026-06-12T14:59:38Z","stars":3}
{"description":"Wrapper for e621.net/e926.net API written in PHP","full_name":"jacklul/e621-api","language":"PHP","pushed":"2020-05-10T09:30:13Z","stars":3}
{"description":"Working version of https://www.npmjs.com/package/videojs-mpegtsjs","full_name":"jacklul/videojs-mpegtsjs","language":"JavaScript","pushed":"2024-04-25T20:10:01Z","stars":3}
{"description":"Phasmophobia Matrix as SteamVR overlay application","full_name":"jacklul/SteamVR-PhasmoMatrix","language":"C#","pushed":"2021-08-22T18:06:59Z","stars":3}
{"description":"Custom repository with extra packages, mainly for personal use","full_name":"jacklul/entware-packages","language":"Makefile","pushed":"2026-06-21T09:11:34Z","stars":2}
{"description":"Simple monitoring skin for Rainmeter","full_name":"jacklul/simple-monitoring","language":"C++","pushed":"2020-07-12T09:08:29Z","stars":2}
{"description":"Warn about hyperdiction before it happens","full_name":"jacklul/ED-Hyperdiction-Detector","language":"C#","pushed":"2018-12-29T22:53:38Z","stars":2}
{"description":"A batch script to make using rclone for backups easier","full_name":"jacklul/rclone-backup-windows","language":"Batchfile","pushed":"2025-10-13T15:41:11Z","stars":2}
{"description":"Hook that makes other hooks run in a non-blocking way","full_name":"jacklul/mkinitcpio-nbhooks","language":"Shell","pushed":"2024-07-06T15:51:31Z","stars":1}
{"description":"A hook to allow cryptsetup unlock by both SSH and plymouth","full_name":"jacklul/mkinitcpio-encryptssh","language":"Shell","pushed":"2024-07-06T15:51:26Z","stars":1}
{"description":"Download posts from e621.net","full_name":"jacklul/e621-Post-Downloader","language":"PHP","pushed":"2022-03-18T13:49:07Z","stars":1}
{"description":"Simple tool for organizing builds and equipment library","full_name":"jacklul/Vermintide-2-Builds-Organizer","language":"PHP","pushed":"2022-03-03T07:42:20Z","stars":1}
{"description":"Meow","full_name":"jacklul/jacklul","language":null,"pushed":"2023-04-28T21:03:07Z","stars":0}
===API-USER-REPOS===
{"description":"Helper application for using ALVR through USB connection","full_name":"jacklul/ALVR-USB","language":"C#","pushed":"2023-03-12T08:07:43Z","stars":4}
{"description":"An ANSI to HTML5 converter","full_name":"jacklul/ansi-to-html","language":null,"pushed":"2025-02-27T17:01:37Z","stars":0}
{"description":"Collection of scripts that can run on stock Asus routers (also on Merlin's firmware and forks)","full_name":"jacklul/asuswrt-scripts","language":"Shell","pushed":"2026-08-23T07:38:41Z","stars":157}
{"description":"Connect Raspberry Pi to Asus router through USB port using Ethernet Gadget functionality","full_name":"jacklul/asuswrt-usb-raspberry-pi","language":"Shell","pushed":"2026-06-12T15:12:40Z","stars":20}
{"description":"Filesystem wrapper that uses PSR-16 cache interface as storage","full_name":"jacklul/cachefs","language":"PHP","pushed":"2019-02-25T20:42:33Z","stars":0}
{"description":"Settings used for CachyOS","full_name":"jacklul/CachyOS-Settings","language":"Shell","pushed":"2024-08-24T11:43:14Z","stars":0}
{"description":null,"full_name":"jacklul/CuteDancer","language":"C#","pushed":"2022-06-09T07:01:58Z","stars":1}
{"description":"Wrapper for e621.net/e926.net API written in PHP","full_name":"jacklul/e621-api","language":"PHP","pushed":"2020-05-10T09:30:13Z","stars":3}
{"description":"Perform reverse search for all images in a directory (using e621.net/iqdb_queries, saucenao.com, fuzzysearch.net)","full_name":"jacklul/e621-Batch-Reverse-Search","language":"PHP","pushed":"2022-03-19T07:54:10Z","stars":61}
{"description":"Categorize art collection based on e621 rating and interaction tags","full_name":"jacklul/e621-Categorizer","language":"PHP","pushed":"2022-04-09T14:30:02Z","stars":0}
{"description":"Script making downloading and updating image pools from e621.net easier","full_name":"jacklul/e621-Pool-Downloader","language":"PHP","pushed":"2020-07-06T07:58:28Z","stars":19}
{"description":"Download posts from e621.net","full_name":"jacklul/e621-Post-Downloader","language":"PHP","pushed":"2022-03-18T13:49:07Z","stars":1}
{"description":"Simple Telegram bot that serves stuff from e621.net","full_name":"jacklul/e621-telegram-bot","language":"PHP","pushed":"2021-01-04T12:27:32Z","stars":5}
{"description":"Warn about hyperdiction before it happens","full_name":"jacklul/ED-Hyperdiction-Detector","language":"C#","pushed":"2018-12-29T22:53:38Z","stars":2}
{"description":"My personal EDHM theme","full_name":"jacklul/EDHM-profile","language":null,"pushed":"2025-08-23T13:47:28Z","stars":0}
{"description":null,"full_name":"jacklul/EDStatusPanel","language":"JavaScript","pushed":"2021-06-14T16:42:16Z","stars":0}
{"description":"Custom repository with extra packages, mainly for personal use","full_name":"jacklul/entware-packages","language":"Makefile","pushed":"2026-06-21T09:11:34Z","stars":2}
{"description":"Modified OpenWrt feed","full_name":"jacklul/entware-packages-fork","language":null,"pushed":"2026-07-08T20:44:16Z","stars":0}
{"description":"Pi-hole as an Entware package – run it on a router, older NAS, or other devices!","full_name":"jacklul/entware-pi-hole","language":"Shell","pushed":"2026-09-13T02:18:49Z","stars":31}
{"description":"Runs another exe file","full_name":"jacklul/ExeProxy","language":"C#","pushed":"2026-05-05T15:48:02Z","stars":0}
{"description":"Use Google's App Engine platform as WebDAV storage","full_name":"jacklul/GAEDrive","language":"PHP","pushed":"2020-11-17T12:50:11Z","stars":0}
{"description":"A tool to setup your GTA5 firewall rules easily. Adding IPs to your whitelist enables your friends to stay in your session.","full_name":"jacklul/GTA5Online-Private_Public_Lobby","language":"C#","pushed":"2020-07-30T07:32:36Z","stars":0}
{"description":"A proxy that upgrades HTTP connections to HTTPS for systems which cannot make HTTPS requests.","full_name":"jacklul/http-to-https-proxy","language":"Go","pushed":"2023-11-11T11:26:28Z","stars":1}
{"description":"A Telegram bot providing games that can be played in any chat via inline keyboards.","full_name":"jacklul/inlinegamesbot","language":"PHP","pushed":"2026-08-08T06:40:29Z","stars":130}
{"description":"Meow","full_name":"jacklul/jacklul","language":null,"pushed":"2023-04-28T21:03:07Z","stars":0}
{"description":null,"full_name":"jacklul/jacklul.github.io","language":"HTML","pushed":"2023-11-13T21:46:17Z","stars":0}
{"description":"Jump is a self-hosted startpage and real-time status page for your server designed to be simple, stylish, fast and secure. (PHP 7.4 fork)","full_name":"jacklul/jump-php7.4","language":"PHP","pushed":"2024-04-17T15:41:54Z","stars":0}
{"description":"Fork with support for 3C model","full_name":"jacklul/miio","language":"JavaScript","pushed":"2023-01-31T20:48:34Z","stars":0}
{"description":"A hook to allow cryptsetup unlock by both SSH and plymouth","full_name":"jacklul/mkinitcpio-encryptssh","language":"Shell","pushed":"2024-07-06T15:51:26Z","stars":1}
{"description":"Hook that makes other hooks run in a non-blocking way","full_name":"jacklul/mkinitcpio-nbhooks","language":"Shell","pushed":"2024-07-06T15:51:31Z","stars":1}
```

---

### 🤖 Assistant — 2026-09-14 16:33:23

**tool:bash** (completed) gh api users/jacklul/repos?per_page=100\&page=2 --jq '.[] | {full_name, stars: .stargazers_count, pushed: .pushed_at, language, description}' 2>&1 | head -n 100; echo "===SEARCH-proxy-manager==="; gh search repos "proxy-manager" --sort stars --limit 15 --json name,owner,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt 2>&1 | head -n 200

```
command=gh api users/jacklul/repos?per_page=100\&page=2 --jq '.[] | {full_name, stars: .
--- output ---
...output truncated...

Full output saved to: /home/x3/.local/share/opencode/tool-output/tool_09f0cd1fb001cwpNxZMhhUWDor

程之路 保姆级教程 AI实验室 宝藏视频 数据结构 学习指南 机器学习实战 深度学习实战 网络爬虫 大厂面经 程序人生 资源分享 中文文本分类基于pytorch 开箱即用 根据网易云音乐的歌单 下载flac无损音乐到本地腾讯优图高精度双分支人脸检测器文本纠错等模型实现 开箱即用 3 天掌握量化交易 持续更新 中文分词 词性标注 命名实体识别 依存句法分析 新词发现 关键词短语提取 自动摘要 文本分类聚类 拼音简繁 自然语言处理中文公开聊天语料库豆瓣读书的爬虫总结梳理自然语言处理工程师 NLP 需要积累的各方面知识 包括面试题 各种基础知识 工程能力等等 提升核心竞争力中文自然语言处理数据集 平时做做实验的材料 欢迎补充提交合并 一个可以自己进行训练的中文聊天机器人 根据自己的语料训练出自己想要的聊天机器人 可以用于智能客服 在线问答 智能聊天等场景 目前包含seq2seq seqGAN版本 tf2 版本 pytorch版本 股票量化框架 支持行情获取以及交易微博爬虫 持续维护 Bilibili 用户爬虫 deepin源移植 Debian Ubuntu上最快的QQ 微信安装方式 新闻网页正文通用抽取器 Beta 版 flag on post 自动更新域名解析到本机IP 支持dnspod 阿里DNS CloudFlare 华为云 DNSCOM 本项目针对字符型图片验证码 使用tensorflow实现卷积神经网络 进行验证码识别 owllook 小说搜索引擎中文语言理解测评基准python中文库 python人工智能大数据自动化接口测试开发 书籍下载及python库汇总china testing github io 2 19新型冠状病毒疫情时间序列数据仓库Python 黑魔法手册单阶段通用目标检测器一个拍照做题程序 输入一张包含数学计算题的图片 输出识别出的数学计算式以及计算结果 video download B站视频下载中文命名实体识别 TensorFlow Python 中文数据结构和算法教程 验证码识别 训练Python爬虫实战 模拟登陆各大网站 包含但不限于 滑块验证 拼多多 美团 百度 bilibili 大众点评 淘宝 如果喜欢请start ️学无止下载器 慕课下载器 Mooc下载 慕课网下载 中国大学下载 爱课程下载 网易云课堂下载 学堂在线下载 超星学习通下载 支持视频 课件同时下载一个高级web目录 文件扫描工具 功能将会强于DirBuster Dirsearch cansina 御剑 搜索所有中文NLP数据集 附常用英文NLP数据集中文实体识别与关系提取2 19新型冠状病毒疫情实时爬虫及github release archive以及项目文件的加速项目安卓应用安全学习抓取大量免费代理 ip 提取有效 ip 使用RoBERTa中文预训练模型 RoBERTa for Chinese 用于训练中英文对话系统的语料库敏感词过滤的几种实现 某1w词敏感词库简单易用的Python爬虫框架 QQ交流群 59751 56 使用Bert ERNIE 进行中文文本分类为 CSAPP 视频课程提供字幕 翻译 PPT Lab PyTorch 官方中文教程包含 6 分钟快速入门教程 强化教程 计算机视觉 自然语言处理 生成对抗网络 强化学习 欢迎 Star Fork 兜哥出品 <一本开源的NLP入门书籍 图像翻译 条件GAN AI绘画用Resnet1 1 GPT搭建一个玩王者荣耀的AI各种漏洞poc Exp的收集或编写斗地主AIVulmap 是一款 web 漏洞扫描和验证工具 可对 webapps 进行漏洞扫描 并且具备漏洞验证功能提供超過 5 個金融資料 台股為主 每天更新 finmind github io 数据接口 百度 谷歌 头条 微博指数 宏观数据 利率数据 货币汇率 千里马 独角兽公司 新闻联播文字稿 影视票房数据 高校名单 疫情数据 PyOne 一款给力的onedrive文件管理 分享程序 使用开发的用于迅速搭建并使用 WebHook 进行自动化部署和运维 支持 Github GitLab Gogs GitOsc 跟我一起写Makefile重制版 python自动化运维 技术与最佳实践 书中示例及案例源码自然语言处理实验 sougou数据集 TF IDF 文本分类 聚类 词向量 情感识别 关系抽取等微信公众平台 Python 开发包 DEPRECATED Weblogic一键漏洞检测工具 V1 5 更新时间 2 2 73 完备优雅的微信公众号接口 原生支持同步 协程使用 本程序旨在为安全应急响应人员对Linux主机排查时提供便利 实现主机侧Checklist的自动全面化检测 根据检测结果自动数据聚合 进行黑客攻击路径溯源 PyCharm 中文指南 安装 破解 效率 技巧类似按键精灵的鼠标键盘录制和自动化操作 模拟点击和键入GPT2 for Chinese chitchat 用于中文闲聊的GPT2模型 实现了DialoGPT的MMI思想 中华人民共和国国家标准 GB T 226 行政区划代码基于python的量化交易平台中文语音识别基于 OneBot 标准的 Python 异步 QQ 机器人框架Real World Masked Face Dataset 口罩人脸数据集 Vulfocus 是一个漏洞集成平台 将漏洞环境 docker 镜像 放入即可使用 开箱即用 谷歌 百度 必应图片下载 基于方面的情感分析 使用PyTorch实现 深度学习与计算机视觉 配套代码ART环境下自动化脱壳方案利用网络上公开的数据构建一个小型的证券知识图谱 知识库中文资源精选 官方网站 安装教程 入门教程 视频教程 实战项目 学习路径 QQ群 167122861 公众号 磐创AI 微信群二维码 www tensorflownews com Pre Trained Chinese XLNet 中文XLNet预训练模型 新浪微博Python SDK有关burpsuite的插件 非商店 文章以及使用技巧的收集 此项目不再提供burpsuite破解文件 如需要请在博客mrxn net下载Python3编写的CMS漏洞检测框架基于django的工作流引擎 工单 ️ 哔哩云 不支持任意文件的全速上传与下载微信SDK 包括微信支付 微信公众号 微信登陆 微信消息处理等中文自然语言理解堡垒机 云桌面自动化运维 审计 录像 文件管理 sftp上传 实时监控 录像回放 网页版rz sz上传下载 动态口令 django转换中国知网 CAJ 格式文献为 PDF 佛系转换 成功与否 皆是玄学 HanLP作者的新书 自然语言处理入门 详细笔记 业界良心之作 书中不是枯燥无味的公式罗列 而是用白话阐述的通俗易懂的算法模型 从基本概念出发 逐步介绍中文分词 词性标注 命名实体识别 信息抽取 文本聚类 文本分类 句法分析这几个热门问题的算法原理与工程实现 Python3 网络爬虫实战 部分含详细教程 猫眼 腾讯视频 豆瓣 研招网 微博 笔趣阁小说 百度热点 B站 CSDN 网易云阅读 阿里文学 百度股票 今日头条 微信公众号 网易云音乐 拉勾 有道 unsplash 实习僧 汽车之家 英雄联盟盒子 大众点评 链家 LPL赛程 台风 梦幻西游 阴阳师藏宝阁 天气 牛客网 百度文库 睡前故事 知乎 Wish微信公众号文章的爬虫 Python Web开发实战 书中源码一直可用的GoAgent 会定时扫描可用的google gae ip 提供可自动化获取ip运行的版本层剪枝 通道剪枝 知识蒸馏 中文命名实体识别 包括多种模型 HMM CRF BiLSTM BiLSTM CRF的具体实现 The Way to Go 中文译本 中文正式名 Go 入门指南 谢谢 Solutions to LeetCode by Go 1 % test coverage runtime beats 1 % LeetCode 题解一款轻量级 高性能 功能强大的内网穿透代理服务器 支持tcp udp socks5 http等几乎所有流量转发 可用来访问内网网站 本地支付接口调试 ssh访问 远程桌面 内网dns解析 内网socks5代理等等 并带有功能强大的web管理端 Go语言高级编程 开源图书 涵盖CGO Go汇编语言 RPC实现 Protobuf插件实现 Web框架实现 分布式系统等高阶主题 完稿 是一个跨平台的强加密无特征的代理软件 零配置 算法模板 最科学的刷题方式 最快速的刷题路径 你值得拥有 百度网盘不限速客户端 golang qt5 跨平台图形界面是golang实现的高性能http https websocket tcp socks5代理服务器 支持内网穿透 链式代理 通讯加密 夜读 通过 bilibili 在线直播的方式分享 Go 相关的技术话题 每天大家在微信 telegram Slack 上及时沟通交流编程技术话题 支持多家云存储的云盘系统 这里是写博客的地方 Halfrost Field 冰霜之地Lantern官方版本下载 蓝灯 翻墙 代理 科学上网 外网 加速器 梯子 路由基于gin vue搭建的后台管理系统框架 集成jwt鉴权 权限管理 动态路由 分页封装 多点登录拦截 资源权限 上传下载 代码生成器 表单生成器 通用工作流等基础功能 五分钟一套CURD前后端代码 目VUE3版本正在重构 欢迎issue和pr 分布式爬虫管理平台 支持任何语言和框架Golang标准库 对于程序员而言 标准库与语言本身同样重要 它好比一个百宝箱 能为各种常见的任务提供完美的解决方案 以示例驱动的方式讲解Golang的标准库 天用Go动手写 从零实现系列是一个高性能且低损耗的 goroutine 池 有 有 设计模式 Golang实现 研磨设计模式 读书笔记Golang实现的基于beego框架的接口在线文档管理系统高性能开源RTSP流媒体服务器 基于go语言研发 维护和优化 RTSP推模式转发 RTSP拉模式转发 是一个高性能 轻量级 非阻塞的事件驱动 Go 网络框架 基于Gin Vue Element UI的前后端分离权限管理系统脚手架 包含了 多租户的支持 基础用户管理功能 jwt鉴权 代码生成器 RBAC资源控制 表单构建 定时任务等 3分钟构建自己的中后台项目 文档蓝鲸智云配置平台 BlueKing CMDB 今日热榜 一个获取各大热门网站热门头条的聚合网站 使用Go语言编写 多协程异步快速抓取信息 预览 mo fish一条命令离线安装高可用kubernetes 3min装完 7 M 1 年证书 生产环境稳如老狗阿里巴巴开源的一款简单易用 功能强大的混沌实验注入工具 Go语言四十二章经 详细讲述Go语言规范与语法细节及开发中常见的误区 通过研读标准库等经典代码设计模式 启发读者深刻理解Go语言的核心思维 进入Go语言开发的更高阶段 ️一个轻巧的网络混淆代理 基于Golang轻量级TCP并发服务器框架定时任务管理系统KubeOperator 是一个开源的轻量级 Kubernetes 发行版 专注于帮助企业规划 部署和运营生产级别的 K8s 集群 本系统是集工单统计 任务钩子 权限管理 灵活配置流程与模版等等于一身的开源工单系统 当然也可以称之为工作流引擎 致力于减少跨部门之间的沟通 自动任务的执行 提升工作效率与工作质量 减少不必要的工作量与人为出错率 Go实现的Trojan代理 支持多路复用 路由功能 CDN中转 Shadowsocks混淆插件 多平台 无依赖 Go语法树入门 开启自制编程语言和编译器之旅 开源免费图书 Go语言进阶 掌握抽象语法树 Go语言AST 凹语言 一款可全平台运行的浏览器数据导出解密工具 Golang相关 审稿进度8 % Go语法 Go并发思想 Go与web开发 Go微服务设施等Jupiter是斗鱼开源的面向服务治理的Golang微服务框架Elasticsearch 可视化DashBoard 支持Es监控 实时搜索 Index template快捷替换修改 索引列表信息查看 SQL converts to DSL等 从问题切入 串连 Go 语言相关的所有知识 融会贯通 golang design go questionsWeChat SDK for Go 微信SDK 简单 易用 go fastdfs 是一个简单的分布式文件系统 私有云存储 具有无中心 高性能 高可靠 免维护等优点 支持断点续传 分块上传 小文件合并 自动同步 自动修复 Mastering GO 中文译本 玩转 GO 云原生且易用的应用管理平台 Go Web 基础 是一套针对 Google 出品的 Go 语言的视频语音教程 主要面向完成 Go 编程基础 教程后希望进一步了解有关 Go Web 开发的学习者 中文名 悟空 API 网关 是一个基于 Golang开发的微服务网关 能够实现高性能 HTTP API 转发 服务编排 多租户管理 API 访问权限控制等目的 拥有强大的自定义插件系统可以自行扩展 并且提供友好的图形化配置界面 能够快速帮助企业进行 API 服务治理 提高 API 服务的稳定性和安全性 集合多家 API 的新一代图床MIT课程 Distributed Systems 学习和翻译Go语言圣经中文版 只接收PR Issue请提交到golang china gopl zh trojan多用户管理部署程序 支持web页面管理BookStack 基于MinDoc 使用Beego开发的在线文档管理系统 功能类似Gitbook和看云 weixin wechat 微信公众平台 微信企业号 微信商户平台 微信支付 go golang sdk 蓝眼云盘 Eyeblue Cloud Storage 语言高性能编程 Go 语言陷阱 Gotchas Traps 使用 XMind 记录 Linux 操作系统 网络 C Golang 以及数据库的一些设计cqhttp的golang实现 轻量 原生跨平台 mqant是一款基于Golang语言的简洁 高效 高性能的分布式微服务框架基于react node js go开发的微商城 含微信小程序 MM Wiki 一个轻量级的企业知识分享与团队协同软件 可用于快速构建企业 Wiki 和团队知识分享平台 部署方便 使用简单 帮助团队构建一个信息共享 文档管理的协作环境 Go 语言中文网 Golang中文社区 Go语言学习园地 源码基于 Gin 进行模块化设计的 API 框架 封装了常用功能 使用简单 致力于进行快速的业务研发 比如 支持 cors 跨域 jwt 签名验证 zap 日志收集 panic 异常捕获 trace 链路追踪 prometheus 监控指标 swagger 文档生成 viper 配置文件解析 gorm 数据库组件 gormgen 代码生成工具 graphql 查询语言 errno 统一定义错误码 gRPC 的使用 等等 syncd是一款开源的代码部署工具 它具有简单 高效 易用等特点 可以提高团队的工作效率 一款由 YSRC 开源的主机入侵检测系统golang面试题集合这是一个可以识别视频语音自动生成字幕SRT文件的开源 Windows GUI 软件工具 一款内网综合扫描工具 方便一键自动化 全方位漏扫扫描 是一个用于在两个redis之间同步数据的工具 满足用户非常灵活的同步 迁移需求 Overlord是哔哩哔哩基于Go语言编写的memcache和redis cluster的代理及集群管理功能 致力于提供自动化高可用的缓存服务解决方案 Stack RPC 中文示例 教程 资料 源码解读ICMP流量伪装转发工具Freedom是一个基于六边形架构的框架 可以支撑充血的领域模型范式 Go2编程指南 开源图书 重点讲解Go2新特性 以及Go1教程中较少涉及的特性语言高性能分词golang写的IM服务器 服务组件形式 结巴 中文分词的Golang版本xorm是一个简单而强大的Go语言ORM库 通过它可以使数据库操作非常简便 本库是基于原版xorm的定制增强版本 为xorm提供类似ibatis的配置文件及动态SQL支持 支持AcitveRecord操作一个 Go 语言实现的快速 稳定 内嵌的 k v 数据库 高性能表格数据导出器基于Golang的开源社区系统 版本网易云音乐ncm文件格式转换 go 实现的压测工具 ab locust Jmeter压测工具介绍 单台机器1 w连接压测实战 抓包截取项目中的数据库请求并解析成相应的语句 Go专家编程 Go语言快速入门 轻松进阶 <<自己动手写docker 源码Go 每日一库kunpeng是一个Golang编写的开源POC框架 库 以动态链接库的形式提供各种语言调用 通过此项目可快速开发漏洞检测类的系统 vue js element框架 golang beego框架 开发的运维发布系统 支持git jenkins版本发布 go ssh BT两种文件传输方式选择 支持部署前准备任务和部署后任务钩子函数 Go 从入门到实战 学习笔记 从零开始学 Go Gin 框架 基本语法包括 26 个Demo Gin 框架包括 Gin 自定义路由配置 Gin 使用 Logrus 进行日志记录 Gin 数据绑定和验证 Gin 自定义错误处理 Go gRPC Hello World 持续更新中 Go 学习之路 Go 开发者博客 Go 微信公众号 Go 学习资料 文档 书籍 视频 微信 WeChat 支付宝 AliPay 的Go版本SDK 极简 易用的聚合支付SDK Go by Example 通过例子学 GolangPPGo Job是一款可视化的 多人多权限的 一任务多机执行的定时任务管理系统 采用golang开发 安装方便 资源消耗少 支持大并发 可同时管理多台服务器上的定时任务 Golang实现的IP代理池是一款用Go语言开发的web应用框架 API特性类似于Tornado并且拥有比Tornado更好的性能 自己动手写Java虚拟机 随书源代码支付宝 AliPay SDK for Go 集成简单 功能完善 持续更新 支持公钥证书和普通公钥进行签名和验签 ARCHIVED Geph 迷霧通帮助你将本地端口暴露在外网 支持TCP UDP 当然也支持HTTP 深入Go并发编程研讨课无状态子域名爆破工具手机号码归属地信息库 手机号归属地查询 phone dat 最后更新 2 21年 6月 golang基于websocket单台机器支持百万连接分布式聊天 IM 系统基于mongodb oplog的集群复制工具 可以满足迁移和同步的需求 进一步实现灾备和多活功能 Gin Gorm开发Golang API快速开发脚手架简单可信赖的任务管理工具Go语言实例教程从入门到进阶 包括基础库使用 设计模式 面试易错点 工具类 对接第三方等授权框架简体中文翻译 自动抓取tg频道 订阅地址 公开互联网上的ss ssr vmess trojan节点信息 聚合去重后提供节点列表轻量级 go 业务框架 哪吒监控 一站式轻监控轻运维系统 支持系统状态 TCP Ping 监控报警 命令批量执行和计划任务 Go 语言官方教程中文版工程师知识管理系统 基于golang go语言 beego框架 每个行业都有自己的知识管理系统 engineercms旨在为土木工程师们打造一款适用的基于web的知识管理系统 它既可以用于管理个人的项目资料 也可以用于管理项目团队资料 它既可以运行于个人电脑 也可以放到服务器上 支持提取码分享文件 onlyoffice实时文档协作 直接在线编辑dwg文件 office文档 在线利用mindoc创作你的书籍 阅览PDF文件 通用的业务流程设置 手机端配套小程序 微信搜索“珠三角设代”或“青少儿书画”即可呼出小程序 边界打点后的自动化渗透工具一个集审核 执行 备份及生成回滚语句于一身的MySQL运维工具汉字转拼音 Go资源精选中文版 含中文图书大全 语言实现的 Redis 服务器和分布式集群 超全golang面试题合集 golang学习指南 golang知识图谱 入门成长路线 一份涵盖大部分golang程序员所需要掌握的核心知识 常用第三方库 mysql mq es redis等 机器学习库 算法库 游戏库 开源框架 自然语言处理nlp库 网络库 视频库 微服务框架 视频教程 音频音乐库 图形图片库 物联网库 地理位置信息 嵌入式脚本库 编译器库 数据库 金融库 电子邮件库 电子书籍 分词 数据结构 设计模式 去html tag标签等 go学习 go面试go语言扩展包 收集一些常用的操作函数 辅助更快的完成开发工作 并减少重复代码百灵快传 基于Go语言的高性能 手机电脑超大文件传输神器 局域网共享文件服务器 LAN large file transfer tool 一个基于云存储的网盘系统 用于自建私人网盘或企业网盘 go分布式服务器 基于内存mmo个人博客微信小程序服务端 SDK for Golang 控制台颜色渲染工具库 支持16色 256色 RGB色彩渲染输出 使用类似于 Print Sprintf 兼容并支持 Windows 环境的色彩渲染基于 IoC 的 Go 后端一站式开发框架 v2ray web manager 是一个v2ray的面板 也是一个集群的解决方案 同时增加了流量控制 账号管理 限速等功能 key admin panel web cluster 集群 proxyServerScan一款使用Golang开发的高并发网络扫描 服务探测工具 是http client领域的瑞士军刀 小巧 强大 犀利 具体用法可看文档 如使用迷惑或者API用得不爽都可提issuesTcpRoute TCP 层的路由器 对于 TCP 连接自动从多个线路 电信 联通 移动 多个域名解析结果中选择最优线路 Bifrost 面向生产环境的 MySQL 同步到Redis MongoDB ClickHouse MySQL等服务的异构中间件应用网关 提供快速 安全的应用交付 身份认证 WAF CC HTTPS以及ACME自动证书 A telegram bot for rss reader 一个支持应用内阅读的 Telegram RSS Bot RESTful API 文档生成工具 支持和 Ruby 等大部分语言 基于gin gorm开发的个人博客项目基于Go语言的国密SM2 SM3 SM4算法库 Golang 设计模式一个阿里云盘列表程序 一款小巧的基于Go构建的开发框架 可以快速构建API服务或者Web网站进行业务开发 遵循SOLID设计原则并发编程实战 第2版 Go 学习 Go 进阶 Go 实用工具类 Go kit Go Micro 微服务实践 Go 推送基于DDD的o2o的业务模型及基础 使用Golang gRPC Thrift实现Sharingan 写轮眼 是一个基于golang的流量录制回放工具 适合项目重构 回归测试等 百度云网盘爬虫基于beego的进销存系统 TeaWeb 可视化的Web代理服务 DEMO teaos cn 白帽子安全开发实战 配套代码抖音推荐 搜索页视频列表视频爬虫方案 基于app 虚拟机或真机 相关技术 golang adb一款甲方资产巡航扫描系统 系统定位是发现资产 进行端口爆破 帮助企业更快发现弱口令问题 主要功能包括 资产探测 端口爆破 定时任务 管理后台识别 报表展示提供微信终端版本 微信命令行版本聊天功能 微信机器人 ️ 互联网最全大厂技术分享PPT 持续更新中 各大技术交流会 活动资料汇总 如 QCon 全球运维技术大会 GDG 全球技术领导力峰会 大前端大会 架构师峰会 敏捷开发DevOps OpenResty Elastic 欢迎 PR Issues日本麻将助手 牌效 防守 记牌 支持雀魂 天凤 开源客服系统GO语言开发GO FLY 免费客服系统一个查询IP地理信息和CDN服务提供商的离线终端工具 是一个用于系统重构 系统迁移和系统分析的瑞士军刀 它可以分析代码中的测试坏味道 模块化分析 行数统计 分析调用与依赖 Git 分析以及自动化重构等 一个直播录制工具Mastering Go 第二版中文版来袭 渗透测试情报收集工具分布式定时任务调度平台高度模块化 遵循 KISS原则的区块链开发框架golang版本的hangout 希望能省些内存 使用了自己写的Kafka lib 虚 不过我们在生产环境已经使用近1年 kafka 版本从 9 1到2 都在使用 目前情况稳定 吞吐量在每天2 亿条以上 Go 语言 Web 应用开发系列教程 从新手到双手残废iris 框架的后台api项目简单好用的DDNS 自动更新域名解析到公网IP 支持阿里云 腾讯云dnspod Cloudflare 华为云 自己动手实现Lua 随书源代码php直播go直播 短视频 直播带货 仿比心 猎游 tt语音聊天 美女约玩 陪玩系统源码开黑 约玩源码 社区开源 云原生的多云和混合云融合平台 Jiajun的编程随想Golang语言社区 腾讯课堂 网易云课堂 字节教育课程PPT及代码基于GF Go Frame 的后台管理系统带你了解一下Golang的市场行情mysql表结构自动同步工具 目前只支持字段 索引的同步 分区等高级功能暂不支持 基于Kubernetes的PaaS平台流媒体NetFlix解锁检测脚本稳定分支2 9 X 版本已更新 由 Golang语言游戏服务器 维护 全球服游戏服务器及区域服框架 目前协议支持websocket KCP TCP及RPC 采用状态同步 帧同步内测 愿景 打造MMO多人竞技游戏框架 功能持续更新中 基于 Golang 类似知乎的私有部署问答应用 包含问答 评论 点赞 管理后台等功能全新的开源漏洞测试框架 实现poc在线编辑 运行 批量测试 使用文档 XAPI MANAGER 专业实用的开源接口管理平台 为程序开发者提供一个灵活 方便 快捷的API管理工具 让API管理变的更加清晰 明朗 如果你觉得xApi对你有用的话 别忘了给我们点个赞哦 qq协议的golang实现 移植于miraigo版本极简工作流引擎全平台Go开源内网渗透扫描器框架 Windows Linux Mac内网渗透 使用它可轻松一键批量探测C段 B段 A段存活主机 高危漏洞检测MS17 1 SmbGhost 远程执行SSH Winrm 密码爆破端口扫描服务识别PortScan指纹识别多网卡主机 端口扫描服务识别PortScan iikira BaiduPCS Go原版基础上集成了分享链接 秒传链接转存功能 e签宝安全团队积累十几年的安全经验 都将对外逐步开放 首开的Ehoney欺骗防御系统 该系统是基于云原生的欺骗防御系统 也是业界唯一开源的对标商业系统的产品 欺骗防御系统通过部署高交互高仿真蜜罐及流量代理转发 再结合自研密签及诱饵 将攻击者攻击引导到蜜罐中达到扰乱引导以及延迟攻击的效果 可以很大程度上保护业务的安全 护网必备良药漂亮的Go语言通用后台管理框架 包含计划任务 MySQL管理 Redis管理 FTP管理 SSH管理 服务器管理 Caddy配置 云存储管理等功能 微信支付 WeChat Pay SDK for Golang用于监控系统的日志采集agent 可无缝对接open falcon阿里巴巴mysql数据库binlog的增量订阅 消费组件 Canal 的 go 客户端 github com alibaba canal 用于比较2个redis数据是否一致 支持单节点 主从 集群版 以及多种proxy 支持同构以及异构对比 redis的版本支持2 x 5 x 使用go micro微服务实现的在线电影院订票系统后端一站式微服务框架 提供API web websocket RPC 任务调度 消息消费服务器红蓝对抗跨平台远控工具Interchain protocol 跨链协议简单易用 足够轻量 性能好的 Golang 库一个go echo vue 开发的快速 简洁 美观 前后端分离的个人博客系统 blog 也可方便二次开发为CMS 内容管理系统 和各种企业门户网站 正在更新权限管理 hauth项目 不是一个前端or后台框架 而是一个集成权限管理 菜单资源管理 域管理 角色管理 用户管理 组织架构管理 操作日志管理等等的快速开发平台． hauth是一个基础产品 在这个基础产品上 根据业务需求 快速的开发应用服务．账号 admin 密码 123456通用的数据验证与过滤库 使用简单 内置大部分常用验证 过滤器 支持自定义验证器 自定义消息 字段翻译 CTF AWD Attack with Defense 线下赛平台 AWD platform 欢迎 Star 蓝鲸智云容器管理平台 BlueKing Container Service 程序员如何优雅的挣零花钱 2 版 升级为小书了 一个 PHP 微信 SDKAV 电影管理系统 avmoo javbus javlibrary 爬虫 线上 AV 影片图书馆 AV 磁力链接数据库ThinkPHP Framework 十年匠心的高性能PHP框架 最全的前端资源汇总仓库 包括前端学习 开发资源 求职面试等 多语言多货币多入口的开源电商 B2C 商城 支持移动端vue app html5 微信小程序微店 微信小程序商城等可能是我用过的最优雅的 Alipay 和 WeChat 的支付 SDK 扩展包了 基于词库的中文转拼音优质解决方案 我用爬虫一天时间“偷了”知乎一百万用户 只为证明PHP是世界上最好的语言 所使用的程序微信 SDK for Laravel 基于 overtrue wechat开源在线教育点播系统 一款满足你的多种发送需求的短信发送组件 基于 Laravel 的后台系统构建工具 Laravel Admin 使用很少的代码快速构建一个功能完善的高颜值后台系统 内置丰富的后台常用组件 开箱即用 让开发者告别冗杂的HTML代码一个想帮你总结所有类型的上传漏洞的靶场优雅的渐进式PHP采集框架 Laravel 电商实战教程的项目代码Payment是php版本的支付聚合第三方sdk 集成了微信支付 支付宝支付 招商一网通支付 提供统一的调用接口 方便快速接入各种支付 查询 退款 转账能力 服务端接入支付功能 方便 快捷 SPF Swoole PHP Framework 世界第一款基于Swoole扩展的PHP框架 开发者是Swoole创始人 A Wonderful WordPress Theme 樱花庄的白猫博客主题图床 此项目已弃用 基于 ThinkPHP 基础开发平台 登录账号密码都是 admin PanDownload网页复刻版一个开源的网址导航网站项目 您可以拿来制作自己的网址导航 使用PHP Swoole实现的网页即时聊天工具 独角数卡 发卡 开源式站长自动化售货解决方案 高效 稳定 快速 卡密商城系统 高效安全的在线卡密商城 ️命令行模式开发框架ShopXO免费开源商城系统 国内领先企业级B2C免费开源电商系统 包含PC h5 微信小程序 支付宝小程序 百度小程序 头条 抖音小程序 QQ小程序 APP 多商户 遵循MIT开源协议发布 基于 ThinkPHP5 1框架研发Wizard是一款开源的文档管理工具 支持Markdown Swagger Table类型的文档 Swoole MySQL Proxy 一个基于 MySQL 协议 Swoole 开发的MySQL数据库连接池 学习资源整合Freenom域名自动续期一个好玩的Web安全 漏洞测试平台一个基于Yii2高级框架的快速开发应用引擎蓝天采集器是一款免费的数据采集发布爬虫软件 采用php mysql开发 可部署在云服务器 几乎能采集所有类型的网页 无缝对接各类CMS建站程序 免登录实时发布数据 全自动无需人工干预 是网页大数据采集软件中完全跨平台的云端爬虫系统免费开源的中文搜索引擎 采用 C C 编写 基于 xapian 和 scws 提供 PHP 的开发接口和丰富文档WDScanner平台目前实现了如下功能 分布式web漏洞扫描 客户管理 漏洞定期扫描 子域名枚举 端口扫描 网站爬虫 暗链检测 坏链检测 网站指纹搜集 专项漏洞检测 代理搜集及部署等功能 ️兰空图床图标工场 移动应用图标生成工具 一键生成所有尺寸的应用图标和启动图 Argon 一个轻盈 简洁的 WordPress 主题Typecho Fans插件作品目录PHP代码审计分段讲解一个结构清晰的 易于维护的 现代的PHP Markdown解析器百度贴吧云签到 在服务器上配置好就无需进行任何操作便可以实现贴吧的全自动签到 配合插件使用还可实现云灌水 点赞 封禁 删帖 审查等功能 注意 Gitee 原Git osc 仓库将不再维护 目前唯一指定的仓库为 Github 本项目没有官方交流群 如需交流可以直接使用Github的Discussions 没有商业版本 目前贴吧云签到由社区共同维护 不会停止更新 PR 通常在一天内处理 微信调试 API调试和AJAX的调试的工具 能将日志通过WebSocket输出到Chrome浏览器的console中 結巴 中文分詞 做最好的 PHP 中文分詞 中文斷詞組件EleTeam开源项目 电商全套解决方案之PHP版 Shop for PHP Yii2 一个类似京东 天猫 淘宝的商城 有对应的APP支持 由EleTeam团队维护 RhaPHP是微信第三方管理平台 微信公众号管理系统 支持多公众号管理 CRM会员管理 小程序开发 APP接口开发 几乎集合微信功能 简洁 快速上手 快速开发微信各种各样应用 简洁 好用 快速 项目开发快几倍 群 656868 一刻社区后端 API 源码 新 微信服务号 微信小程序 微信支付 支付宝支付苹果cms v1 maccms v1 麦克cms 开源cms 内容管理系统 视频分享程序 分集剧情程序 网址导航程序 文章程序 漫画程序 图片程序一个PHP文件搞定支付宝支付系列 包括电脑网站支付 手机网站支付 现金红包 消费红包 扫码支付 JSAPI支付 单笔转账到支付宝账户 交易结算 分账 分润 网页授权获取用户信息等restful api风格接口 APP接口 APP接口权限 oauth2 接口版本管理 接口鉴权基于企业微信的开源SCRM应用开发框架 引擎 也是一套通用的企业私域流量管理系统 API接口大全不断更新中 欢迎Fork和Star 1 一言 古诗句版 api 2 必应每日一图api 3 在线ip查询 4 m3u8视频在线解析api 5 随机生成二次元图片api 6 快递查询api 支持国内百家快递 7 flv视频在线解析api 8 抖音视频无水印解析api 9 一句话随机图片api 1 QQ用户信息获取api 11 哔哩哔哩封面图获取api 12 千图网58pic无水印解析下载api 13 喜马拉雅主播FM数据采集api 14 网易云音乐api 15 CCTV央视网视频解析api 16 微信运动刷步数api 17 皮皮搞笑 基于swoole的定时器程序 支持秒级处理群 656868 ️ Saber PHP异步协程HTTP客户端微信支付单文件版 一个PHP文件搞定微信支付系列 包括原生支付 扫码支付 H5支付 公众号支付 现金红包 企业付款到零钱等 新增V3版 一个还不错的图床工具 支持Mac Win Linux服务器 支持压缩后上传 添加图片或文字水印 多文件同时上传 同时上传到多个云 右击任意文件上传 快捷键上传剪贴板截图 Web版上传 支持作为Mweb Typora发布图片接口 作为PicGo ShareX uPic等的自定义图床 支持在服务器上部署作为图床接口 支持上传任意格式文件 可能是我用过的最优雅的 Alipay 和 WeChat 的 laravel 支付扩展包了上传大文件的Laravel扩展包开发内功修炼Laravel核心代码学习南京邮电大学开源 Online Judge QQ群 6681 8264 免费IP地址数据库 已支持IPV4 IPV6 结构化输出为国家 省 市 县 运营商 中文数据库 方便实用 laravel5 5和vue js结合的前后端分离项目模板 后端使用了laravel的LTS版本 5 5 前端使用了流行的vue element template项目 作为程序的起点 可以直接以此为基础来进行业务扩展 模板内容包括基础的用户管理和权限管理 日志管理 集成第三方登录 整合laravel echo server 实现了websocket 做到了消息的实时推送 并在此基础上 实现了聊天室和客服功能 权限管理包括后端Token认证和前端vue js的动态权限 解决了前后端完整分离的情况下 vue js的认证与权限相关的痛点 已在本人的多个项目中集成使用 Web安全之机器学习入门 网易云音乐升级APIPHP 集成支付 SDK 集成了支付宝 微信支付的支付接口和其它相关接口的操作 支持 php fpm 和 Swoole 所有框架通用 宇润PHP全家桶技术支持群 17916227MDClub 社区系统后端代码imi 是基于 Swoole 的 PHP 协程开发框架 它支持 Http2 WebSocket TCP UDP MQTT 等主流协议的服务开发 特别适合互联网微服务 即时通讯聊天im 物联网等场景 QQ群 17916227WordPress 版 WebStack 导航主题 nav iowen cnLive2D 看板娘插件 www fghrsh net post 123 html 上使用的后端 API简单搜索 一个简单的前端界面 用惯了各种导航首页 满屏幕尽是各种不厌其烦的广告和资讯 尝试自己写个自己的主页 国内各大CTF赛题及writeup整理收集自网络各处的 webshell 样本 用于测试 webshell 扫描器检测率 PHP微信SDK 微信平台 微信支付 码小六 GitHub 代码泄露监控系统PHP表单生成器 快速生成现代化的form表单 支持前后端分离 内置复选框 单选框 输入框 下拉选择框 省市区三级联动 时间选择 日期选择 颜色选择 文件 图片上传等17种常用组件 悟空CRM 基于TP5 vue ElementUI的前后端分离CRM系统V免签PHP版 完全开源免费的个人免签约解决方案Composer 全量镜像发布于2 17年3月 曾不间断运行2年多 这个开源有助于理解 Composer 镜像的工作原理一个多彩 轻松上手 体验完善 具有强大自定义功能的WordPress主题 基于Sakura主题全球免费代理IP库 高可用IP 精心筛选优质IP 2s必达LaraCMS 是在学习 laravel web 开发实战进阶 实战构架 API 服务器 过程中产生的一个业余作品 试图通过简单的方式 快速构建一套基本的企业站同时保留很灵活的扩展能力和优雅的代码方式 当然这些都得益Laravel的优秀设计 同时LaraCMS 也是一个学习Laravel 不错的参考示例 已停止维护 HookPHP基于C扩展搭建内置AI编程的架构系统 支持微服务部署 热插拔业务组件 集成业务模型 权限模型 UI组件库 多模板 多平台 多域名 多终端 多语言 含常驻内存 前后分离 API平台 LUA QQ群 67911638 中华人民共和国居民身份证 中华人民共和国港澳居民居住证以及中华人民共和国台湾居民居住证号码验证工具 PHP 版 最简单的91porn爬虫php版本Fend 是一款短小精悍 可在 FPM Swoole 服务容器平滑切换的高性能PHP框架 no evil 实现过滤敏感词汇 基于确定有穷自动机 DFA 算法 支持composer安装扩展Z BlogPHP博客程序IYUU自动辅种工具 目前能对国内大部分的PT站点自动辅种 支持下载器集群 支持多盘位 支持多下载目录 支持远程连接等 果酱小店 基于 Laravel swoole 小程序的开源电商系统 优雅与性能兼顾 這是一份純靠北工程師的專案 請好好愛護它 謝謝 EC ecjia 到家是一款可开展O2O业务的移动电商系统 它包含 移动端APP 采用原生模式开发 覆盖使用iOS 及Android系统的移 动终端 后台系统 针对平台日常运营维护的平台后台 针对入驻店铺管理的商家后台 独立并行 移动端H5 能够灵活部署于微信及其他APP 网页等 Material Design 指南的中文翻译 一个纯php分词 thinkphp5 1 layui 实现的带rbac的基础管理后台 方便快速开发法使用百度pcs上传脚本目前最全的前端开发面试题及答案樱花内网穿透网站源代码 2 2 重制版MeepoPS是Meepo PHP Socket的缩写 旨在提供稳定的Socket服务 可以轻松构建在线实时聊天 即时游戏 视频流媒体播放等 基础目录 聚合所有其他目录 包含文档和例子基于 Vue js 的简洁一般强大的 WordPress 单栏博客主题阿里云打造Laravel最好的OSS Storage扩展 网上在线商城 综合网上购物平台swoolefy是一个基于swoole实现的轻量级 高性能 协程级 开放性的API应用服务框架基于redis实现高可用 易拓展 接入方便 生产环境稳定运行的延迟队列 一款基于WordPress开发的高颜值的自适应主题 支持白天与黑夜模式 无刷新加载等 阿里云 OSS 官方 SDK 的 Composer 封装 支持任何 PHP 项目 包括 Laravel Symfony TinyLara 等等 此插件将你的WordPress接入本土生态体系之中 使之更适合国内应用环境PHP的服务化框架 适用于Api Server Rpc Server 帮助原生PHP项目转向微服务化 出色的性能与支持高并发的协程相结合基于ThinkPHP V6 开发的面向API的后台管理系统 PHP Swoole 开发的在线同步点歌台 支持自由点歌 切歌 调整排序 删除指定音乐以及基础权限分级信呼 免费开源的办公OA系统 包括APP pc上客户端 REIM即时通信 服务端等 让每个企业单位都有自己的办公系统 来客电商 微信小程序商城 APP商城 公众号商城 PC商城系统 支付宝小程序商城 抖音小程序商城 百度小程序电商系统 前后端代码全部开源 注重界面美感与用户体验 打造独特电商系统生态圈哔哩哔哩 Bilibili B 站主站助手 直播助手 直播抽奖 挂机升级 贴心小棉袄脚本 Lv6 离你仅有一步之遥 PHP 版 Personal 一个运用php与swoole实现的统计监控系统短视频去水印 抖音 皮皮虾 火山 微视 微博 绿洲 最右 轻视频 快手 全民小视频 巴塞电影 陌陌 Before避风 开眼 Vue Vlog 小咖秀 皮皮搞笑 全民K歌 西瓜视频 中国农历 阴历 与阳历 公历 转换与查询工具AoiAWD 专为比赛设计 便携性好 低权限运行的EDR系统 项目管理系统后端接口ThinkPHP 队列支持Typecho Theme Aria 书写自己的篇章PHP 中文工具包 支持汉字转拼音 拼音分词 简繁互转 数字 金额大写 QQ群 17916227Yii2 community 请访问淘客5合一SDK 支持淘宝联盟 京东联盟 多多进宝 唯品会 苏宁基于 thinkphp 开发的的 blogMojito Admin 基于 Laravel Vue Element 构建的后台管理系统一个经典的XSS渗透管理平台一款基于 RageFrame2 的免费开源的基础销售功能的商城基于Laravel 5 4 的开发的博客系统 代号 myPersimmon证件照片排版在线生成器 在一张6寸的照片上排版多张证件照清华大学计算机学科推荐学术会议和期刊列表WordPress响应式免费主题 Art Blog唯品秀博客 weipxiu com 备用域名weipxiu cn 开源给小伙伴免费使用 如使用过程有任何问题 在线技术支持QQ 欢迎打扰 原创不易 如喜欢 请多多打赏 演示 EwoMail是基于Linux的企业邮箱服务器 集成了众多优秀稳定的组件 是一个快速部署 简单高效 多语言 安全稳定的邮件解决方案 笔记本新版简单强大的无数据库的图床2 版 演示地址 Bilibili B 站自动领瓜子 直播助手 直播挂机脚本 主站助手 PHP 版微信群二维码活码工具 生成微信群活码 随时可以切换二维码 短视频的PHP拓展包 集成各大短视频的去水印功能 抖音 快手 微视主流短视频 PHP去水印一个PHPer的升级之路酷瓜云课堂 在线教育 网课系统 网校系统 知识付费系统 不加密不阉割 1 %全功能开源 可免费商用 框架主要使用ThinkPHP6 layui 拥有完善的权限的管理模块以及敏捷的开发方式 让你开发起来更加的舒服 laravel5 5搭建的后台管理 和 api服务 的小程序商城基于ThinkPHP5 AdminLTE的后台管理系统魔改版本 为 OLAINDEX 添加多网盘挂载及一些小修复海豚PHP 基于ThinkPHP5 1 41LTS的快速开发框架挂载Teambition文件 可直链分享 支持网盘 需申请 和项目文件 无需邀请码 准确率99 9%的ip地址定位库laravel ant design vue 权限后台PHP 第三方登录授权 SDK 集成了QQ 微信 微博 Github等常用接口 支持 php fpm 和 Swoole 所有框架通用 QQ群 17916227抖音去水印PHP版接口一个分布式统计监控系统 包含PHP客户端 服务端整合多接口的IP查询工具 基于阿里云OSS的WordPress远程附件支持插件 后会有期 开箱即用的Laravel后台扩展 前后端分离 后端控制前端组件 无需编写vue即可创建一个的项目 丰富的表单 表格组件 强大的自定义组件功能 yii2 swoole 让yii2运行在swoole上胖鼠采集 WordPress优秀开源采集插件CatchAdmin是一款基于thinkphp6 和 element admin 开发的后台管理系统 基于 ServiceProvider 系统模块完全接耦 随时卸载安装模块 提供了完整的权限和数据权限等功能 大量内置的开发工具提升你的开发体验 官网地址 微信公众平台php版开发包微信小程序 校园小情书后台源码 好玩的表白墙 告白墙 功能全面的PHP命令行应用库 提供控制台参数解析 命令运行 颜色风格输出 用户信息交互 特殊格式信息显示基于 chinese poetry 数据整理的一份 mysql 格式数据帮助 thinkphp 5 开发者快速 轻松的构建Api hyperf admin 是基于 hyperf vue 的配置化后台开发工具 微信支付php 写的视频下载工具 现已支持 Youku Miaopai 腾讯 XVideos Pornhub 91porn 微博酷燃 bilibili 今日头条 芒果TVCorePress 主题 一款高性能 高颜值的WordPress主题快链电商 直播电商 分销商城 微信小程序商城 APP商城 公众号商城 PC商城系统 支付宝小程序商城 抖音小程序商城 百度小程序电商系统 前后端代码全部开源 Laravel vue开发 成熟商用项目 shop mall 商城 电商 利用 PHP cURL 转发 Disqus API 请求可能是最优雅 简易的淘宝客SDKUniAdmin是一套渐进式模块化开源后台 采用前后端分离技术 数据交互采用json格式 功能低耦合高内聚 核心模块支持系统设置 权限管理 用户管理 菜单管理 API管理等功能 后期上线模块商城将打造类似composer npm的开放式插件市场 同时我们将打造一套兼容性的API标准 从ThinkPHP5 1 Vue2开始 逐步吸引爱好者共同加入 以覆盖等多语言框架 PHP 多接口获取快递物流信息包LightCMS 是一个基于 Laravel 开发的轻量级 CMS 系统 也可以作为一个通用的后台管理框架使用单点登录系统快乐二级域名分发系统Typecho Theme Story 爱上你我的故事 一个轻量化的留言板 记事本 社交系统 博客 人类的本质是 咕咕咕？微信域名拦截检测 QQ域名拦截检测 t xzkxb com 查询有缓存 如需实时查询请自行部署 高性能分布式并发锁 行为限流Emlog是一款基于PHP和MySQL的功能强大的博客及CMS建站系统 追求快速 稳定 简单 舒适的建站体验Hyperf admin 基于Hyperf Element UI 通用管理后台企业仓库管理系统HisiPHP V2版是基于ThinkPHP5 1和Layui开发的后台框架 承诺永久免费开源 您可用于学习和商用 但须保留版权信息正常显示 如果HisiPHP对您有帮助 您可以点击右上角 Star 支持一下哦 谢谢 使用PHP开发的简约导航 书签管理系统 软擎是基于 Php 7 2 和 Swoole 4 4 的高性能 简单易用的开发框架 支持同时在 Swoole Server 和 php fpm 两种模式下运行 内置了服务 集成了大量成熟的组件 可以用于构建高性能的Web系统 API 中间件 基础服务等等 个人发卡源码 发卡系统 二次元发卡系统 二次元发卡源码 发卡程序 动漫发卡 PHP发卡源码聊天应用 php实现的dht爬虫搭建的webim客服系统 即时通讯一些实用的python脚本同城拼车微信小程序后端代码 一个响应式干净和简洁优雅的 Typecho 主题php仓库进销存深度学习5 问 以问答形式对常用的概率知识 线性代数 机器学习 深度学习 计算机视觉等热点问题进行阐述 以帮助自己及有需要的读者 全书分为18个章节 5 余万字 由于水平有限 书中不妥之处恳请广大读者批评指正 未完待续 如有意合作 联系scutjy2 15 163 com 版权所有 违权必究 Tan 2 18 6题解 记录自己的leetcode解题之路 最全中华古诗词数据库 唐宋两朝近一万四千古诗人 接近5 5万首唐诗加26万宋诗 两宋时期1564位词人 21 5 首词 uni app 是使用 Vue 语法开发小程序 H5 App的统一框架采用自身模块规范编写的前端 UI 框架 遵循原生 HTML CSS JS 的书写形式 极低门槛 拿来即用 我是依扬 木易杨 公众号 高级前端进阶 作者 每天搞定一道前端大厂面试题 祝大家天天进步 一年后会看到不一样的自己 YApi 是一个可本地部署的 打通前后端及QA的 可视化的接口管理平台小程序组件化开发框架网易云音乐 Node js API service基于 Vue js 的小程序开发框架 从底层支持 Vue js 语法和构建工具体系 ECMAScript 6入门 是一本开源的 JavaScript 语言教程 全面介绍 ECMAScript 6 新增的语法特性 谷粒 Chrome插件英雄榜 为优秀的Chrome插件写一本中文说明书 让Chrome插件英雄们造福人类公众号 加1 同步更新前端面试每日 3 1 以面试题来驱动学习 提倡每日学习与思考 每天进步一点 每天早上5点纯手工发布面试题 死磕自己 愉悦大家 4 道前端面试题全面覆盖小程序 软技能 本文原文由知名 Hacker Eric S Raymond 所撰寫 教你如何正確的提出技術問題並獲得你滿意的答案 千古前端图文教程 超详细的前端入门到进阶学习笔记 从零开始学前端 做一名精致优雅的前端工程师 公众号 千古壹号 作者 book Node js 包教不包会 by alsotang收集所有区块链 BlockChain 技术开发相关资料 包括Fabric和Ethereum开发资料轻量 可靠的小程序 UI 组件库微信小程序商城 微信小程序微店一个可以观看国内主流视频平台所有视频的客户端可伸缩布局方案基于 node js Mongodb 构建的后台系统 js 源码解析磁力链接聚合搜索中华人民共和国行政区划 省级 省份直辖市自治区 地级 城市 县级 区县 乡级 乡镇街道 村级 村委会居委会 中国省市区镇村二级三级四级五级联动地址数据 Web接口管理工具 开源免费 接口自动化 MOCK数据自动生成 自动化测试 企业级管理 阿里妈妈MUX团队出品 阿里巴巴都在用 1 公司的选择 RAP2已发布请移步至github com thx rap2 delosKuboard 是基于 Kubernetes 的微服务管理界面 同时提供 Kubernetes 免费中文教程 入门教程 最新版本的 Kubernetes v1 2 安装手册 k8s install 在线答疑 持续更新 ApacheCN 数据结构与算法译文集 chick 是使用 Node js 和 MongoDB 开发的社区系统一个非常适合IT团队的在线API文档 技术文档工具 Chinese sticker pack More joy 表情包的博物馆 Github最有毒的仓库 中国表情包大集合 聚欢乐 高颜值的第三方网易云播放器 支持 Windows macOS Linux vue2 vue router vuex 入门项目网易云音乐第三方 Flutter实战 电子书 一套代码运行多端 一端所见即多端所见 计算机速成课 Crash Course 字幕组 全4 集 2 18 5 1 精校完成 一个 react redux 的完整项目 和 个人总结中文独立博客列表CSS Inspiration 在这里找到写 CSS 的灵感 rich text 富文本编辑器 汉字拼音 hàn zì pīn yīn Chrome插件开发全攻略 配套完整Demo 欢迎clone体验微信调试 各种WebView样式调试 手机浏览器的页面真机调试 便捷的远程调试手机页面 抓包工具 支持 HTTPS 无需USB连接设备 master分支 渲染器 微信小程序组件 API 云开发示例简悦 SimpRead 让你瞬间进入沉浸式阅读的扩展让H5制作像搭积木一样简单 轻松搭建H5页面 H5网站 PC端网站 LowCode平台 一套组件化 可复用 易扩展的微信小程序 UI 组件库这是一个数据可视化项目 能够将历史数据排名转化为动态柱状图图表微信小程序图表charts组件 Charts for WeChat small app类似易企秀的H5制作 建站工具 可视化搭建系统 一个在你编程时疯狂称赞你的 VSCode 扩展插件全家桶后台管理框架解锁网易云音乐客户端变灰歌曲美观易用的React富文本编辑器 基于draft js开发一个致力于微信小程序和 Web 端同构的解决方案從零開始學 ReactJS ReactJS 1 1 是一本希望讓初學者一看就懂的 React 中文入門教學書 由淺入深學習 ReactJS 生態系源码解读 系列文章 完 我就是来分享脚本玩玩的开发者边车 github打不开 github加速 git clone加速 git release下载加速 stackoverflow加速vue源码逐行注释分析 4 多m的vue源码程序流程图思维导图 diff部分待后续更新 微信小程序解决方案 1KB javascript 覆盖状态管理 跨页通讯 插件开发和云数据库开发给老司机用的一个番号推荐系统 FeHelper Web前端助手记录成长的过程哔哩哔哩 bilibili com 辅助工具 可以替换播放器 推送通知并进行一些快捷操作提供了百度坐标 BD 9 国测局坐标 火星坐标 GCJ 2 和WGS84坐标系之间的转换F2etest是一个面向前端 测试 产品等岗位的多浏览器兼容性测试整体解决方案 ️ 阿里飞猪 很易用的中后台 表单 表格 图表 解决方案CRMEB Min 前后端分离版自带客服系统 是CRMEB品牌全新推出的一款轻量级 高性能 前后端分离的开源电商系统 完善的后台权限管理 会员管理 订单管理 产品管
```

---

### 🤖 Assistant — 2026-09-14 16:33:33

**tool:bash** (completed) gh search repos "proxy-manager" --sort stars --limit 12 --json fullName,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt 2>&1 | python3 -c "import json,sys; data=json.load(sys.stdin); print(f'count={len(data)}'); [print(f\"{r['fullName']} | stars={r['stargazersCount']} | lang={r['language']} | push={r['pushedAt'][:10]} | {r['description'][:90]}\") for r in data]"

```
command=gh search repos "proxy-manager" --sort stars --limit 12 --json fullName,descript
--- output ---
count=12
NginxProxyManager/nginx-proxy-manager | stars=34132 | lang=TypeScript | push=2026-09-09 | Docker container for managing Nginx proxy hosts with a simple, powerful interface
MatsuriDayo/nekoray | stars=15361 | lang=C++ | push=2024-12-12 | 不再维护，自寻替代品。 Qt based cross-platform GUI proxy configuration manager (backend: sing-box)
Prowlarr/Prowlarr | stars=7206 | lang=C# | push=2026-09-13 | Prowlarr is an indexer manager/proxy built on the popular *arr .net/reactjs base stack to 
Ocramius/ProxyManager | stars=4943 | lang=PHP | push=2026-09-09 | 🎩✨🌈 OOP Proxy wrappers/utilities - generates and manages proxies of your objects
cirosantilli/china-dictatorship | stars=3201 | lang=HTML | push=2026-02-05 | 反中共政治宣传库。Anti Chinese government propaganda. 住在中国真名用户的网友请别给星星，不然你要被警察请喝茶。常见问答集，新闻集和饭店和音乐建议
cheeselemon/ophiuchi-desktop | stars=2020 | lang=TypeScript | push=2025-06-13 | Localhost SSL Proxy Server Manager using Docker
gege-circle/.github | stars=2007 | lang= | push=2025-10-04 | 这里是GitHub的草场，也是戈戈圈爱好者的交流地，主要讨论动漫、游戏、科技、人文、生活等所有话题，欢迎各位小伙伴们在此讨论趣事。This is GitHub grassland,
ZeroDeng01/sublinkPro | stars=1632 | lang=Go | push=2026-09-14 | ✨ 现代化代理订阅管理平台 | 智能分类 · 专业测速 · 链式中转 · 流量监控 · TG管理 · JS扩展 | Go+React 全新UI 🌍 Modern Proxy Sub
hcavarsan/kftray | stars=1560 | lang=Rust | push=2026-09-14 | kubectl port-forward manager and reverse tunnel (ngrok-like) for exposing local  services 
Safe3/openresty-manager | stars=1452 | lang=Go | push=2026-08-19 | Modern, secure, and elegant server control panel, alternative to OpenResty Edge and Nginx 
master-coder-ll/v2ray-web-manager | stars=1429 | lang=Go | push=2023-12-28 | v2ray-web-manager 是一个v2ray的面板，也是一个集群的解决方案；同时增加了流量控制/账号管理/限速等功能。key: admin , panel ,web,clu
FriendsOfPHP/proxy-manager-lts | stars=1208 | lang=PHP | push=2025-10-28 | Adding support for a wider range of PHP versions to ocramius/proxy-manager.
```

---

### 🤖 Assistant — 2026-09-14 16:33:40

**tool:bash** (completed) gh search repos "socks5 proxy pool validation go" --sort stars --limit 20 --json fullName,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt 2>&1 | python3 -c "import json,sys; data=json.load(sys.stdin); print(f'count={len(data)}'); [print(f\"{r['fullName']} | s={r['stargazersCount']} | lang={r['language']} | push={r['pushedAt'][:10]} | open={r['openIssuesCount']} | {str(r['description'])[:100]}\") for r in data]"

```
command=gh search repos "socks5 proxy pool validation go" --sort stars --limit 20 --json
--- output ---
count=0
```

---

### 🤖 Assistant — 2026-09-14 16:33:50

**tool:bash** (completed) gh search repos "socks5 proxy pool go" --sort stars --limit 20 --json fullName,description,stargazersCount,updatedAt,language,license,url,openIssuesCount,pushedAt 2>&1 | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d)); [print(r['fullName'],r['stargazersCount'],r['language'],r['pushedAt'][:10],str(r['description'])[:110]) for r in d]"; echo "===2==="; gh api -X GET search/repositories -f q='socks5 proxy pool language:go stars:>5' -f sort=stars -f order=desc --jq '.items[] | "\(.full_name) | s=\(.stargazers_count) | push=\(.pushed_at[0:10]) | \(.description // "" | .[0:100])"' 2>&1 | head -n 30

```
command=gh search repos "socks5 proxy pool go" --sort stars --limit 20 --json fullName,d
--- output ---
0
===2===
yukkcat/socks5-proxy | s=193 | push=2026-06-18 | Self-rotating SOCKS5 proxy pool with auto-failover, health checks, and web dashboard
hedioum/Hedioum-Pool-Tunnel | s=134 | push=2026-08-19 | High-performance open-source anti-DPI / anti-censorship tunnel in Go. Hides VLESS/Trojan traffic beh
yunginnanet/prox5 | s=81 | push=2024-10-07 | 🧮 SOCKS5/4/4a 🌾 validating proxy pool and upstream SOCKS5 server for 🤽 LOLXDsoRANDum connections 🎋 
XiaoMiku01/go-proxy-ipv6-pool | s=42 | push=2024-01-15 | Random ipv6 egress proxy server (support http/socks5)
Vozec/Flarex | s=17 | push=2026-04-19 | SOCKS5 / HTTP CONNECT proxy that load-balances outbound traffic across a pool of dynamically deploye
Qingluan/merkur | s=11 | push=2022-06-18 | golang proxy.Dialer  lib for http or raw tcp , / socks5 / ss / ssr / vmess / ordered url / and Proxy
komomon/komoproxy | s=9 | push=2024-01-15 | Socks5 proxy pool polling tool, supports ipv6 proxy, supports fofa collection proxy, supports import
```

---

### 🤖 Assistant — 2026-09-14 16:33:58

Found core set. Gathering metadata, go.mod, CI, API surface for each.

**tool:todowrite** (completed) 2 todos

```
todos=[{'content': 'Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh 
--- output ---
[
  {
    "content": "Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh api",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "gh search repos socks5 proxy pool validation go",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Collect metadata: stars/issues/push/license/go.mod/CI/API surface",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Deliver comparison table + verdicts under 1200 words",
    "status": "pending",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-14 16:34:03

**tool:bash** (completed) for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vozec/Flarex Qingluan/merkur jacklul/http-to-https-proxy; do echo "===== $r ====="; gh api repos/$r --jq '{stars: .stargazers_count, open_issues: .open_issues_count, pushed: .pushed_at, license: .license.spdx_id, default_branch}'; done 2>&1

```
command=for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vo
--- output ---
===== yunginnanet/prox5 =====
{"default_branch":"main","license":"MIT","open_issues":3,"pushed":"2024-10-07T16:01:27Z","stars":81}
===== yukkcat/socks5-proxy =====
{"default_branch":"main","license":null,"open_issues":0,"pushed":"2026-06-18T08:09:08Z","stars":193}
===== XiaoMiku01/go-proxy-ipv6-pool =====
{"default_branch":"main","license":"MIT","open_issues":0,"pushed":"2024-01-15T08:16:37Z","stars":42}
===== Vozec/Flarex =====
{"default_branch":"main","license":"NOASSERTION","open_issues":1,"pushed":"2026-04-19T18:23:23Z","stars":17}
===== Qingluan/merkur =====
{"default_branch":"master","license":"GPL-3.0","open_issues":1,"pushed":"2022-06-18T02:16:44Z","stars":11}
===== jacklul/http-to-https-proxy =====
{"default_branch":"master","license":"MIT","open_issues":0,"pushed":"2023-11-11T11:26:28Z","stars":1}
```

---

### 🤖 Assistant — 2026-09-14 16:34:14

**tool:bash** (completed) for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vozec/Flarex Qingluan/merkur; do echo "===== $r go.mod ====="; gh api repos/$r/contents/go.mod --jq '.content' 2>&1 | base64 -d 2>&1 | head -n 15; echo ""; done

```
command=for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vo
--- output ---
===== yunginnanet/prox5 go.mod =====
module git.tcp.direct/kayos/prox5

go 1.19

require (
	git.tcp.direct/kayos/common v0.9.7
	git.tcp.direct/kayos/go-socks5 v0.3.0
	git.tcp.direct/kayos/socks v0.1.3
	github.com/gdamore/tcell/v2 v2.7.1
	github.com/miekg/dns v1.1.59
	github.com/ooni/oohttp v0.6.7
	github.com/orcaman/concurrent-map/v2 v2.0.1
	github.com/panjf2000/ants/v2 v2.9.1
	github.com/refraction-networking/utls v1.6.0
	github.com/rivo/tview v0.0.0-20230208211350-7dfff1ce7854

===== yukkcat/socks5-proxy go.mod =====
module socks5-pool

go 1.23

===== XiaoMiku01/go-proxy-ipv6-pool go.mod =====
module go-proxy-ipv6-pool

go 1.20

require github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5

require (
	github.com/elazarl/goproxy v0.0.0-20231117061959-7cc037d33fb5 // indirect
	golang.org/x/net v0.19.0 // indirect
)

===== Vozec/Flarex go.mod =====
module github.com/Vozec/flarex

go 1.25.0

require (
	github.com/VictoriaMetrics/metrics v1.43.1
	github.com/coder/websocket v1.8.14
	github.com/knadh/koanf/parsers/yaml v1.1.0
	github.com/knadh/koanf/providers/file v1.2.1
	github.com/knadh/koanf/v2 v2.3.4
	github.com/panjf2000/ants/v2 v2.12.0
	github.com/puzpuzpuz/xsync/v3 v3.5.1
	github.com/refraction-networking/utls v1.8.2
	github.com/rs/zerolog v1.35.0
	github.com/sony/gobreaker/v2 v2.4.0

===== Qingluan/merkur go.mod =====
module github.com/Qingluan/merkur

go 1.14

require (
	github.com/aead/chacha20 v0.0.0-20180709150244-8b13a72661da
	github.com/cretz/bine v0.1.0
	github.com/dgryski/go-camellia v0.0.0-20191119043421-69a8a13fb23d
	github.com/dgryski/go-idea v0.0.0-20170306091226-d2fb45a411fb
	github.com/dgryski/go-rc2 v0.0.0-20150621095337-8a9021637152
	github.com/ebfe/rc2 v0.0.0-20131011165748-24b9757f5521 // indirect
	gitlab.com/yawning/chacha20.git v0.0.0-20190903091407-6d1cb28dc72c
	golang.org/x/crypto v0.0.0-20210513164829-c07d793c2f9a
	golang.org/x/net v0.0.0-20210520170846-37e1c6afe023
)
```

---

### 🤖 Assistant — 2026-09-14 16:34:24

**tool:bash** (completed) for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vozec/Flarex Qingluan/merkur; do echo "===== $r tree ====="; gh api repos/$r/contents --jq '.[].name' 2>&1; echo "--- workflows ---"; gh api repos/$r/contents/.github/workflows --jq '.[].name' 2>&1; echo ""; done

```
command=for r in yunginnanet/prox5 yukkcat/socks5-proxy XiaoMiku01/go-proxy-ipv6-pool Vo
--- output ---
===== yunginnanet/prox5 tree =====
.github
.gitignore
LICENSE
README.md
conductor.go
daemons.go
debug.go
defs.go
dispense.go
example
getters.go
go.mod
go.sum
internal
list_management.go
logger
mr_worldwide.go
mystery_dialer.go
mystery_resolver.go
parse.go
parse_test.go
proto.go
proto_test.go
prox5_test.go
proxy.go
scale_util.go
setters.go
socks5_server.go
stats.go
validator_engine.go
--- workflows ---
go.yml

===== yukkcat/socks5-proxy tree =====
.gitattributes
.gitignore
Dockerfile
README.md
checker.go
config.go
go.mod
main.go
pool.go
railway.toml
scraper.go
server.go
status.go
--- workflows ---
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/repos/contents#get-repository-content","status":"404"}gh: Not Found (HTTP 404)

===== XiaoMiku01/go-proxy-ipv6-pool tree =====
LICENSE
README.md
go.mod
go.sum
http.go
main.go
socks5.go
--- workflows ---
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/repos/contents#get-repository-content","status":"404"}gh: Not Found (HTTP 404)

===== Vozec/Flarex tree =====
.github
.gitignore
.golangci.yml
.goreleaser.yaml
CONTRIBUTING.md
Dockerfile
LICENSE
Makefile
README.md
SECURITY.md
cmd
config.example.yaml
deploy
docs
go.mod
go.sum
internal
scripts
test
web
--- workflows ---
ci.yml
docker.yml
release.yml

===== Qingluan/merkur tree =====
.gitignore
LICENSE
README.md
_example
config
console
go.mod
go.sum
pool.go
proxy.go
proxy2.go
proxy_http.go
shadowsocks
shadowsocksr
socks5
tcp
torrc
vmess
ws
--- workflows ---
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/repos/contents#get-repository-content","status":"404"}gh: Not Found (HTTP 404)
```

---

### 🤖 Assistant — 2026-09-14 16:34:40

**tool:bash** (completed) echo "=== prox5 exported types ==="; gh api repos/yunginnanet/prox5/contents/defs.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 30
echo "=== prox5 tag v1.3.0? ==="; gh api repos/yunginnanet/prox5/releases?per_page=10 --jq '.[] | {tag: .tag_name, date: .published_at}' 2>&1 | head -n 20
echo "=== yukkcat pool.go ==="; gh api repos/yukkcat/socks5-proxy/contents/pool.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20
echo "=== yukkcat checker ==="; gh api repos/yukkcat/socks5-proxy/contents/checker.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20

```
command=echo "=== prox5 exported types ==="; gh api repos/yunginnanet/prox5/contents/def
--- output ---
=== prox5 exported types ===
type ProxyChannels struct {
type ProxyEngine struct {
func NewDefaultSwamp() *Swamp {
type Swamp struct {
func NewProxyEngine() *ProxyEngine {
=== prox5 tag v1.3.0? ===
{"date":"2023-10-28T06:55:58Z","tag":"v0.9.52"}
{"date":"2023-08-12T05:53:15Z","tag":"v0.9.42"}
{"date":"2023-01-31T09:32:22Z","tag":"v0.9"}
{"date":"2022-12-27T15:42:58Z","tag":"v0.8.0"}
{"date":"2022-12-05T01:40:41Z","tag":"v0.7.94"}
{"date":"2022-11-30T19:34:19Z","tag":"v0.7.93"}
{"date":"2022-11-29T03:21:43Z","tag":"v0.7.92"}
{"date":"2022-10-19T13:16:12Z","tag":"v0.7.91"}
{"date":"2022-10-19T12:40:01Z","tag":"v0.7.9"}
{"date":"2022-10-16T12:57:22Z","tag":"v0.7.8"}
=== yukkcat pool.go ===
type ProxyPool struct {
func NewProxyPool() *ProxyPool {
=== yukkcat checker ===
func CheckProxies(proxies []Proxy, timeout time.Duration, maxConcurrent int) []Proxy {
func LookupGeo(ip string, timeout time.Duration) (country, city string) {
```

---

### 🤖 Assistant — 2026-09-14 16:35:00

**tool:bash** (completed) echo "=== prox5 full exported ==="; gh api repos/yunginnanet/prox5/contents/validator_engine.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20
echo "---proxy.go---"; gh api repos/yunginnanet/prox5/contents/proxy.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20
echo "---mystery_dialer---"; gh api repos/yunginnanet/prox5/contents/mystery_dialer.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20
echo "=== Flarex internal ==="; gh api repos/Vozec/Flarex/contents/internal --jq '.[].name' 2>&1
echo "=== merkur pool/proxy ==="; gh api repos/Qingluan/merkur/contents/pool.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20; gh api repos/Qingluan/merkur/contents/proxy.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20
echo "=== ipv6-pool socks5.go ==="; gh api repos/XiaoMiku01/go-proxy-ipv6-pool/contents/socks5.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20; gh api repos/XiaoMiku01/go-proxy-ipv6-pool/contents/main.go --jq '.content' | base64 -d | grep -E "^(type|func) [A-Z]" | head -n 20

```
command=echo "=== prox5 full exported ==="; gh api repos/yunginnanet/prox5/contents/vali
--- output ---
=== prox5 full exported ===
---proxy.go---
type Proxy struct {
---mystery_dialer---
=== Flarex internal ===
admin
alerts
auth
backend
cfapi
clientcli
config
discovery
dnscache
filter
logger
metrics
pool
proxy
ratelimit
scheduler
state
tlsdial
tracing
worker
=== merkur pool/proxy ===
type Result struct {
type ProgressBar interface {
type ProxyPool struct {
func NewProxyPool(url ...string) (proxyPool *ProxyPool) {
func ArraiExists(arr []string, o string) bool {
type Dialer interface {
type ProxyDialer struct {
func NewDialer(ssconf config.Config) (dialer *ProxyDialer, err error) {
func NewDialerByURI(ssuri string) (dialer *ProxyDialer, err error) {
func NewProxyDialer(proxyObj interface{}) (dialer proxy.Dialer) {
func Socks5Dialer(addr string) proxy.Dialer {
=== ipv6-pool socks5.go ===
```

---

### 🤖 Assistant — 2026-09-14 16:35:15

**tool:bash** (completed) echo "=== Flarex pool ==="; gh api repos/Vozec/Flarex/contents/internal/pool --jq '.[].name' 2>&1; gh api repos/Vozec/Flarex/contents/internal/proxy --jq '.[].name' 2>&1
echo "=== prox5 CI ==="; gh api repos/yunginnanet/prox5/contents/.github/workflows/go.yml --jq '.content' | base64 -d | head -n 30
echo "=== Flarex CI ==="; gh api repos/Vozec/Flarex/contents/.github/workflows/ci.yml --jq '.content' | base64 -d | head -n 30
echo "=== prox5 test files ==="; gh api "repos/yunginnanet/prox5/contents?ref=main" --jq '[.[].name | select(test(\"_test\"))]'
echo "=== Flarex test dir ==="; gh api repos/Vozec/Flarex/contents/test --jq '.[].name' 2>&1 | head -n 20

```
command=echo "=== Flarex pool ==="; gh api repos/Vozec/Flarex/contents/internal/pool --j
--- output ---
=== Flarex pool ===
bench_test.go
health.go
pool.go
pool_bench_test.go
pool_test.go
quota.go
quota_test.go
session_test.go
bench_test.go
bufpool.go
cfcache.go
cfcache_bench_test.go
dial.go
dial_test.go
drain_test.go
fs_other.go
fs_unix.go
helpers_test.go
httpconnect.go
httpconnect_test.go
integration_test.go
mode.go
mode_test.go
prewarm.go
relay_test.go
server.go
session_test.go
sniff.go
sniff_test.go
socks5.go
socks5_test.go
tcpopt_linux.go
tcpopt_other.go
tunnel.go
tunnel_test.go
=== prox5 CI ===
name: tests
on:
  push:
    branches: [ "main", "development" ]
  pull_request:
    branches: [ "main", "development" ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: 1.22
      - name: deps
        run: go mod tidy -x
      - name: vet
        run: go vet ./...
      - name: test
        run: go test -v -coverprofile=coverage.txt -covermode=atomic ./...
      - name: codecov
        run: bash <(curl -s  https://codecov.io/bash)
=== Flarex CI ===
name: CI

on:
  push:
    branches: [main, master]
  pull_request:

jobs:
  test:
    name: Test (race)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: npm
          cache-dependency-path: web/package-lock.json
      - name: Build admin SPA (embedded by Go via //go:embed)
        run: make web-build
      - uses: actions/setup-go@v5
        with:
          go-version: "1.25"
          cache: true
      - run: go mod download
      - run: go vet ./...
      - run: go test -race -timeout 120s -coverprofile=coverage.out ./...
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
=== prox5 test files ===
failed to parse jq expression (line 1, column 25)
    [.[].name | select(test(\"_test\"))]
                            ^  unexpected token "\\"
=== Flarex test dir ===
deploy
```

---

### 🤖 Assistant — 2026-09-14 16:35:32

**tool:todowrite** (completed) 1 todos

```
todos=[{'content': 'Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh 
--- output ---
[
  {
    "content": "Verify yunginnanet/prox5 + jacklul/proxy-manager existence via gh api",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "gh search repos socks5 proxy pool validation go",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Collect metadata: stars/issues/push/license/go.mod/CI/API surface",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Deliver comparison table + verdicts under 1200 words",
    "status": "in_progress",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-14 16:35:41

Using evaluate-candidates + search-repos to compare.

## Result: `jacklul/proxy-manager` not exist. Closest match noted.

`gh api repos/jacklul/proxy-manager` = 404. Full `users/jacklul/repos` scan (30+ repos): zero proxy-manager, zero SOCKS pool. Only Go proxy repo under jacklul = `jacklul/http-to-https-proxy` (1 star, MIT, push 2023-11-11, single-purpose HTTP→HTTPS upgrader, no pool). Global `gh search repos "proxy-manager"`: top = `NginxProxyManager/nginx-proxy-manager` (TS, 34k), `Ocramius/ProxyManager` (PHP, 4.9k) — no Go SOCKS-pool name match.

`socks5 proxy pool validation go` search returned 0; broadened to `socks5 proxy pool language:go stars:>5` via `gh api search/repositories`. Top Go contenders picked: `yukkcat/socks5-proxy`, `XiaoMiku01/go-proxy-ipv6-pool`, `Vozec/Flarex`. Bonus lib `Qingluan/merkur` noted below but excluded from top-3 (stale 2022, GPL-3.0).

Note: `prox5` releases show latest `v0.9.52` (2023-10-28). No `v1.3.0` tag found — verdicts benchmark against current `main`.

## Comparison table

| Repo | Stars / open issues | Last push | License | go.mod module + Go | CI / tests | Embed API surface (`gh api contents`) |
|---|---|---|---|---|---|---|
| `yunginnanet/prox5` (baseline) | 81 / 3 | 2024-10-07 | MIT | `git.tcp.direct/kayos/prox5`, go 1.19 | Yes: `.github/workflows/go.yml` (vet + `go test -cover` + codecov). Tests: `parse_test.go`, `proto_test.go`, `prox5_test.go` | Library-ready: `ProxyEngine` + `NewProxyEngine`, `Swamp` + `NewDefaultSwamp`, `Proxy`, `ProxyChannels`, `validator_engine.go`, `mystery_dialer.go`, `socks5_server.go`, getters/setters/dispense |
| `jacklul/proxy-manager` | — does not exist (404) | — | — | — | — | Closest: `jacklul/http-to-https-proxy`, binary only, no pool/validator/dialer types |
| `yukkcat/socks5-proxy` | 193 / 0 | 2026-06-18 | None (no LICENSE) | `socks5-pool`, go 1.23 | No: `.github/workflows` = 404, no `*_test.go` in tree | `ProxyPool` + `NewProxyPool` (`pool.go`), `CheckProxies`, `LookupGeo` (`checker.go`), `scraper.go`, `server.go`. Simple but unlicensed + non-canonical module path |
| `XiaoMiku01/go-proxy-ipv6-pool` | 42 / 0 | 2024-01-15 | MIT | `go-proxy-ipv6-pool`, go 1.20 | No CI, no tests | Binary only: `main.go`, `http.go`, `socks5.go`, zero exported pool/validator types. IPv6-egress niche |
| `Vozec/Flarex` | 17 / 1 | 2026-04-19 | NOASSERTION (has LICENSE file, SPDX undetected) | `github.com/Vozec/flarex`, go 1.25.0 | Strongest: `ci.yml` (vet + `go test -race` + coverage), `docker.yml`, `release.yml`, `.golangci.yml`. `internal/pool` + `internal/proxy` each with 5+ `*_test.go` | Rich but `internal/`: `internal/pool` (`pool.go`, `health.go`, `quota.go`), `internal/proxy` (`dial.go`, `socks5.go`, `server.go`, `httpconnect.go`, `tunnel.go`), `tlsdial`, `scheduler`, `discovery`. Not importable without fork |

Queries run:
```bash
gh api repos/yunginnanet/prox5 / repos/jacklul/proxy-manager
gh api users/jacklul/repos; gh search repos "proxy-manager" --sort stars --limit 12
gh api -X GET search/repositories -f q='socks5 proxy pool language:go stars:>5'
gh api repos/<each>/contents/go.mod, /contents, /.github/workflows, /contents/<file> (pool/checker/defs/validator/proxy)
gh api repos/<each> --jq '{stars, open_issues, pushed, license}'
```

## Verdicts (embed-fit vs prox5)

* **prox5 — recommend (baseline).** Only true embed library here: `ProxyEngine`/`Swamp` validator + dialer + SOCKS5 server, MIT, CI + tests. Concern: stale since Oct 2024, exotic import path `git.tcp.direct/kayos/*`, no v1.3.0 tag.
* **jacklul/proxy-manager — avoid (nonexistent).** No repo; closest `http-to-https-proxy` has zero pool semantics. Do not spec as alternative.
* **yukkcat/socks5-proxy — maybe.** Highest stars + freshest push + simplest `ProxyPool`/`CheckProxies` embed shape, but no license = unembeddable legally, no CI/tests, bare module path breaks `go get`. Fix license + rename module, then viable lightweight pick.
* **go-proxy-ipv6-pool — avoid for pooling.** MIT but binary-only IPv6 egress tool, no exported types, no CI. Use only if need is literally random-IPv6 egress, not validation/pooling.
* **Flarex — maybe, heaviest.** Best engineering (race CI, quota/health/circuit-breaker via `gobreaker`, metrics, admin SPA) and freshest Go (1.25), but everything under `internal/` forces fork/exec-wrap; license SPDX unclear; overbuilt vs prox5 if just need validator+DIALER.

First try: stay on prox5. If active maintenance matters more than validator depth, fork Flarex (fix license + export `internal/pool`) or vendor `yukkcat` pool behind prox5's `ProxyDialer` interface after license added.


---
