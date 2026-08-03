#!/usr/bin/env bash
# Ara eval harness — RAG via Open WebUI, overlay via ollama run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROMPTS="${LFCS_ROOT}/validation/ara-eval-prompts.json"
CONTEXT="${LFCS_ROOT}/ara_tutor/session/context.md"
EVAL_LOG="${LFCS_ROOT}/notifications/ara-eval.log"
DEPLOY_DIR="${DEPLOY_DIR:-/opt/lfcs/secure-browser-forge}"
ENV_FILE="${DEPLOY_DIR}/.env"
[[ -f "${ENV_FILE}" ]] && set -a && source "${ENV_FILE}" && set +a

TS_IP="$(tailscale ip -4 2>/dev/null || echo '100.81.13.95')"
OWUI_URL="${OWUI_URL:-http://${TS_IP}:3082}"
OLLAMA_URL="${OLLAMA_URL:-http://${TS_IP}:11434}"

python3 - <<PY
import json, os, re, subprocess, urllib.request
from pathlib import Path

lfcs = Path("${LFCS_ROOT}")
prompts = json.loads(Path("${PROMPTS}").read_text())
context_path = Path("${CONTEXT}")
context = {}
if context_path.exists():
    for line in context_path.read_text().splitlines():
        m = re.match(r"^(\w+):\s*(.+)$", line.strip())
        if m:
            k, v = m.group(1), m.group(2).strip().strip('"')
            context[k] = v

def resolve_overlay_expectations(item):
    if not item.get("dynamic"):
        return item.get("expect_substrings", [])
    fields = item.get("expect_from_context", [])
    out = []
    for f in fields:
        if f in context:
            out.append(str(context[f]))
    return out

def ollama_run(prompt):
    try:
        r = subprocess.run(
            ["docker", "exec", "lfcs-ollama", "ollama", "run", "Ara", prompt],
            capture_output=True, text=True, timeout=120,
        )
        return r.stdout + r.stderr
    except Exception as e:
        return str(e)

def owui_chat(prompt):
    api_key = os.environ.get("OPENWEBUI_API_KEY", "")
    headers = {"Content-Type": "application/json"}
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"
    body = json.dumps({
        "model": "Ara",
        "messages": [{"role": "user", "content": prompt}],
        "stream": False,
    }).encode()
    req = urllib.request.Request(
        f"${OWUI_URL}/api/chat/completions",
        data=body, headers=headers, method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = json.loads(resp.read().decode())
        return data.get("choices", [{}])[0].get("message", {}).get("content", "")
    except Exception as e:
        return f"SKIP: {e}"

def score_response(text, expects):
    if not expects:
        return True
    low = text.lower()
    return all(e.lower() in low for e in expects)

rag_pass = rag_total = 0
overlay_pass = overlay_total = 0
lines = []

for item in prompts.get("rag_suite", []):
    rag_total += 1
    text = owui_chat(item["prompt"]) if item.get("runner") == "openwebui" else ollama_run(item["prompt"])
    ok = score_response(text, item.get("expect_substrings", []))
    if ok and not text.startswith("SKIP:"):
        rag_pass += 1
    lines.append(f"RAG {item['id']}: {'PASS' if ok else 'FAIL'}")

for item in prompts.get("overlay_suite", []):
    overlay_total += 1
    expects = resolve_overlay_expectations(item)
    text = ollama_run(item["prompt"])
    ok = score_response(text, expects)
    if ok:
        overlay_pass += 1
    lines.append(f"OVERLAY {item['id']}: {'PASS' if ok else 'WARN'}")

rag_rate = rag_pass / rag_total if rag_total else 0
overlay_rate = overlay_pass / overlay_total if overlay_total else 0
summary = f"rag_pass={rag_rate:.2f} overlay_pass={overlay_rate:.2f} rag_hits={rag_pass}/{rag_total}"
print(summary)
for ln in lines:
    print(ln)

Path("${EVAL_LOG}").open("a").write(
    f"{__import__('datetime').datetime.now().isoformat()} {summary}\n"
)
PY