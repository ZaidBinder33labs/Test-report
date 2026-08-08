# Team Onboarding

How to bring team members into the QA workflow. Copy-paste message templates included.

## Prerequisites for team members

Each team member needs:

- A modern browser (Chrome, Firefox, Edge, Safari)
- Their name (for attribution in reports)
- The QA tool URL or file
- (Optional, for real-time mode) Session key + Firebase config

## Onboarding scenarios

### Scenario A: Solo testers, they generate own reports

Simplest setup. Each tester runs the tool independently and generates reports.

**What they need:**
- URL to the tool: `https://YOUR-USERNAME.github.io/binder-qa/qa-tool/qa-tool.html`
- Their name

**Copy-paste message template (Slack/WhatsApp/Email):**

```
Hi team,

We are using a QA tool to systematically test the Binder OS portal. Please follow these steps to get started:

1. Open this URL in your browser:
   https://YOUR-USERNAME.github.io/binder-qa/qa-tool/qa-tool.html

2. When the setup modal appears, choose the "Solo mode" tab.

3. Enter your name and click "Start".

4. You will see a flow diagram with 18 modules. Click any module to see the checks for it.

5. Each module has three categories to verify:
   - Health (does the module load and work)
   - Backend business logic (are core rules correct)
   - Frontend UI (validation, loading, keyboard)

6. Tick checks as you verify them. Add notes if anything is broken. Set the overall module status.

7. When done with a testing session, click "Generate HTML Report" at the top. This downloads a standalone HTML report.

8. Send me the downloaded HTML file, or push it to our GitHub repo yourself.

Documentation: https://github.com/YOUR-USERNAME/binder-qa#readme

Ping me if stuck.
```

### Scenario B: Real-time team collaboration (Firebase)

Everyone tests together, sees each other's progress live.

**What they need:**
- URL to the tool
- Their name
- Session key (a shared string)
- Firebase config JSON

**Copy-paste message template:**

```
Hi team,

We are running a live collaborative QA session for the Binder OS portal today. Everyone will see each other's checkbox ticks and comments in real-time.

Setup (one time):

1. Open this URL in your browser:
   https://YOUR-USERNAME.github.io/binder-qa/qa-tool/qa-tool.html

2. Setup modal will appear. Choose the "Team real-time" tab.

3. Fill in the following exactly:

   Your name: (your name)

   Session key: SESSION-KEY-HERE

   Firebase config: (paste the block below exactly as-is)

   {
     "apiKey": "YOUR-API-KEY",
     "authDomain": "your-project.firebaseapp.com",
     "databaseURL": "https://your-project-default-rtdb.firebaseio.com",
     "projectId": "your-project"
   }

4. Click "Start".

5. Header will show a green "Live sync" indicator when connected.

6. Click any module in the flow diagram to see checks. Tick checks as you verify. Add notes and comments for issues.

7. You will see other team members' colored dots on the flow diagram showing what they are looking at.

Ground rules:

- Use the module Notes field for module-specific findings.
- Use the Team Discussion (comments) field for questions or clarifications.
- If you find a broken module, set its status to "Broken" and add a note explaining what fails.
- Do NOT click "Complete run" or "Reset all" without confirming with the team.

Let me know if you have trouble connecting.
```

### Scenario C: Read-only report viewing

Non-testers (managers, stakeholders) who just want to see the report.

**What they need:**
- URL to the report or landing page

**Copy-paste message template:**

```
Hi,

QA report for [what was tested] is ready. Click below to view:

Report URL: https://YOUR-USERNAME.github.io/binder-qa/qa-reports/sprint-42-regression-2025-11-15.html

The report shows:
- Summary of all 18 modules tested
- Pass/broken/partial counts
- Every check that was verified with the tester name
- Notes and team discussion on any broken modules

To see all past reports:
https://YOUR-USERNAME.github.io/binder-qa/qa-reports/

Report is read-only. Any questions, reply here or ping me directly.
```

## Roles and access levels

### Read-only viewers
- Get the report URL
- No setup required
- Reports are static HTML — nothing to break

### Solo testers
- Get the tool URL
- Enter own name, start testing
- Generate own reports, send to lead

### Real-time testers
- Get tool URL + session key + Firebase config
- Everyone in the same session sees each other's activity
- Can comment and discuss

### QA lead (you)
- All of the above
- Owns the GitHub repo
- Pushes reports to `qa-reports/` folder
- Shares report URLs with stakeholders

## Common questions from team members

**Q: I opened the file but nothing loads / setup modal does not appear**
A: You opened via `file://` protocol which some browsers block. Use the URL from the message, not a downloaded file.

**Q: I don't see other people's changes**
A: Confirm the session key is exactly the same (case-sensitive) as what the lead shared. Check the header — it should say "Live sync" in green.

**Q: My checkbox tick did not stay saved**
A: Check the "Live sync" indicator. If it says "Offline" or "Connecting...", the check is only in your browser and could be lost if you close the tab.

**Q: I need to add a check that is not in the list**
A: The check list is defined in the tool itself. Discuss with the QA lead — they can add it to the source and redeploy.

**Q: Where do I send the report I generated?**
A: Depends on the workflow. Either send the HTML file directly to the lead, or push to the GitHub repo yourself if you have access.

**Q: Can I test from my phone?**
A: Yes, on the browser, but the layout is optimized for desktop. On phone you may want to switch to landscape mode.

**Q: Do I need to install anything?**
A: No installation needed. Just a modern browser.

## Team practices

### Recommended cadence

- **Daily standup**: 5 min review of any broken modules from yesterday
- **Sprint end**: full regression run, publish report, share URL with stakeholders
- **Before release**: comprehensive test of all 18 modules
- **Bug verification**: targeted run on affected modules after backend/frontend fixes

### Report labels

Use descriptive labels for runs so reports are searchable later:

Good:
- `Sprint 42 Regression`
- `November Release Smoke Test`
- `IPC Wizard Bug Batch 7 Verification`
- `Onboarding Flow Deep Audit`

Not helpful:
- `Test 1`
- `Run yesterday`
- `Regression`

### Handling broken findings

When a module is marked Broken:

1. Add a note explaining exactly what fails (steps to reproduce)
2. Reference any related bug tracker ID (JIRA, GitHub Issues)
3. Attach screenshots externally (paste link in the note or comment)
4. Set overall module status to `Broken`
5. Continue testing other modules — do not stop the whole session for one bug

### Reset and archival etiquette

- Anyone can complete a run, but coordinate with the team first
- Do not reset mid-session
- Complete run only when the session is truly over
- Give runs a clear label so history is searchable

## Advanced: adding new team members later

If someone joins the team mid-project:

1. Send them the tool URL + their name
2. If using Firebase: send the session key + config JSON
3. They enter their name in setup — they immediately see current state
4. Their name is auto-added to the `testers` list on their first check tick
5. Their attribution appears on all their checks going forward

## Advanced: removing a team member

If someone leaves:

1. Their historical attributions in past reports remain (audit trail)
2. Their name is not automatically removed from active session testers list
3. If sensitive, rotate the Firebase config (new project) and update the team

## Advanced: multiple concurrent teams

If you have multiple QA teams working in parallel:

- Give each team a different session key
- Everyone uses the same Firebase config (one project handles multiple sessions)
- Team A: `session=team-a-nov-2025`
- Team B: `session=team-b-nov-2025`
- Each team has isolated data — no cross-contamination
- Firebase console shows all sessions under `sessions/` node

Reports each team generates can be organized in subfolders:

```
qa-reports/
├── team-a/
│   ├── sprint-42-regression-2025-11-15.html
│   └── ...
└── team-b/
    ├── nov-release-smoke-2025-11-08.html
    └── ...
```

The `qa-reports/index.html` currently lists top-level `.html` files only. If you use subfolders, update the index page to browse them or maintain a manual list.
