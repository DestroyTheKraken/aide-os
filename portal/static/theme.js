/**
 * AIOS theme loader — applies user-selected palette before paint.
 */
(function (global) {
  'use strict';

  const STORAGE = 'lfcs-ui-theme';
  const DEFAULT = 'kanagawa-wave';

  const THEMES = [
    { id: 'kanagawa-wave', label: 'Kanagawa Wave', file: 'kanagawa-wave.toml', vscode: 'AIOS Kanagawa Wave' },
    { id: 'rose-pine', label: 'Rosé Pine', file: 'rose-pine-default.toml', vscode: 'AIOS Rosé Pine' },
    { id: 'gotham', label: 'Gotham', file: 'gotham-default.toml', vscode: 'AIOS Gotham' },
    { id: 'panda', label: 'Panda', file: 'panda-default.toml', vscode: 'AIOS Panda' },
    { id: 'posterpole', label: 'Posterpole', file: 'posterpole-default.toml', vscode: 'AIOS Posterpole' },
  ];

  function getStored() {
    try {
      const v = localStorage.getItem(STORAGE);
      if (v && THEMES.some((t) => t.id === v)) return v;
    } catch (_) { /* ignore */ }
    return DEFAULT;
  }

  function vscodeLabel(themeId) {
    return THEMES.find((t) => t.id === themeId)?.vscode || THEMES[0].vscode;
  }

  function syncIde(themeId) {
    try { localStorage.setItem('lfcs-vscode-theme', vscodeLabel(themeId)); } catch (_) { /* ignore */ }
    const frame = document.getElementById('ide-frame');
    if (!frame?.contentWindow || !frame.src || frame.src === 'about:blank') return;
    frame.contentWindow.postMessage({ type: 'lfcs-theme-change', theme: themeId }, location.origin);
  }

  function apply(themeId) {
    const id = THEMES.some((t) => t.id === themeId) ? themeId : DEFAULT;
    document.documentElement.setAttribute('data-theme', id);
    document.querySelector('meta[name="theme-color"]')?.setAttribute(
      'content',
      getComputedStyle(document.documentElement).getPropertyValue('--bg').trim() || '#1f1f28'
    );
    try { localStorage.setItem(STORAGE, id); } catch (_) { /* ignore */ }
    syncIde(id);
    document.dispatchEvent(new CustomEvent('lfcs-theme-change', { detail: { theme: id } }));
    return id;
  }

  apply(getStored());

  global.LFCSTheme = { THEMES, apply, getStored, syncIde, vscodeLabel, DEFAULT };
})(typeof window !== 'undefined' ? window : globalThis);