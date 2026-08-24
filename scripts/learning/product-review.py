#!/usr/bin/env python3
"""AIDE_OS product review — one page for everything already in the tree."""
from __future__ import annotations

import json
import os
import sys
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(os.environ.get("AIDE_ROOT", Path.home() / "AIDE_OS"))
CATALOG = ROOT / "product" / "catalog.json"
STATE = ROOT / "product" / "review-state.json"
PORT = int(os.environ.get("AIDE_REVIEW_PORT", "8102"))
HOST = "127.0.0.1"


def load_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text())


def save_state(data: dict) -> None:
    STATE.parent.mkdir(parents=True, exist_ok=True)
    STATE.write_text(json.dumps(data, indent=2) + "\n")


def merged() -> dict:
    cat = load_json(CATALOG)
    if not cat:
        return {"error": f"missing {CATALOG}", "modules": []}
    state = load_json(STATE, {}) or {}
    verdicts = state.get("verdicts") or {}
    modules = []
    for m in cat.get("modules") or []:
        item = dict(m)
        v = verdicts.get(item["id"], {})
        item["verdict"] = v.get("verdict", "pending")
        item["correction"] = v.get("correction", "")
        modules.append(item)
    return {
        "product": cat.get("product", "AIDE_OS"),
        "tagline": cat.get("tagline", ""),
        "student_start": cat.get("student_start", "aide-day"),
        "author_start": cat.get("author_start", "grokAide-start"),
        "modules": modules,
        "counts": {
            "total": len(modules),
            "pending": sum(1 for m in modules if m["verdict"] == "pending"),
            "keep": sum(1 for m in modules if m["verdict"] == "keep"),
            "cut": sum(1 for m in modules if m["verdict"] == "cut"),
            "later": sum(1 for m in modules if m["verdict"] == "later"),
        },
    }


HTML = r"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>AIDE_OS · Product review</title>
  <style>
    :root { --bg:#0e1116; --card:#171b22; --text:#e8edf5; --muted:#93a0b4;
            --line:#2a3140; --keep:#3d9a64; --cut:#c45c5c; --later:#c9a227;
            --live:#5aa9e6; --broken:#d17a4a; --leftover:#8b90a0; }
    * { box-sizing: border-box; }
    body { margin:0; font: 16px/1.45 system-ui, sans-serif; background:var(--bg); color:var(--text); }
    header { padding: 1.5rem 1.75rem 1rem; border-bottom:1px solid var(--line); }
    h1 { margin:0 0 .35rem; font-size:1.45rem; }
    .sub { color:var(--muted); max-width: 46rem; }
    .starts { margin:.9rem 0 0; display:flex; gap:.6rem; flex-wrap:wrap; }
    code { background:#0a0c10; padding:.1rem .35rem; border-radius:4px; }
    .counts { margin-top:.8rem; color:var(--muted); font-size:.95rem; }
    main { padding: 1rem 1.75rem 3rem; display:grid; gap:.75rem; }
    article { background:var(--card); border:1px solid var(--line); border-radius:10px; padding: .9rem 1rem; }
    article h2 { margin:0 0 .25rem; font-size:1.05rem; }
    .meta { color:var(--muted); font-size:.88rem; }
    .notes { margin:.45rem 0 .6rem; }
    .row { display:flex; flex-wrap:wrap; gap:.4rem; align-items:center; }
    button { border:1px solid var(--line); background:#10141a; color:var(--text);
             padding:.3rem .65rem; border-radius:6px; cursor:pointer; }
    button.on-keep { background:var(--keep); border-color:var(--keep); color:#fff; }
    button.on-cut { background:var(--cut); border-color:var(--cut); color:#fff; }
    button.on-later { background:var(--later); border-color:var(--later); color:#111; }
    button.on-pending { outline:1px solid #fff3; }
    textarea { width:100%; margin-top:.55rem; min-height:3.2rem; background:#0a0c10;
               color:var(--text); border:1px solid var(--line); border-radius:6px; padding:.45rem; }
    .pill { font-size:.72rem; text-transform:uppercase; letter-spacing:.04em;
            padding:.12rem .4rem; border-radius:999px; border:1px solid var(--line); color:var(--muted); }
    .status-live { color:#b7e4ff; border-color:var(--live); }
    .status-broken, .status-blocked { color:#ffd0b0; border-color:var(--broken); }
    .status-leftover, .status-stale, .status-history { color:#c5c8d0; border-color:var(--leftover); }
    .ok { color:#8fd9a8; font-size:.85rem; min-height:1.1rem; }
  </style>
</head>
<body>
  <header>
    <h1 id="title">AIDE_OS</h1>
    <p class="sub" id="tagline"></p>
    <p class="sub">This is the product as it exists on disk — including pieces AI sessions left behind. Mark each item keep, cut, or later. Notes save locally to <code>product/review-state.json</code>.</p>
    <div class="starts">
      <span>Student: <code id="stu"></code></span>
      <span>Author: <code id="auth"></code></span>
    </div>
    <p class="counts" id="counts"></p>
  </header>
  <main id="list"></main>
  <script>
    let data = null;

    function pill(status) {
      return `<span class="pill status-${status}">${status}</span>`;
    }

    async function load() {
      const r = await fetch('/api/product');
      data = await r.json();
      document.getElementById('title').textContent = data.product;
      document.getElementById('tagline').textContent = data.tagline || '';
      document.getElementById('stu').textContent = data.student_start;
      document.getElementById('auth').textContent = data.author_start;
      const c = data.counts || {};
      document.getElementById('counts').textContent =
        `${c.total} pieces · ${c.pending} pending · ${c.keep} keep · ${c.cut} cut · ${c.later} later`;
      const root = document.getElementById('list');
      root.innerHTML = '';
      for (const m of data.modules) {
        const el = document.createElement('article');
        el.innerHTML = `
          <h2>${m.name} ${pill(m.status)} ${pill(m.layer)}</h2>
          <p class="meta"><code>${m.path || ''}</code>${m.start ? ' · start: <code>'+m.start+'</code>' : ''}</p>
          <p class="notes">${m.notes || ''}</p>
          <div class="row" data-id="${m.id}">
            <button data-v="keep">Keep</button>
            <button data-v="cut">Cut</button>
            <button data-v="later">Later</button>
            <button data-v="pending">Clear</button>
          </div>
          <textarea data-id="${m.id}" placeholder="Correction or why">${m.correction || ''}</textarea>
          <p class="ok" id="ok-${m.id}"></p>`;
        root.appendChild(el);
        paint(el, m.verdict);
      }
      root.querySelectorAll('button[data-v]').forEach(btn => {
        btn.onclick = () => save(btn.parentElement.dataset.id, btn.dataset.v,
          root.querySelector(`textarea[data-id="${btn.parentElement.dataset.id}"]`).value);
      });
      root.querySelectorAll('textarea').forEach(t => {
        t.onchange = () => save(t.dataset.id, null, t.value);
      });
    }

    function paint(article, verdict) {
      article.querySelectorAll('button[data-v]').forEach(b => {
        b.className = b.dataset.v === verdict ? 'on-' + verdict : '';
      });
    }

    async function save(id, verdict, correction) {
      const body = { id, correction };
      if (verdict) body.verdict = verdict;
      const r = await fetch('/api/verdict', {
        method: 'POST', headers: {'Content-Type':'application/json'},
        body: JSON.stringify(body)
      });
      const j = await r.json();
      document.getElementById('ok-' + id).textContent = j.message || 'Saved.';
      await load();
    }

    load();
  </script>
</body>
</html>
"""


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _send(self, code: int, ctype: str, body: bytes):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _json(self, code: int, obj: dict):
        self._send(code, "application/json", json.dumps(obj).encode())

    def do_GET(self):
        path = urlparse(self.path).path
        if path in ("/", "/index.html", "/review"):
            return self._send(200, "text/html; charset=utf-8", HTML.encode())
        if path == "/api/product":
            return self._json(200, merged())
        self.send_error(404)

    def do_POST(self):
        if urlparse(self.path).path != "/api/verdict":
            return self.send_error(404)
        n = int(self.headers.get("Content-Length") or 0)
        try:
            payload = json.loads(self.rfile.read(n).decode() or "{}")
        except json.JSONDecodeError:
            return self._json(400, {"ok": False, "message": "bad json"})
        mid = payload.get("id")
        if not mid:
            return self._json(400, {"ok": False, "message": "id required"})
        state = load_json(STATE, {}) or {}
        verdicts = state.setdefault("verdicts", {})
        cur = verdicts.get(mid, {})
        if "verdict" in payload and payload["verdict"]:
            cur["verdict"] = payload["verdict"]
        if "correction" in payload:
            cur["correction"] = payload["correction"]
        verdicts[mid] = cur
        save_state(state)
        return self._json(200, {"ok": True, "message": "Saved."})


def main() -> int:
    if not CATALOG.exists():
        print("Missing catalog:", CATALOG, file=sys.stderr)
        return 1
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    url = f"http://{HOST}:{PORT}/"
    print(f"AIDE_OS product review → {url}", flush=True)
    print("Mark keep / cut / later. Notes write to product/review-state.json", flush=True)
    if os.environ.get("AIDE_REVIEW_NO_BROWSER") != "1":
        webbrowser.open(url)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nstopped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
