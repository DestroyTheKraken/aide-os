# Import AIDE_OS LinkBoard (your Desktop)

**What this is:** LinkBoard is your Nextcloud “home screen” — tiles that open services (like a desktop).  
**Why:** Replaces the old Dashboard and, over time, the `/ops` page.

**File:** `aide-os-desktop.json` (same folder as this guide).

---

## Step-by-step (you do this in the browser)

### A. Get the file open in Nextcloud

1. Open Firefox → **https://um690.taile52ad9.ts.net** (Tailscale on).  
2. Log in as **admin** (or the account that owns the board).  
3. Open **Files**.  
4. Go to folder **AIDE_OS → LinkBoard**.  
5. Download **`aide-os-desktop.json`** to this computer (or keep it in Files if the app can pick it).

### B. Import into LinkBoard

1. In Nextcloud top menu / apps, open **LinkBoard**.  
2. Open **Settings** inside LinkBoard (gear / settings).  
3. Find **Import / Export**.  
4. Choose **Import JSON**.  
5. Select `aide-os-desktop.json`.  
6. If asked for mode: prefer **Replace** only if this is a new empty board; otherwise **Merge** if you already have tiles you want to keep.  
7. Confirm. You should see categories: **AI — Grok Web + Build**, **Platform services**, **Lab machines**, **Knowledge & sessions**.

### C. Optional: make this everyone’s Desktop (Global board)

**What:** All users see the same board (admins can edit).  
**Why:** Family/business share one AIDE_OS home.

1. Nextcloud → **Settings → Administration → LinkBoard**.  
2. Enable **Show a global LinkBoard for all users**.  
3. Select the user who owns the imported board (usually **admin**).  
4. **Save**.

### D. Optional: set LinkBoard as first app

In Nextcloud user settings, pin LinkBoard or set default app if available for your version — so login lands on the “Desktop.”

---

## If import fails

- Use **admin** account.  
- Ensure app **linkboard** is enabled (Apps).  
- Try re-download the JSON (must be valid JSON).  
- Tell Grok: “LinkBoard import failed” + any error text — Grok can fix the file.
