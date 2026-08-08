# Publishing QA Reports on GitHub Pages

Complete guide to hosting your QA reports so team members can view them by URL.

## Why GitHub Pages

- Free
- Automatic HTTPS
- Unlimited bandwidth for public repos
- Version controlled — every report is tracked in git
- Team access via URL — no logins needed for public repos

## One-time setup

### Step 1. Enable GitHub Pages

1. Push this folder to a GitHub repo (see main README)
2. Go to the repo on GitHub
3. **Settings** tab (top of repo page)
4. Left menu: **Pages**
5. **Source**: Deploy from a branch
6. **Branch**: `main`
7. **Folder**: `/ (root)`
8. Click **Save**
9. Wait 30-60 seconds
10. Refresh the Pages section — you should see:
    ```
    Your site is live at https://YOUR-USERNAME.github.io/binder-qa/
    ```

### Step 2. Configure the report index page

1. Open `qa-reports/index.html` in a text editor
2. Find these two lines at the top of the `<script>` block:
   ```javascript
   const GITHUB_USER = 'YOUR-USERNAME';
   const GITHUB_REPO = 'binder-qa';
   ```
3. Replace with your actual username and repo name:
   ```javascript
   const GITHUB_USER = 'shubham-dev';
   const GITHUB_REPO = 'binder-qa';
   ```
4. Save the file

### Step 3. Push the configured index

```bash
git add qa-reports/index.html
git commit -m "Configure report listing"
git push
```

Wait 30 seconds. Visit:
```
https://YOUR-USERNAME.github.io/binder-qa/qa-reports/
```

You should see the QA Reports landing page (empty until you push your first report).

## Publishing a report — daily workflow

### Step 1. Generate the report

1. Open `qa-tool/qa-tool.html` in browser
2. Run your QA tests, tick checkboxes, add notes
3. Click green **Generate HTML Report** button in header
4. Report downloads to your Downloads folder

### Step 2. Move report to `qa-reports/` folder

**Mac/Linux:**
```bash
mv ~/Downloads/binder-qa-*.html qa-reports/
```

**Windows PowerShell:**
```powershell
Move-Item "$HOME\Downloads\binder-qa-*.html" qa-reports\
```

**Or drag-drop** the file from Downloads into `qa-reports/` folder in VS Code file explorer.

### Step 3. Rename for clarity (optional but recommended)

Default filename pattern is `binder-qa-current-run-YYYY-MM-DD.html`. Rename to a meaningful label:

```bash
cd qa-reports/
mv binder-qa-current-run-2025-11-15.html sprint-42-regression-2025-11-15.html
```

Or in VS Code: right-click file → Rename.

**Recommended naming pattern:** `<label>-<YYYY-MM-DD>.html`

Examples:
- `sprint-42-regression-2025-11-15.html`
- `nov-release-smoke-2025-11-08.html`
- `bug-batch-7-fix-verification-2025-11-22.html`
- `onboarding-flow-audit-2025-11-30.html`

The landing page auto-parses the date suffix and shows a clean title.

### Step 4. Commit and push

```bash
git add qa-reports/
git commit -m "QA report: Sprint 42 regression"
git push
```

### Step 5. Wait 30 seconds, share URL

GitHub Pages rebuilds within 30-60 seconds after push. Your report URL:

```
https://YOUR-USERNAME.github.io/binder-qa/qa-reports/sprint-42-regression-2025-11-15.html
```

Or team members can go to the index:
```
https://YOUR-USERNAME.github.io/binder-qa/qa-reports/
```

And click the latest report.

## Alternative: private repository

GitHub Pages does not directly support private repos on the free tier (that requires GitHub Pro or Enterprise).

**Options for private QA reports:**

### Option A. htmlpreview.github.io (public workaround for private repos)

If you push to a public repo but do not enable Pages, you can still view HTML via:
```
https://htmlpreview.github.io/?https://github.com/USER/REPO/blob/main/qa-reports/report.html
```

Not ideal for private repos, but works for occasionally private files in public repos.

### Option B. Netlify (private repo + free hosting)

1. Sign up at https://netlify.com (free)
2. Connect your GitHub account
3. Create a new site from your private repo
4. Publish directory: `qa-reports`
5. Deploy — Netlify gives you a URL like `https://something.netlify.app`
6. Add password protection in Netlify site settings if needed (paid feature)

### Option C. Vercel

Similar to Netlify. https://vercel.com — connect private repo, deploy from `qa-reports` folder.

### Option D. Cloudflare Pages

https://pages.cloudflare.com — works with private repos, free tier is generous.

### Option E. Manual sharing

Just send the HTML file itself via email/Slack. Team members download and open locally. Not scalable, but works for occasional reports.

## Custom domain (optional)

If you have a domain like `qa.yourcompany.com`:

1. In your repo: **Settings → Pages**
2. **Custom domain**: enter `qa.yourcompany.com`
3. In your DNS provider: add a CNAME record pointing `qa.yourcompany.com` to `YOUR-USERNAME.github.io`
4. Wait for DNS propagation (5 minutes to a few hours)
5. Enable **Enforce HTTPS**

Now reports live at:
```
https://qa.yourcompany.com/qa-reports/sprint-42-regression-2025-11-15.html
```

## Automating with GitHub Actions (advanced)

Optional: use GitHub Actions to auto-post to Slack/Discord when a new report is pushed.

Create `.github/workflows/notify.yml`:

```yaml
name: Notify team on new report
on:
  push:
    paths:
      - 'qa-reports/*.html'
jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Post to Slack
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"New QA report published: ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}\"}" \
            ${{ secrets.SLACK_WEBHOOK_URL }}
```

Set `SLACK_WEBHOOK_URL` in repo Settings → Secrets → Actions.

## Report retention strategy

Reports accumulate over time. Recommendations:

- **Keep all reports** for audit trail (recommended for regulated environments)
- **Archive after 90 days**: move old reports into `qa-reports/archive/YYYY/`
- **Delete after 1 year**: `git rm qa-reports/*-2024-*.html` and push

At ~50 KB per report, even 1000 reports is only 50 MB — well within GitHub limits.

## Troubleshooting

### Page shows 404

- Wait 60 seconds after enabling Pages
- Check Pages section shows "Your site is live"
- Force refresh (Ctrl+Shift+R)
- Check the URL uses the correct case (GitHub Pages is case-sensitive on Linux servers)

### Report shows but landing page is empty

- Check `qa-reports/index.html` has the correct `GITHUB_USER` and `GITHUB_REPO` values
- Open browser DevTools (F12) → Console tab → look for errors
- GitHub API rate limit exceeded — wait 5-10 minutes and refresh

### Report displays but styling is broken

- Reports are self-contained (all CSS embedded). If styling is broken, the file may be corrupted.
- Regenerate the report from the tool.

### git push takes long time

- Reports are small (~50 KB each). If push is slow, the issue is your connection, not the reports.
- Check `git status` — you might be committing more than intended.
