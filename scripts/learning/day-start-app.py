#!/usr/bin/env python3
"""AIDE_OS Day Start — calm focus GUI + progress API (LFCS focus cycle)."""
from __future__ import annotations

import json
import os
import sys
import webbrowser
from datetime import date, datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(os.environ.get("AIDE_ROOT", Path.home() / "AIDE_OS"))
SCHED = ROOT / "brain/bootcamp/lfcs/schedule/daily-schedule.json"
RES = ROOT / "brain/bootcamp/lfcs/schedule/lesson-resources.json"
PROGRESS = ROOT / "brain/bootcamp/lfcs/progress/focus-progress.json"
PORT = int(os.environ.get("AIDE_DAY_PORT", "8101"))
HOST = "127.0.0.1"


def load_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text())


def save_progress(data: dict) -> None:
    PROGRESS.parent.mkdir(parents=True, exist_ok=True)
    PROGRESS.write_text(json.dumps(data, indent=2) + "\n")


def ensure_progress() -> dict:
    p = load_json(PROGRESS)
    if not p:
        p = {
            "version": 1,
            "focus_cycle_started": date.today().isoformat(),
            "focus_day": 1,
            "completed_days": [],
            "sessions": [],
            "pomodoro_min": 25,
        }
        save_progress(p)
    return p


def youtube_for_project(project: str) -> list[str]:
    r = load_json(RES, {}) or {}
    block = r.get(str(project)) or r.get("default") or {}
    urls: list[str] = []

    def pull(obj):
        if isinstance(obj, str) and "youtu" in obj:
            urls.append(obj)
        elif isinstance(obj, dict):
            u = obj.get("url")
            if isinstance(u, str) and "youtu" in u:
                urls.append(u)
            for vv in obj.values():
                pull(vv)
        elif isinstance(obj, list):
            for x in obj:
                pull(x)

    pull(block)
    # de-dupe preserve order
    seen = set()
    out = []
    for u in urls:
        if u not in seen:
            seen.add(u)
            out.append(u)
    return out[:5]


def today_payload() -> dict:
    sched = load_json(SCHED, {})
    days = (sched or {}).get("days") or []
    prog = ensure_progress()
    n = int(prog.get("focus_day") or 1)
    n = max(1, min(n, len(days) or 1))
    day = days[n - 1] if days else {"title": "No schedule loaded", "domains": [], "duration_min": 25}
    completed = set(prog.get("completed_days") or [])
    return {
        "focus_day": n,
        "total_days": len(days) or 45,
        "completed_count": len(completed),
        "completed_days": sorted(completed),
        "title": day.get("title", ""),
        "domains": day.get("domains") or [],
        "duration_min": day.get("duration_min") or prog.get("pomodoro_min") or 25,
        "project": str(day.get("project") or ""),
        "phase": day.get("phase") or "",
        "node": day.get("node") or "um690",
        "youtube": youtube_for_project(str(day.get("project") or "default")),
        "pomodoro_min": prog.get("pomodoro_min") or 25,
        "cycle_started": prog.get("focus_cycle_started"),
        "encouragement": (
            "One block. One title. Progress counts even when attention is hard."
        ),
        "date": date.today().isoformat(),
    }


HTML = r"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Into the Sequence · Day Start</title>
  <style>
    :root {
      --bg: #0a0b10;
      --panel: #12141c;
      --text: #e4e7f1;
      --muted: #9aa3b8;
      --cyan: #5ec8d6;
      --mag: #c77dff;
      --ok: #6bcf7f;
      --warn: #e0b35a;
      --font: system-ui, "Segoe UI", sans-serif;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0; min-height: 100vh; font-family: var(--font);
      background: radial-gradient(800px 400px at 50% 0%, #1a1530 0%, var(--bg) 55%);
      color: var(--text); display: flex; align-items: center; justify-content: center;
      padding: 1.25rem;
    }
    .card {
      width: min(420px, 100%);
      background: var(--panel);
      border: 1px solid rgba(94, 200, 214, 0.25);
      border-radius: 16px;
      padding: 1.35rem 1.4rem 1.5rem;
      box-shadow: 0 12px 40px rgba(0,0,0,.45);
    }
    .eyebrow { font-size: .72rem; letter-spacing: .14em; text-transform: uppercase; color: var(--cyan); margin: 0 0 .4rem; }
    h1 { font-size: 1.35rem; margin: 0 0 .35rem; font-weight: 700; }
    .sub { color: var(--muted); font-size: .92rem; margin: 0 0 1rem; line-height: 1.45; }
    .title {
      font-size: 1.05rem; font-weight: 600; line-height: 1.35;
      margin: 0 0 .5rem; color: #fff;
    }
    .meta { font-size: .85rem; color: var(--muted); margin-bottom: 1rem; }
    .meta span { display: inline-block; margin-right: .6rem; }
    .bar {
      height: 10px; background: #1e2230; border-radius: 999px; overflow: hidden;
      margin: .35rem 0 .85rem; border: 1px solid rgba(255,255,255,.06);
    }
    .bar > i {
      display: block; height: 100%; width: 0%;
      background: linear-gradient(90deg, var(--mag), var(--cyan));
      transition: width .35s ease;
    }
    .pct { font-size: .8rem; color: var(--muted); margin-bottom: 1rem; }
    .timer {
      font-variant-numeric: tabular-nums;
      font-size: 2.6rem; font-weight: 700; text-align: center;
      letter-spacing: .04em; margin: .5rem 0 1rem;
    }
    .timer.run { color: var(--cyan); }
    .timer.done { color: var(--ok); }
    .btns { display: flex; flex-direction: column; gap: .55rem; }
    button, a.btn {
      display: block; width: 100%; text-align: center; text-decoration: none;
      border: none; border-radius: 10px; padding: .75rem 1rem;
      font-size: .95rem; font-weight: 700; cursor: pointer;
      font-family: inherit;
    }
    .primary {
      background: linear-gradient(135deg, #5ec8d6, #7aa2f7);
      color: #0a0b10;
    }
    .primary:hover { filter: brightness(1.06); }
    .secondary {
      background: transparent; color: var(--text);
      border: 1px solid rgba(199, 125, 255, .4);
    }
    .ghost {
      background: transparent; color: var(--muted);
      border: 1px solid rgba(255,255,255,.1); font-weight: 600;
    }
    .msg {
      font-size: .88rem; color: var(--ok); min-height: 1.2em;
      margin-top: .75rem; text-align: center;
    }
    .breathe {
      font-size: .8rem; color: var(--muted); text-align: center;
      margin-top: 1rem; line-height: 1.4;
    }
    .yt { margin-top: .5rem; }
    .yt a { color: var(--cyan); font-size: .85rem; word-break: break-all; }
  </style>
</head>
<body>
  <main class="card">
    <p class="eyebrow">Destroy The Kraken · Into the Sequence</p>
    <h1>Day Start</h1>
    <p class="sub" id="encourage">One block. One title. That is enough.</p>
    <p class="title" id="title">Loading…</p>
    <p class="meta" id="meta"></p>
    <div class="bar"><i id="bar"></i></div>
    <p class="pct" id="pct"></p>
    <div class="timer" id="timer">25:00</div>
    <div class="btns">
      <button class="primary" type="button" id="btnStart">Start focus block</button>
      <button class="secondary" type="button" id="btnDone" disabled>Mark day complete</button>
      <a class="ghost btn" id="btnYt" href="#" target="_blank" rel="noopener" style="display:none">Open lesson video</a>
      <button class="ghost" type="button" id="btnSkip">Skip to next day (no complete)</button>
    </div>
    <p class="msg" id="msg"></p>
    <p class="breathe">Nervous is allowed. Memorization gets easier when you <em>do</em> one small lab, not when you stare at the whole exam.</p>
  </main>
  <script>
    let data = null;
    let left = 25 * 60;
    let iv = null;

    async function load() {
      const r = await fetch('/api/today');
      data = await r.json();
      document.getElementById('title').textContent = data.title || '(no title)';
      document.getElementById('encourage').textContent = data.encouragement || '';
      const dom = (data.domains || []).join(', ');
      document.getElementById('meta').innerHTML =
        `<span>Day <strong>${data.focus_day}</strong> / ${data.total_days}</span>` +
        `<span>${data.duration_min || data.pomodoro_min} min</span>` +
        (dom ? `<span>${dom}</span>` : '');
      const pct = data.total_days ? Math.round(100 * data.completed_count / data.total_days) : 0;
      document.getElementById('bar').style.width = pct + '%';
      document.getElementById('pct').textContent =
        `${data.completed_count} days checked · ${pct}% of cycle`;
      left = (data.pomodoro_min || 25) * 60;
      paintTimer();
      const yt = (data.youtube || [])[0];
      const a = document.getElementById('btnYt');
      if (yt) { a.href = yt; a.style.display = 'block'; }
      else { a.style.display = 'none'; }
    }

    function paintTimer() {
      const m = Math.floor(left / 60);
      const s = left % 60;
      document.getElementById('timer').textContent =
        String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
    }

    document.getElementById('btnStart').onclick = async () => {
      if (iv) return;
      document.getElementById('timer').classList.add('run');
      document.getElementById('msg').textContent = 'Focus. Phone face-down if you can.';
      await fetch('/api/session-start', { method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ focus_day: data.focus_day }) });
      iv = setInterval(() => {
        left -= 1;
        paintTimer();
        if (left <= 0) {
          clearInterval(iv); iv = null;
          document.getElementById('timer').classList.remove('run');
          document.getElementById('timer').classList.add('done');
          document.getElementById('btnDone').disabled = false;
          document.getElementById('msg').textContent = 'Block done. Mark complete if you showed up.';
        }
      }, 1000);
    };

    document.getElementById('btnDone').onclick = async () => {
      const r = await fetch('/api/complete', { method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ focus_day: data.focus_day }) });
      const j = await r.json();
      document.getElementById('msg').textContent = j.message || 'Saved.';
      document.getElementById('btnDone').disabled = true;
      await load();
    };

    document.getElementById('btnSkip').onclick = async () => {
      await fetch('/api/advance', { method: 'POST' });
      document.getElementById('msg').textContent = 'Advanced without completing.';
      if (iv) { clearInterval(iv); iv = null; }
      document.getElementById('timer').classList.remove('run','done');
      await load();
    };

    load();
  </script>
</body>
</html>
"""


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _json(self, code: int, obj: dict):
        body = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _html(self, html: str):
        body = html.encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urlparse(self.path).path
        if path in ("/", "/index.html", "/day", "/day/"):
            return self._html(HTML)
        if path == "/api/today":
            return self._json(200, today_payload())
        self.send_error(404)

    def do_POST(self):
        path = urlparse(self.path).path
        length = int(self.headers.get("Content-Length") or 0)
        raw = self.rfile.read(length) if length else b"{}"
        try:
            body = json.loads(raw.decode() or "{}")
        except json.JSONDecodeError:
            body = {}

        prog = ensure_progress()
        now = datetime.now(timezone.utc).isoformat()

        if path == "/api/session-start":
            prog.setdefault("sessions", []).append(
                {
                    "type": "start",
                    "focus_day": body.get("focus_day") or prog.get("focus_day"),
                    "at": now,
                }
            )
            # keep last 100
            prog["sessions"] = prog["sessions"][-100:]
            save_progress(prog)
            return self._json(200, {"ok": True})

        if path == "/api/complete":
            day = int(body.get("focus_day") or prog.get("focus_day") or 1)
            done = set(prog.get("completed_days") or [])
            done.add(day)
            prog["completed_days"] = sorted(done)
            prog.setdefault("sessions", []).append(
                {"type": "complete", "focus_day": day, "at": now}
            )
            prog["sessions"] = prog["sessions"][-100:]
            # advance focus to next incomplete day
            total = len((load_json(SCHED) or {}).get("days") or list(range(45)))
            nxt = day + 1
            while nxt <= total and nxt in done:
                nxt += 1
            if nxt <= total:
                prog["focus_day"] = nxt
            save_progress(prog)
            # journal crumb
            jdir = ROOT / "docs/journal"
            jdir.mkdir(parents=True, exist_ok=True)
            crumb = jdir / "focus-crumbs.log"
            with crumb.open("a") as f:
                f.write(f"{date.today().isoformat()} completed focus_day={day}\n")
            return self._json(
                200,
                {
                    "ok": True,
                    "message": f"Day {day} logged. Heart counts showing up.",
                    "next_focus_day": prog.get("focus_day"),
                },
            )

        if path == "/api/advance":
            total = len((load_json(SCHED) or {}).get("days") or list(range(45)))
            cur = int(prog.get("focus_day") or 1)
            prog["focus_day"] = min(cur + 1, total)
            save_progress(prog)
            return self._json(200, {"ok": True, "focus_day": prog["focus_day"]})

        self.send_error(404)


def main():
    ensure_progress()
    if len(sys.argv) > 1 and sys.argv[1] in ("--print", "-p"):
        print(json.dumps(today_payload(), indent=2))
        return 0
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    url = f"http://{HOST}:{PORT}/"
    print(f"Day Start GUI → {url}", flush=True)
    print("Ctrl+C to stop. Progress:", PROGRESS, flush=True)
    try:
        webbrowser.open(url)
    except Exception:
        pass
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
