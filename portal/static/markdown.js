/**
 * LFCS Markdown → HTML (AIOS theme-aware output)
 */
(function (global) {
  'use strict';

  function esc(s) {
    const d = document.createElement('div');
    d.textContent = s == null ? '' : String(s);
    return d.innerHTML;
  }

  function biIcon(name) {
    const safe = String(name || '').toLowerCase().replace(/[^a-z0-9-]/g, '');
    if (!safe) return '';
    return `<i class="bi bi-${safe} md-bi-icon" aria-hidden="true"></i>`;
  }

  function inline(text) {
    const re = /(`[^`]+`|\*\*[^*]+\*\*|\*[^*]+\*|\[[^\]]+\]\([^)]+\)|:bi-[a-z0-9-]+:)/gi;
    let out = '';
    let last = 0;
    let m;
    while ((m = re.exec(text)) !== null) {
      if (m.index > last) out += esc(text.slice(last, m.index));
      const tok = m[0];
      if (tok[0] === '`') {
        out += `<code class="md-code">${esc(tok.slice(1, -1))}</code>`;
      } else if (tok.startsWith('**')) {
        out += `<strong>${esc(tok.slice(2, -2))}</strong>`;
      } else if (tok[0] === '*') {
        out += `<em>${esc(tok.slice(1, -1))}</em>`;
      } else if (tok[0] === '[') {
        const lm = tok.match(/^\[([^\]]+)\]\(([^)]+)\)$/);
        if (lm) out += `<a class="md-link" href="${esc(lm[2])}" target="_blank" rel="noopener">${esc(lm[1])}</a>`;
        else out += esc(tok);
      } else if (/^:bi-[a-z0-9-]+:$/i.test(tok)) {
        out += biIcon(tok.slice(4, -1));
      }
      last = re.lastIndex;
    }
    if (last < text.length) out += esc(text.slice(last));
    return out;
  }

  function highlightCode(code, lang) {
    let h = esc(code);
    if (lang === 'bash' || lang === 'sh' || lang === 'shell') {
      h = h.replace(/(^|\n)(#.*)/g, '$1<span class="hl-comment">$2</span>');
      h = h.replace(/\b(cd|cat|echo|man|ssh|sudo|docker|systemctl|grep|find|chmod|chown)\b/g, '<span class="hl-kw">$1</span>');
      h = h.replace(/(&#x27;[^&#x27;]*&#x27;|"[^"]*")/g, '<span class="hl-str">$1</span>');
    }
    return h;
  }

  function parseTableRow(line) {
    return line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map((c) => c.trim());
  }

  function isTableSep(line) {
    return /^\|?[\s:-]+\|[\s|:-]+\|?$/.test(line.trim());
  }

  function renderTable(lines) {
    if (lines.length < 2) return '';
    const header = parseTableRow(lines[0]);
    const bodyStart = isTableSep(lines[1]) ? 2 : 1;
    const rows = lines.slice(bodyStart).map(parseTableRow);
    const thead = `<thead><tr>${header.map((c) => `<th>${inline(c)}</th>`).join('')}</tr></thead>`;
    const tbody = `<tbody>${rows.map((r) => `<tr>${r.map((c) => `<td>${inline(c)}</td>`).join('')}</tr>`).join('')}</tbody>`;
    return `<div class="md-table-wrap"><table class="md-table">${thead}${tbody}</table></div>`;
  }

  function render(md) {
    if (!md || !md.trim()) {
      return '<article class="md"><p class="md-p md-muted">No content yet.</p></article>';
    }

    const lines = md.replace(/\r\n/g, '\n').split('\n');
    const html = [];
    let i = 0;

    while (i < lines.length) {
      const line = lines[i];
      const trimmed = line.trim();

      if (trimmed.startsWith('```')) {
        const lang = trimmed.slice(3).trim() || 'text';
        const buf = [];
        i += 1;
        while (i < lines.length && !lines[i].trim().startsWith('```')) {
          buf.push(lines[i]);
          i += 1;
        }
        i += 1;
        html.push(`<pre class="md-pre"><code class="md-pre-code language-${esc(lang)}">${highlightCode(buf.join('\n'), lang)}</code></pre>`);
        continue;
      }

      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        const tbl = [line];
        i += 1;
        while (i < lines.length && lines[i].trim().includes('|')) {
          tbl.push(lines[i]);
          i += 1;
        }
        html.push(renderTable(tbl));
        continue;
      }

      if (/^---+$/.test(trimmed) || /^\*\*\*+$/.test(trimmed)) {
        html.push('<hr class="md-hr">');
        i += 1;
        continue;
      }

      if (trimmed.startsWith('### ')) {
        html.push(`<h3 class="md-h3">${inline(trimmed.slice(4))}</h3>`);
        i += 1;
        continue;
      }
      if (trimmed.startsWith('## ')) {
        html.push(`<h2 class="md-h2">${inline(trimmed.slice(3))}</h2>`);
        i += 1;
        continue;
      }
      if (trimmed.startsWith('# ')) {
        html.push(`<h1 class="md-h1">${inline(trimmed.slice(2))}</h1>`);
        i += 1;
        continue;
      }

      if (trimmed.startsWith('> ')) {
        const quotes = [];
        while (i < lines.length && lines[i].trim().startsWith('> ')) {
          quotes.push(lines[i].trim().slice(2));
          i += 1;
        }
        html.push(`<blockquote class="md-quote">${quotes.map((q) => `<p>${inline(q)}</p>`).join('')}</blockquote>`);
        continue;
      }

      if (/^[-*] \[[ xX]\] /.test(trimmed)) {
        const items = [];
        while (i < lines.length && /^[-*] \[[ xX]\] /.test(lines[i].trim())) {
          const t = lines[i].trim();
          const done = /^[-*] \[[xX]\] /.test(t);
          items.push({ done, text: t.replace(/^[-*] \[[ xX]\] /, '') });
          i += 1;
        }
        html.push(`<ul class="md-task-list">${items.map((it) =>
          `<li class="md-task${it.done ? ' is-done' : ''}"><label><input type="checkbox" disabled${it.done ? ' checked' : ''}><span>${inline(it.text)}</span></label></li>`
        ).join('')}</ul>`);
        continue;
      }

      if (/^[-*] /.test(trimmed)) {
        const items = [];
        while (i < lines.length && /^[-*] /.test(lines[i].trim()) && !/^[-*] \[[ xX]\] /.test(lines[i].trim())) {
          items.push(lines[i].trim().slice(2));
          i += 1;
        }
        html.push(`<ul class="md-ul">${items.map((it) => `<li>${inline(it)}</li>`).join('')}</ul>`);
        continue;
      }

      if (/^\d+\.\s/.test(trimmed)) {
        const items = [];
        while (i < lines.length && /^\d+\.\s/.test(lines[i].trim())) {
          items.push(lines[i].trim().replace(/^\d+\.\s/, ''));
          i += 1;
        }
        html.push(`<ol class="md-ol">${items.map((it) => `<li>${inline(it)}</li>`).join('')}</ol>`);
        continue;
      }

      if (!trimmed) {
        i += 1;
        continue;
      }

      const para = [line];
      i += 1;
      while (i < lines.length && lines[i].trim() && !/^#{1,3} /.test(lines[i].trim()) && !lines[i].trim().startsWith('```') && !lines[i].trim().startsWith('|') && !lines[i].trim().startsWith('> ') && !/^[-*] /.test(lines[i].trim()) && !/^\d+\.\s/.test(lines[i].trim()) && !/^---+$/.test(lines[i].trim())) {
        para.push(lines[i]);
        i += 1;
      }
      html.push(`<p class="md-p">${inline(para.join(' '))}</p>`);
    }

    return `<article class="md">${html.join('\n')}</article>`;
  }

  global.LFCSMarkdown = { render, inline };
})(typeof window !== 'undefined' ? window : globalThis);