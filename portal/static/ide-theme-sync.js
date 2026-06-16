/**
 * Sync code-server (Workspace IDE) with AIOS dashboard theme.
 * Injected into /ide/ via portal nginx; reads localStorage + postMessage.
 */
(function () {
  'use strict';

  const STORAGE = 'lfcs-ui-theme';
  const STYLE_ID = 'aios-ide-theme';

  function getThemeId() {
    try {
      const v = localStorage.getItem(STORAGE);
      if (v && globalThis.AIOSIdeThemes?.PALETTES[v]) return v;
    } catch (_) { /* ignore */ }
    return globalThis.AIOSIdeThemes?.DEFAULT || 'kanagawa-wave';
  }

  function apply(themeId) {
    if (!globalThis.AIOSIdeThemes) return;
    let el = document.getElementById(STYLE_ID);
    if (!el) {
      el = document.createElement('style');
      el.id = STYLE_ID;
      document.head.appendChild(el);
    }
    el.textContent = AIOSIdeThemes.vscodeCss(themeId);
    document.documentElement.setAttribute('data-aios-theme', themeId);
  }

  function sync() {
    apply(getThemeId());
  }

  if (globalThis.AIOSIdeThemes) sync();

  window.addEventListener('storage', (e) => {
    if (e.key === STORAGE) sync();
  });

  window.addEventListener('message', (e) => {
    if (e.origin !== window.location.origin) return;
    if (e.data?.type === 'lfcs-theme-change' && e.data.theme) apply(e.data.theme);
  });

  const retry = setInterval(() => {
    if (!globalThis.AIOSIdeThemes) return;
    sync();
    clearInterval(retry);
  }, 200);

  const obs = new MutationObserver(() => {
    if (document.getElementById(STYLE_ID)) return;
    sync();
  });
  obs.observe(document.documentElement, { childList: true, subtree: true });
})();