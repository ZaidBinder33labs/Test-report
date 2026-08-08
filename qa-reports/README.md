# Reports folder

Generated QA reports go here. Each report is a standalone HTML file.

## Naming convention

Recommended: `<label>-<YYYY-MM-DD>.html`

Examples:
- `sprint-42-regression-2025-11-15.html`
- `nov-release-smoke-2025-11-08.html`
- `bug-batch-7-2025-11-22.html`

## Workflow

1. Run tests in `qa-tool/qa-tool.html`
2. Click **Generate HTML Report** in the tool header
3. Move the downloaded file into this folder
4. Optionally rename it
5. Commit and push
6. Report becomes visible at `https://YOUR-USERNAME.github.io/binder-qa/qa-reports/<filename>.html`

The `index.html` in this folder auto-lists every `.html` file (except itself) via GitHub API.

## Do not commit these

- Draft reports you do not want the team to see
- Reports containing sensitive data (customer info, credentials)
