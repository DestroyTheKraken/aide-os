# Tablet Access — Ready Now

Backend is live on um690. Use these URLs from **j-tab** (Tailscale must be connected).

## 1. LFCS Portal (start here — UI/UX tuning)

```
http://100.81.13.95:3080/
```

No login required. Mobile-friendly dashboard with today's guidance.

## 2. Mullvad Browser (secure Firefox lab)

```
https://100.81.13.95:3001/
```

| Field | Value |
|-------|-------|
| Username | `lfcs` |
| Password | `a3cDMXOmMt1JKkxu` |

**Certificate warning:** Tap Advanced → Proceed (self-signed cert is expected).

First load may take **1–2 minutes** while Firefox initializes inside the container.

## Tablet setup steps

1. Open **Chrome or Samsung Internet** on j-tab (or Firefox).
2. Ensure **Tailscale** is connected (green/active).
3. Bookmark both URLs above.
4. Open Portal first → review layout → tap **Open Mullvad Browser**.
5. Log into Mullvad Browser → configure Firefox bookmarks/homepage for your UI/UX pass.

## If browser won't connect

On um690 (Termius SSH):

```bash
sg docker -c 'docker ps -a'
sg docker -c 'docker start secure-browser-forge'   # if Created/Exited
sg docker -c 'docker logs -f secure-browser-forge' # watch startup
```

## After UI/UX config

We'll connect this backend to your frontend. Note what you change (bookmarks, homepage, portal HTML) so we can persist it in `portal/www/` and compose volumes.