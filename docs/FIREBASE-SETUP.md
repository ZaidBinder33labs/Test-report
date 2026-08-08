# Firebase Real-time Setup (5 minutes)

Only needed if you want team members to see each other's checkbox toggles and comments in real-time. Solo mode works without any of this.

## What you get with Firebase

- Every checkbox toggle syncs across all team members instantly
- Notes and comments appear for everyone in real-time
- Presence indicators show who is online and which module they are viewing
- Complete Run action resets state for everyone at once
- Run history is shared across the team

## Free tier limits (Firebase Realtime Database)

- 1 GB storage
- 100 simultaneous connections
- 10 GB/month bandwidth

More than enough for a QA team of any realistic size.

## Setup steps

### Step 1. Create Firebase project

1. Go to https://console.firebase.google.com
2. Click **Add project**
3. Project name: anything, for example `binder-qa`
4. Google Analytics: not required, you can disable
5. Click **Create project** and wait

### Step 2. Enable Realtime Database

1. In the Firebase console, left menu: **Build → Realtime Database**
2. Click **Create Database**
3. Location: choose nearest region (asia-southeast1 for Asia)
4. Security rules: choose **Start in test mode**
5. Click **Enable**

### Step 3. Get web app config

1. Top left corner: click gear icon → **Project settings**
2. Scroll down to **Your apps** section
3. Click the web icon `</>`
4. App nickname: any name like `binder-qa-web`
5. Do NOT enable Firebase Hosting (not needed)
6. Click **Register app**
7. Firebase shows a JavaScript snippet with a config object like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyABC123...",
  authDomain: "binder-qa.firebaseapp.com",
  databaseURL: "https://binder-qa-default-rtdb.firebaseio.com",
  projectId: "binder-qa",
  storageBucket: "binder-qa.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

Copy the object contents (just the `{...}` part).

### Step 4. Update security rules

1. Left menu: **Build → Realtime Database → Rules** tab
2. Replace the default rules with:

```json
{
  "rules": {
    "sessions": {
      "$sid": {
        ".read": true,
        ".write": true
      }
    }
  }
}
```

3. Click **Publish**

This allows anyone with your session key to read and write. Since session keys are private strings you share only with your team, this is safe for internal use.

**For higher security**, use Firebase Anonymous Auth and change the rules to require auth. Out of scope for this quick setup.

### Step 5. Configure the QA tool

1. Open `qa-tool/qa-tool.html` in your browser (via Live Server or `python3 -m http.server`)
2. The setup modal appears
3. Click **Team real-time** tab
4. Fill in:
   - Your name (e.g. Shubham)
   - Session key (any string like `binder-qa-nov-2025` — MUST be exact same for all team members)
   - Firebase config JSON — paste the `{...}` from Step 3
5. Click **Start**

The header should show a green **Live sync** indicator within a few seconds.

### Step 6. Share with team

Every team member needs:
- The `qa-tool.html` file (host it on GitHub Pages or share directly)
- The exact same session key
- The exact same Firebase config JSON
- Their own name

See [TEAM-ONBOARDING.md](TEAM-ONBOARDING.md) for a copy-paste message template.

## Verify it works

1. Open the tool in two different browsers (or one normal + one incognito)
2. Use different names but the SAME session key + Firebase config
3. In browser A, tick any checkbox
4. In browser B, that checkbox should tick within 1 second with a green flash animation and a "by <name>" tag

## Troubleshooting

### "Firebase setup failed" alert on Start

- Check the JSON is valid (paste into https://jsonlint.com to verify)
- Ensure the `databaseURL` field is present in the JSON
- Check browser console (F12) for the exact error message

### Connection stuck at "Connecting..."

- Realtime Database is not enabled — go back to Step 2
- Rules are blocking — check Step 4
- Firewall or corporate network is blocking Firebase — try a different network

### Team member cannot join

- Session key mismatch — verify EXACT string match (case-sensitive, no extra spaces)
- Different Firebase project — ensure the same config JSON is used
- Firebase quota exceeded (unlikely for QA teams) — check quota in Firebase console

### Cross-device: mobile team member cannot connect

- Firebase works on mobile browsers if HTTPS is available
- Recommend GitHub Pages hosting (which is HTTPS) for mobile access

## Cost warning

Realtime Database billing kicks in after free tier limits:
- $5 per GB storage after 1 GB
- $1 per GB downloaded after 10 GB/month

For a QA team of 20 people doing daily testing, expect to stay well within the free tier.

You can set a **budget alert** in Google Cloud Console to notify you if approaching limits.
