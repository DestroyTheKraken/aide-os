/**
 * Ara sidebar — AIOS Education IDE (local tutor via Open WebUI + Ollama)
 */
(function (global) {
  'use strict';

  const STORAGE_OPEN = 'lfcs-ara-open';
  const STORAGE_CODE_MODE = 'lfcs-ara-code-mode';

  function esc(s) {
    const d = document.createElement('div');
    d.textContent = s == null ? '' : String(s);
    return d.innerHTML;
  }

  function araConfig(data) {
    return (data.ara) || {
      name: 'Ara',
      tagline: 'AIOS Education IDE',
      subtitle: 'Your personal Linux study assistant',
      model: 'Ara',
      coder_model: 'qwen2.5-coder:7b',
      mvp: 'LFCS exam prep',
      knowledge_base: 'ara_tutor',
    };
  }

  function isCodeMode() {
    try { return localStorage.getItem(STORAGE_CODE_MODE) === '1'; } catch (_) { return false; }
  }

  function setCodeMode(on) {
    try { localStorage.setItem(STORAGE_CODE_MODE, on ? '1' : '0'); } catch (_) { /* ignore */ }
  }

  function araUrl(data, opts) {
    opts = opts || {};
    const base = (data.urls && (data.urls.ara || data.urls.openwebui)) || '/ai/';
    const ara = araConfig(data);
    const useCode = opts.codeMode != null ? opts.codeMode : isCodeMode();
    const model = useCode ? ara.coder_model : ara.model;
    const params = new URLSearchParams();
    params.set('models', model);
    if (data.ara && data.ara.session_preamble && opts.seedPrompt !== false) {
      params.set('prompt', data.ara.session_preamble.slice(0, 500));
    }
    const sep = base.includes('?') ? '&' : '?';
    return base + sep + params.toString();
  }

  function ragBadgeHtml(data) {
    const ara = data.ara || {};
    const status = ara.rag_status || 'unknown';
    const cls = status === 'ok' ? 'rag-ok' : status === 'fail' ? 'rag-fail' : 'rag-unknown';
    const synced = ara.rag_synced_at ? ` · ${esc(ara.rag_synced_at)}` : '';
    return `<span class="ara-rag-badge ${cls}" title="Knowledge index status">RAG: ${esc(status)}${synced}</span>`;
  }

  function isOpen() {
    try { return localStorage.getItem(STORAGE_OPEN) === '1'; } catch (_) { return false; }
  }

  function setOpen(open) {
    try { localStorage.setItem(STORAGE_OPEN, open ? '1' : '0'); } catch (_) { /* ignore */ }
  }

  function ico(name, extraClass) {
    return global.LFCSIcon ? LFCSIcon.bi(name, extraClass) : '';
  }

  function icoLabel(name, text, extraClass) {
    return global.LFCSIcon ? LFCSIcon.biLabel(name, text, extraClass) : `<span>${text}</span>`;
  }

  function setCodeToggleLabel(btn, codeOn) {
    if (!btn) return;
    btn.innerHTML = codeOn ? icoLabel('code-slash', 'Code') : icoLabel('chat-dots', 'Tutor');
  }

  function createSidebar(data) {
    const ara = araConfig(data);
    const url = araUrl(data);
    const frameId = 'ai-frame-ara';
    const codeOn = isCodeMode();

    const el = document.createElement('aside');
    el.id = 'ai-sidebar';
    el.className = `ai-sidebar${isOpen() ? ' is-open' : ''}`;
    el.setAttribute('aria-label', 'Ara study assistant');
    el.innerHTML = `
      <header class="ai-header">
        <div class="ai-header-brand">
          <h2>${esc(ara.name)}</h2>
          <p class="ai-header-tagline">${esc(ara.tagline)}</p>
        </div>
        <button type="button" class="ai-close" id="ai-close" aria-label="Close Ara">${ico('x-lg')}</button>
      </header>
      <div class="ai-intro">
        <p>${esc(ara.subtitle || '')}</p>
        <p class="ai-intro-meta">MVP: <strong>${esc(ara.mvp)}</strong> · Models: <code>${esc(ara.model)}</code>, <code>${esc(ara.coder_model)}</code></p>
        ${ara.session_preamble ? `<p class="ai-session-hint muted">${esc(ara.session_preamble)}</p>` : ''}
      </div>
      <div class="ai-panels">
        <section class="ai-panel is-active" data-ai-panel="ara" role="region" aria-label="Ara chat">
          <div class="ai-toolbar">
            ${ragBadgeHtml(data)}
            <button type="button" class="btn btn-secondary btn-sm ai-code-toggle${codeOn ? ' is-active' : ''}" id="ai-code-toggle" title="Switch to coder model">
              ${codeOn ? icoLabel('code-slash', 'Code') : icoLabel('chat-dots', 'Tutor')}
            </button>
            <a class="btn btn-secondary btn-sm" href="${esc(url)}" target="_blank" rel="noopener">${icoLabel('box-arrow-up-right', 'Full screen')}</a>
          </div>
          <p class="ai-toolbar-note muted">KB: <code>${esc(ara.knowledge_base)}</code></p>
          <iframe
            id="${frameId}"
            class="ai-frame"
            title="Ara chat"
            data-src="${esc(url)}"
            src="about:blank"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
            allow="clipboard-read; clipboard-write; microphone"
          ></iframe>
          <p class="ai-frame-fallback hidden" id="${frameId}-err">Ara chat failed to load. <a href="${esc(url)}" target="_blank" rel="noopener">Open directly</a></p>
        </section>
      </div>
    `;

    return el;
  }

  function watchFrame(frame) {
    if (!frame) return;
    const errEl = document.getElementById(`${frame.id}-err`);
    const timer = setTimeout(() => {
      try {
        const doc = frame.contentDocument;
        if (doc && doc.body && doc.body.childElementCount === 0 && errEl) {
          errEl.classList.remove('hidden');
        }
      } catch (_) { /* cross-origin */ }
    }, 12000);
    frame.addEventListener('load', () => clearTimeout(timer));
    frame.addEventListener('error', () => {
      clearTimeout(timer);
      if (errEl) errEl.classList.remove('hidden');
    });
  }

  function loadFrame(frame, data) {
    if (!frame) return;
    const src = araUrl(data);
    frame.setAttribute('data-src', src);
    frame.src = src;
    frame.setAttribute('data-loaded', '1');
    watchFrame(frame);
  }

  function bind(sidebar, data, dashboardEl) {
    const closeBtn = sidebar.querySelector('#ai-close');
    const codeToggle = sidebar.querySelector('#ai-code-toggle');
    const toggleOpen = (open) => {
      sidebar.classList.toggle('is-open', open);
      dashboardEl.classList.toggle('ai-open', open);
      setOpen(open);
      if (open) loadFrame(sidebar.querySelector('.ai-frame'), data);
    };

    closeBtn.addEventListener('click', () => toggleOpen(false));

    if (codeToggle) {
      codeToggle.addEventListener('click', () => {
        const next = !isCodeMode();
        setCodeMode(next);
        codeToggle.classList.toggle('is-active', next);
        setCodeToggleLabel(codeToggle, next);
        const frame = sidebar.querySelector('.ai-frame');
        if (frame) loadFrame(frame, data);
      });
    }

    if (sidebar.classList.contains('is-open')) {
      dashboardEl.classList.add('ai-open');
      loadFrame(sidebar.querySelector('.ai-frame'), data);
    }

    return { toggleOpen };
  }

  global.LFCSAiChat = {
    createSidebar,
    bind,
    isOpen,
    araUrl,
    STORAGE_OPEN,
    STORAGE_CODE_MODE,
  };
})(typeof window !== 'undefined' ? window : globalThis);