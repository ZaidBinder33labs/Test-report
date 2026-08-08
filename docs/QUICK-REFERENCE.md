# Quick Reference — Cheat Sheet

Everything you need for daily use, in one page.

## First-time setup

```bash
# 1. Create GitHub repo (via github.com/new)

# 2. Push this folder
git init
git branch -M main
git add .
git commit -m "Initial QA setup"
git remote add origin https://github.com/YOUR-USERNAME/binder-qa.git
git push -u origin main

# 3. Enable GitHub Pages: Settings → Pages → Deploy from branch: main → root → Save

# 4. Configure qa-reports/index.html — change these two lines:
#    const GITHUB_USER = 'YOUR-USERNAME';
#    const GITHUB_REPO = 'binder-qa';

git add qa-reports/index.html
git commit -m "Configure index page"
git push
```

## Daily workflow

### Start the tool
- VS Code → right-click `qa-tool/qa-tool.html` → Open with Live Server
- Or: `cd qa-tool && python3 -m http.server 8000` → open `http://localhost:8000/qa-tool.html`

### Run tests
1. Setup modal: enter name, click Start
2. Click any module → tick Health / Business / Frontend checks
3. Add notes for broken things
4. Set module status

### Generate & publish report

**Manual way:**
```bash
# 1. Click green "Generate HTML Report" in tool
# 2. Move file
mv ~/Downloads/binder-qa-*.html qa-reports/

# 3. (Optional) Rename
mv qa-reports/binder-qa-current-run-2025-11-15.html qa-reports/sprint-42-2025-11-15.html

# 4. Push
git add qa-reports/
git commit -m "QA report: Sprint 42"
git push
```

**Automated way (Mac/Linux):**
```bash
./scripts/publish.sh "sprint-42-regression"
```

**Automated way (Windows):**
```powershell
.\scripts\publish.ps1 "sprint-42-regression"
```

## URLs to remember

- Tool: `https://YOUR-USERNAME.github.io/binder-qa/qa-tool/qa-tool.html`
- Report index: `https://YOUR-USERNAME.github.io/binder-qa/qa-reports/`
- Latest report: shown on index page

## Complete run workflow

- Click **Complete run** in header when a testing session is finished
- Give it a label (e.g. "Sprint 42 Regression")
- Optional summary notes
- Click **Archive and start new run**
- Everything resets — history preserved

## History access

- Click **History** button in header
- See all archived runs, most recent first
- Click any run to see full detail
- Click **Download HTML Report** in detail view to export any historical run

## Firebase quick setup (for real-time team)

Full guide: `docs/FIREBASE-SETUP.md`

Short version:
1. https://console.firebase.google.com → Add project
2. Build → Realtime Database → Create (test mode)
3. Project Settings → Add web app → copy config JSON
4. Rules tab: allow `sessions/$sid` read+write
5. In tool: Team mode tab → paste config → Start

## Team member onboarding

Send them this message (see `docs/TEAM-ONBOARDING.md` for full templates):

```
Tool URL: https://YOUR-USERNAME.github.io/binder-qa/qa-tool/qa-tool.html
Session key: binder-qa-nov-2025

1. Open the URL
2. Choose "Team real-time" tab
3. Enter your name + session key + Firebase config (attached)
4. Click Start

You should see a green "Live sync" in the header.
```

## Report naming

Recommended: `<label>-<YYYY-MM-DD>.html`

Examples:
- `sprint-42-regression-2025-11-15.html`
- `nov-release-smoke-2025-11-08.html`
- `bug-batch-7-2025-11-22.html`

## Troubleshooting one-liners

| Problem | Fix |
|---|---|
| Tool won't open | Use Live Server, not double-click (file://) |
| Firebase "Connecting..." forever | Check JSON is valid, Realtime DB enabled |
| GitHub Pages 404 | Wait 60s, force refresh |
| git push asks password | `gh auth login` or use Personal Access Token |
| Report list empty | Configure USER/REPO in qa-reports/index.html |
| Team member cannot join | Session key must match exactly (case-sensitive) |

## File locations

| What | Where |
|---|---|
| QA tool | `qa-tool/qa-tool.html` |
| Report index | `qa-reports/index.html` |
| Reports go here | `qa-reports/*.html` |
| Documentation | `docs/*.md` |
| Helper scripts | `scripts/publish.sh` and `publish.ps1` |
| Ignore patterns | `.gitignore` |
| This file | `docs/QUICK-REFERENCE.md` |
