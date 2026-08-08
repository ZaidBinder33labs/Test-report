# Binder OS — Team QA Setup

Manual QA testing tool for the Binder OS portal. Run tests locally, generate reports, push to GitHub, share with team.

---

## What this is

A self-contained QA workflow that lets you:

- Run manual tests against 18 modules of the Binder OS portal
- Check three categories per module: Health, Backend business logic, Frontend UI (234 total checkpoints)
- Track progress in real-time across the team (optional Firebase)
- Archive every completed run to history with full detail
- Generate beautiful standalone HTML reports
- Push reports to GitHub, share via URL with the team

No servers to run. No accounts required for solo use. Everything is browser + git.

---

## Folder structure

```
binder-qa/
├── README.md                    ← You are here
├── .gitignore
├── qa-tool/
│   └── qa-tool.html             ← The QA tool (open in browser)
├── qa-reports/
│   ├── index.html               ← Landing page listing all reports
│   └── (reports go here)        ← Generated HTML reports
└── docs/
    ├── FIREBASE-SETUP.md        ← 5-min Firebase real-time setup
    ├── GITHUB-PUBLISHING.md     ← How to publish reports
    └── TEAM-ONBOARDING.md       ← How team members join
```

---

## Quick start (5 minutes)

### Step 1. Requirements

Check you have:
```bash
git --version         # any recent version
python3 --version     # 3.8 or newer (or Node.js if you prefer)
```

Install if missing:
- Git: https://git-scm.com/downloads
- Python: https://python.org/downloads

### Step 2. Recommended VS Code extensions

Open VS Code and install:
- **Live Server** by Ritwick Dey (right-click HTML → open in browser)
- **GitLens** by GitKraken (better git history)

### Step 3. Create a GitHub repository

1. Go to https://github.com/new
2. Repository name: `binder-qa` (or any name)
3. Public repo recommended (needed for the auto-listing on GitHub Pages). If private, see the [private repo section](#using-a-private-repo).
4. Click **Create repository** — do NOT initialize with README (you have local files already)

### Step 4. Push this folder to GitHub

In the folder terminal:

```bash
git init
git branch -M main
git add .
git commit -m "Initial QA setup"
git remote add origin https://github.com/YOUR-USERNAME/binder-qa.git
git push -u origin main
```

### Step 5. Configure the report index page

Open `qa-reports/index.html` and change these two lines near the top of the script:

```javascript
const GITHUB_USER = 'YOUR-USERNAME';   // your GitHub username
const GITHUB_REPO = 'binder-qa';       // your repo name
```

Save and push:
```bash
git add qa-reports/index.html
git commit -m "Configure repo details in index page"
git push
```

### Step 6. Enable GitHub Pages

1. Go to your repo on GitHub
2. **Settings** tab (top of repo)
3. Left menu: **Pages**
4. **Source**: Deploy from a branch
5. **Branch**: `main` — **Folder**: `/ (root)` — click **Save**
6. Wait 30 to 60 seconds
7. Refresh — you should see: `Your site is live at https://YOUR-USERNAME.github.io/binder-qa/`

### Step 7. Test the tool locally

Two ways to open the QA tool:

**Option A: Live Server extension (easiest)**
1. In VS Code, right-click `qa-tool/qa-tool.html`
2. Click **Open with Live Server**
3. Browser opens at `http://127.0.0.1:5500/qa-tool/qa-tool.html`

**Option B: Python HTTP server**
```bash
cd qa-tool
python3 -m http.server 8000
```
Open browser: `http://localhost:8000/qa-tool.html` — stop with `Ctrl+C`

**Do NOT double-click the HTML file to open with `file://`** — Firebase and some browser features are blocked over the file protocol.

### Step 8. Complete setup for the tool

1. When the tool loads, a setup modal appears
2. Enter your name → click **Start**
3. For solo mode, that is it — you can begin testing
4. For team real-time, use the **Team real-time** tab and follow [docs/FIREBASE-SETUP.md](docs/FIREBASE-SETUP.md)

---

## Daily workflow

### Running a QA run

1. Open `qa-tool/qa-tool.html` via Live Server or `python3 -m http.server`
2. Click any module in the flow diagram
3. Tick checks in the three sections:
   - **Health** (blue) — does the module work
   - **Backend business logic** (purple) — are backend rules correct
   - **Frontend UI** (orange) — is the UX good
4. Add notes for broken modules
5. Set overall status: `Not tested` / `Partial` / `All pass` / `Broken`
6. Discuss with team in the Comments section
7. Progress bar in header shows overall pass count

### Generating and publishing a report

1. When done testing, click green **Generate HTML Report** button in the header
2. Report downloads to your Downloads folder as `binder-qa-current-run-YYYY-MM-DD.html`
3. Move it into your project's `qa-reports/` folder:

   **Mac/Linux:**
   ```bash
   mv ~/Downloads/binder-qa-*.html qa-reports/
   ```

   **Windows PowerShell:**
   ```powershell
   Move-Item "$HOME\Downloads\binder-qa-*.html" qa-reports\
   ```

   Or just drag-drop in your file manager.

4. Rename to a meaningful name if you like:
   ```bash
   mv qa-reports/binder-qa-current-run-2025-11-15.html qa-reports/sprint-42-regression.html
   ```

5. Push to GitHub:
   ```bash
   git add qa-reports/
   git commit -m "QA report: Sprint 42 regression"
   git push
   ```

6. Wait 30 seconds. Report URL becomes:
   ```
   https://YOUR-USERNAME.github.io/binder-qa/qa-reports/sprint-42-regression.html
   ```
7. Share the URL with the team.

### Archiving a run (reset for next round)

Inside the tool, after completing a round:

1. Click **Complete run** button in the header
2. Optional: give it a label ("Sprint 42 regression" etc.) and summary notes
3. Click **Archive and start new run**
4. Everything resets — all checks unchecked, notes and comments cleared
5. Archived run appears in **History** (accessible via the History button)

### Viewing past runs

1. Click **History** button in header
2. See list of all completed runs, sorted newest first
3. Click any run to see full detail (every check, note, comment preserved)
4. Click **Download HTML Report** in the detail view to export that historical run

---

## Team collaboration

### Solo (default)

Everything saves in your browser's `localStorage`. Works offline. No sharing with team unless you export reports.

### Team real-time (Firebase)

For teams that want to see each other's checks live, set up Firebase:

- See [docs/FIREBASE-SETUP.md](docs/FIREBASE-SETUP.md) for the 5-minute Firebase configuration
- Everyone uses the same session key
- All checkbox toggles, comments, notes sync instantly
- Presence indicators show who is online and what they are looking at

### Onboarding team members

Send each team member:

1. The URL to your GitHub Pages site: `https://YOUR-USERNAME.github.io/binder-qa/`
2. Or the raw `qa-tool.html` file (they save locally and open with a server)
3. Session key (any shared string, e.g. `binder-qa-nov-2025`)
4. Firebase config JSON if using real-time mode

See [docs/TEAM-ONBOARDING.md](docs/TEAM-ONBOARDING.md) for a copy-paste onboarding message.

---

## Publishing reports

See [docs/GITHUB-PUBLISHING.md](docs/GITHUB-PUBLISHING.md) for detailed publishing options.

**Quick reference:**

- Move report from `~/Downloads/` to `qa-reports/`
- Rename to something meaningful
- `git add qa-reports/ && git commit -m "QA report: ..." && git push`
- Wait 30 seconds for GitHub Pages to rebuild
- Share URL: `https://YOUR-USERNAME.github.io/binder-qa/qa-reports/your-report.html`

The `qa-reports/index.html` landing page auto-lists all reports via GitHub API. Team members visit the landing page and see every report available.

---

## Using a private repo

The auto-listing on `qa-reports/index.html` uses the GitHub API which requires public repos (or authenticated access).

**For private repos, options:**

1. **Manual index**: edit `qa-reports/index.html` and hard-code the report links
2. **Personal access token**: modify the fetch call to include an Authorization header (see [docs/PRIVATE-REPO.md](docs/GITHUB-PUBLISHING.md) if available)
3. **Different hosting**: deploy to Netlify or Vercel from a private repo (they can read via git access)

---

## What the report contains

Each generated HTML report includes:

- Run metadata (label, dates, testers, duration)
- Summary strip with 5 big number cards (Pass / Broken / Partial / Not tested / Pass rate %)
- Broken modules highlighted at the top with jump-links
- Table of contents (color-coded pills, click to jump to a module)
- For each of the 18 modules:
  - Status badge with color-coded left border
  - Description and API endpoints
  - Every Health check with tick/cross and "by [tester]" attribution
  - Every Business logic check with reasoning and attribution
  - Every Frontend UI check with attribution
  - Notes for the module (highlighted box)
  - Team discussion (all comments with author + timestamp)
- Footer with generation timestamp

Reports are read-only, printable, mobile responsive. Zero dependencies. Works offline once downloaded.

---

## Troubleshooting

### The tool does not load / setup modal does not appear

- You opened the file with `file://` protocol. Use Live Server or `python3 -m http.server` instead.
- Open browser console (F12) to see errors.

### Firebase sync says "Connecting..." forever

- Firebase config JSON might be wrong. Check that `databaseURL` field is present.
- Check that Realtime Database is enabled in the Firebase console (not Firestore).
- Check the security rules allow your session key path.
- See [docs/FIREBASE-SETUP.md](docs/FIREBASE-SETUP.md).

### GitHub Pages URL shows 404

- Wait 60 seconds after enabling Pages.
- Check Settings → Pages shows "Your site is live at..."
- Try force refresh (Ctrl+Shift+R or Cmd+Shift+R).
- Make sure the branch is `main` and folder is `/ (root)`.

### Report file downloaded but I cannot see it in the browser

- Check your Downloads folder — some browsers download silently.
- File name pattern: `binder-qa-<label>-<date>.html`

### git push asks for password every time

- Set up a Personal Access Token: https://github.com/settings/tokens (Classic, scope: `repo`)
- Or install GitHub CLI: `gh auth login` (easiest)
- Or use GitHub Desktop for a GUI

### Team members see stale data

- Check that everyone is using the exact same session key (case-sensitive).
- Check that Firebase config is identical across all users.
- Check the Live sync indicator in the header shows green.

---

## FAQ

**Do I need to install anything for the tool itself?**  
No. It is a single HTML file. Just serve it via any static HTTP server.

**Can I use this without GitHub?**  
Yes. All test data saves in localStorage. Reports download as standalone HTML files that can be shared via any method (email, WhatsApp, Slack, drive).

**Does the tool send data anywhere?**  
Only if you configure Firebase for team real-time. Otherwise everything stays in your browser.

**Can I customize the checks?**  
Yes. Edit the `STAGES` array in the JavaScript section of `qa-tool.html`. Each stage has `health`, `business`, `frontend` arrays that you can add to, remove from, or edit.

**Can I use this offline?**  
Yes for solo mode. Firebase real-time requires internet.

**What happens if I lose my browser data?**  
Solo mode data is in localStorage — lost if you clear browser data. To be safe, generate an HTML report periodically and push to GitHub. That is your backup.

**How many reports can I store on GitHub Pages?**  
GitHub has a soft 1 GB repo limit. Each report is ~50 KB. That is 20,000 reports before you hit the limit. Practically unlimited for QA use.

---

## Documentation index

- [docs/FIREBASE-SETUP.md](docs/FIREBASE-SETUP.md) — Firebase Realtime Database setup for team collaboration
- [docs/GITHUB-PUBLISHING.md](docs/GITHUB-PUBLISHING.md) — Publishing reports via GitHub Pages
- [docs/TEAM-ONBOARDING.md](docs/TEAM-ONBOARDING.md) — Message templates to onboard team members

---

## License

Internal QA tool. Adapt as needed for your team.
