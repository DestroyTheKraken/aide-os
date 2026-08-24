#!/usr/bin/env python3
"""AIDE_OS student seat — welcome + daily lesson for the learner named Student."""
from __future__ import annotations

import html
import json
import os
import re
import sys
import webbrowser
from datetime import date, datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

ROOT = Path(os.environ.get("AIDE_ROOT", Path.home() / "AIDE_OS"))
SCHED = ROOT / "brain/bootcamp/lfcs/schedule/daily-schedule.json"
RES = ROOT / "brain/bootcamp/lfcs/schedule/lesson-resources.json"
PROGRESS = ROOT / "brain/bootcamp/lfcs/progress/focus-progress.json"
STUDENT = ROOT / "product" / "student.json"
STUDIES = ROOT / "Study_Projects"
PORT = int(os.environ.get("AIDE_DAY_PORT", "8101"))
HOST = "127.0.0.1"


def load_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text())


def save_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n")


def student() -> dict:
    s = load_json(STUDENT) or {}
    s.setdefault("display_name", "Student")
    s.setdefault("username", "student")
    s.setdefault("program", "Linux System Administration")
    s.setdefault("onboarded", False)
    return s


def save_progress(data: dict) -> None:
    save_json(PROGRESS, data)


def ensure_progress() -> dict:
    p = load_json(PROGRESS)
    if not p:
        p = {
            "version": 2,
            "learner": "student",
            "focus_cycle_started": date.today().isoformat(),
            "focus_day": 1,
            "completed_days": [],
            "sessions": [],
            "pomodoro_min": 25,
        }
        save_progress(p)
    return p


def md_lite(text: str) -> str:
    lines = text.replace("\r\n", "\n").split("\n")
    out = []
    in_list = False
    in_pre = False
    for line in lines:
        if line.startswith("```"):
            if in_list:
                out.append("</ul>")
                in_list = False
            if not in_pre:
                out.append("<pre><code>")
                in_pre = True
            else:
                out.append("</code></pre>")
                in_pre = False
            continue
        if in_pre:
            out.append(html.escape(line))
            continue
        if re.match(r"^[-*] ", line):
            if not in_list:
                out.append("<ul>")
                in_list = True
            body = html.escape(line[2:])
            body = re.sub(r"`([^`]+)`", r"<code>\1</code>", body)
            out.append(f"<li>{body}</li>")
            continue
        if in_list:
            out.append("</ul>")
            in_list = False
        if line.startswith("# "):
            out.append(f"<h1>{html.escape(line[2:])}</h1>")
        elif line.startswith("## "):
            out.append(f"<h2>{html.escape(line[3:])}</h2>")
        elif line.startswith("### "):
            out.append(f"<h3>{html.escape(line[4:])}</h3>")
        elif line.startswith("---"):
            out.append("<hr />")
        elif line.strip() == "":
            out.append("")
        else:
            body = html.escape(line)
            body = re.sub(r"`([^`]+)`", r"<code>\1</code>", body)
            body = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", body)
            out.append(f"<p>{body}</p>")
    if in_list:
        out.append("</ul>")
    if in_pre:
        out.append("</code></pre>")
    return "\n".join(out)


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
    seen, out = set(), []
    for u in urls:
        if u not in seen:
            seen.add(u)
            out.append(u)
    return out[:5]


def study_html(project: str) -> str | None:
    if not project or project in ("—", "-", "mix"):
        return None
    path = STUDIES / f"{str(project).zfill(2)}.md"
    if not path.exists():
        path = STUDIES / f"{project}.md"
    if not path.exists():
        return None
    return md_lite(path.read_text())


def today_payload() -> dict:
    sched = load_json(SCHED, {})
    days = (sched or {}).get("days") or []
    prog = ensure_progress()
    n = int(prog.get("focus_day") or 1)
    n = max(1, min(n, len(days) or 1))
    day = days[n - 1] if days else {"title": "No schedule loaded", "domains": []}
    completed = set(prog.get("completed_days") or [])
    project = str(day.get("project") or "")
    st = student()
    return {
        "learner": st.get("display_name") or "Student",
        "username": st.get("username") or "student",
        "program": st.get("program") or "Linux System Administration",
        "exam": st.get("exam") or "LFCS",
        "exam_target": st.get("exam_target") or "",
        "onboarded": bool(st.get("onboarded")),
        "focus_day": n,
        "total_days": len(days) or 45,
        "completed_count": len(completed),
        "completed_days": sorted(completed),
        "title": day.get("title", ""),
        "domains": day.get("domains") or [],
        "duration_min": day.get("duration_min") or prog.get("pomodoro_min") or 25,
        "project": project,
        "phase": day.get("phase") or "",
        "practice": (
            "Open a terminal on this computer and work through the lesson text. "
            "Optional: start the practice VM with "
            "`multipass start grokaide-edu && multipass shell grokaide-edu`."
        ),
        "youtube": youtube_for_project(project),
        "pomodoro_min": prog.get("pomodoro_min") or 25,
        "cycle_started": prog.get("focus_cycle_started"),
        "date": date.today().isoformat(),
        "has_lesson": study_html(project) is not None,
    }


HTML = r"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>AIDE — Student</title>
  <style>
    :root {
      --bg: #f4f1ea; --ink: #1c2430; --muted: #5b6573; --card: #fffdf8;
      --line: #d9d2c5; --accent: #1f5f8b; --ok: #2f6f4e; --warn: #8a5a12;
    }
    * { box-sizing: border-box; }
    body { margin: 0; font: 18px/1.5 "Source Serif 4", "Liberation Serif", Georgia, serif;
           background: var(--bg); color: var(--ink); }
    header { padding: 1.4rem 1.6rem .4rem; }
    h1 { font-size: 1.65rem; margin: 0 0 .25rem; font-weight: 650; }
    .muted { color: var(--muted); }
    main { padding: 0 1.6rem 3rem; max-width: 46rem; }
    .card { background: var(--card); border: 1px solid var(--line); border-radius: 12px;
            padding: 1.15rem 1.25rem; margin: .85rem 0; }
    .bar { height: 8px; background: #e6e0d4; border-radius: 99px; overflow: hidden; }
    .bar > i { display: block; height: 100%; background: var(--accent); width: 0; }
    button, .btn { font: inherit; border-radius: 8px; padding: .5rem .95rem; cursor: pointer;
                   border: 1px solid var(--line); background: #fff; color: var(--ink);
                   text-decoration: none; display: inline-block; }
    button.primary, .btn.primary { background: var(--accent); color: #fff; border-color: var(--accent); }
    button:disabled { opacity: .45; cursor: not-allowed; }
    .row { display: flex; flex-wrap: wrap; gap: .5rem; margin-top: .85rem; }
    .lesson h1, .lesson h2, .lesson h3 { font-family: inherit; }
    .lesson h1 { font-size: 1.25rem; }
    .lesson h2 { font-size: 1.1rem; margin-top: 1.1rem; }
    .lesson pre { background: #1c2430; color: #eef3f8; padding: .8rem 1rem; overflow: auto;
                  border-radius: 8px; font-size: .88rem; }
    .lesson code { font-family: ui-monospace, "Liberation Mono", monospace; font-size: .9em; }
    .lesson p code, .lesson li code { background: #ece7dc; padding: .05rem .3rem; border-radius: 4px; }
    .hidden { display: none; }
    #timer { font-variant-numeric: tabular-nums; font-size: 1.7rem; margin: .4rem 0; }
    #msg { min-height: 1.3rem; color: var(--ok); }
  </style>
</head>
<body>
  <header>
    <p class="muted" id="who"></p>
    <h1 id="headline">AIDE</h1>
    <p class="muted" id="sub"></p>
  </header>
  <main>
    <section id="welcome" class="card hidden">
      <p>This computer is set up as a learning seat. You are signed in as <strong>Student</strong>.</p>
      <p>AIDE walks you through Linux system administration toward the Linux Foundation exam (LFCS). Each day has one lesson. The software remembers where you stopped.</p>
      <p>You do not need to find folders or start Docker. Use this page. When you are ready, begin day 1.</p>
      <div class="row">
        <button class="primary" type="button" id="btnBegin">Begin as Student</button>
      </div>
    </section>

    <section id="today" class="hidden">
      <div class="card">
        <p class="muted" id="progressLabel"></p>
        <div class="bar"><i id="bar"></i></div>
        <h2 id="title" style="margin:.7rem 0 .2rem;font-size:1.35rem;"></h2>
        <p class="muted" id="meta"></p>
        <p id="howto"></p>
        <div id="timer">25:00</div>
        <p id="msg"></p>
        <div class="row">
          <button class="primary" type="button" id="btnStart">Start today's block</button>
          <button type="button" id="btnDone" disabled>Mark day complete</button>
          <a class="btn" id="btnYt" href="#" target="_blank" rel="noopener" style="display:none">Open related video</a>
          <button type="button" id="btnSkip">Skip this day</button>
        </div>
      </div>
      <article class="card lesson" id="lesson"></article>
    </section>
  </main>
  <script>
    let data = null, left = 25 * 60, iv = null;

    async function load() {
      const r = await fetch('/api/today');
      data = await r.json();
      document.getElementById('who').textContent =
        data.learner + ' · ' + data.program;
      const welcome = document.getElementById('welcome');
      const today = document.getElementById('today');
      if (!data.onboarded) {
        document.getElementById('headline').textContent = 'Welcome, Student';
        document.getElementById('sub').textContent =
          'A guided path through Linux administration. One lesson at a time.';
        welcome.classList.remove('hidden');
        today.classList.add('hidden');
        return;
      }
      welcome.classList.add('hidden');
      today.classList.remove('hidden');
      document.getElementById('headline').textContent = 'Today’s lesson';
      document.getElementById('sub').textContent =
        (data.exam || 'LFCS') + (data.exam_target ? ' · target ' + data.exam_target : '');
      const pct = data.total_days ? Math.round(100 * data.completed_count / data.total_days) : 0;
      document.getElementById('progressLabel').textContent =
        'Day ' + data.focus_day + ' of ' + data.total_days +
        ' · ' + data.completed_count + ' finished (' + pct + '%)';
      document.getElementById('bar').style.width = pct + '%';
      document.getElementById('title').textContent = data.title || 'Lesson';
      const bits = [];
      if (data.domains && data.domains.length) bits.push(data.domains.join(', '));
      if (data.project && data.project !== '—') bits.push('Project ' + data.project);
      if (data.phase) bits.push('Phase ' + data.phase);
      bits.push((data.duration_min || 25) + ' minutes suggested');
      document.getElementById('meta').textContent = bits.join(' · ');
      document.getElementById('howto').textContent = data.practice || '';
      left = (data.pomodoro_min || data.duration_min || 25) * 60;
      paintTimer();
      const yt = (data.youtube || [])[0];
      const a = document.getElementById('btnYt');
      if (yt) { a.href = yt; a.style.display = 'inline-block'; }
      else { a.style.display = 'none'; }
      const lr = await fetch('/api/lesson?project=' + encodeURIComponent(data.project || ''));
      const lj = await lr.json();
      document.getElementById('lesson').innerHTML = lj.html ||
        '<p class="muted">There is no written lab for this day — use the title as your drill, or skip to the next working day.</p>';
    }

    function paintTimer() {
      const m = Math.floor(left / 60), s = left % 60;
      document.getElementById('timer').textContent =
        String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
    }

    document.getElementById('btnBegin').onclick = async () => {
      await fetch('/api/onboard', { method: 'POST' });
      await load();
    };

    document.getElementById('btnStart').onclick = async () => {
      if (iv) return;
      document.getElementById('msg').textContent = 'Work through the lesson below. The timer is only a guide.';
      await fetch('/api/session-start', { method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ focus_day: data.focus_day }) });
      iv = setInterval(() => {
        left -= 1; paintTimer();
        if (left <= 0) {
          clearInterval(iv); iv = null;
          document.getElementById('btnDone').disabled = false;
          document.getElementById('msg').textContent = 'Suggested time is up. Mark complete if you finished the work.';
        }
      }, 1000);
      document.getElementById('btnDone').disabled = false;
    };

    document.getElementById('btnDone').onclick = async () => {
      const r = await fetch('/api/complete', { method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify({ focus_day: data.focus_day }) });
      const j = await r.json();
      document.getElementById('msg').textContent = j.message || 'Saved.';
      if (iv) { clearInterval(iv); iv = null; }
      await load();
    };

    document.getElementById('btnSkip').onclick = async () => {
      await fetch('/api/advance', { method: 'POST' });
      if (iv) { clearInterval(iv); iv = null; }
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

    def _html(self, html_text: str):
        body = html_text.encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path
        if path in ("/", "/index.html", "/day", "/day/"):
            return self._html(HTML)
        if path == "/api/today":
            return self._json(200, today_payload())
        if path == "/api/lesson":
            q = parse_qs(parsed.query)
            project = (q.get("project") or [""])[0]
            rendered = study_html(project)
            return self._json(200, {"html": rendered, "project": project})
        self.send_error(404)

    def do_POST(self):
        path = urlparse(self.path).path
        length = int(self.headers.get("Content-Length") or 0)
        raw = self.rfile.read(length) if length else b"{}"
        try:
            body = json.loads(raw.decode() or "{}")
        except json.JSONDecodeError:
            body = {}

        if path == "/api/onboard":
            st = student()
            st["onboarded"] = True
            save_json(STUDENT, st)
            return self._json(200, {"ok": True})

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
            total = len((load_json(SCHED) or {}).get("days") or list(range(45)))
            nxt = day + 1
            while nxt <= total and nxt in done:
                nxt += 1
            if nxt <= total:
                prog["focus_day"] = nxt
            save_progress(prog)
            return self._json(
                200,
                {
                    "ok": True,
                    "message": f"Day {day} is recorded. Tomorrow you will start day {prog.get('focus_day')}.",
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
    print(f"Student seat → {url}", flush=True)
    print("Learner: Student. Ctrl+C to stop.", flush=True)
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
