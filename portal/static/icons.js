/**
 * Bootstrap Icons helper for AIOS dashboard markup.
 */
(function (global) {
  'use strict';

  function bi(name, extraClass) {
    const extra = extraClass ? ` ${extraClass}` : '';
    return `<i class="bi bi-${name}${extra}" aria-hidden="true"></i>`;
  }

  function biLabel(name, text, extraClass) {
    return `${bi(name, extraClass)}<span>${text}</span>`;
  }

  global.LFCSIcon = { bi, biLabel };
})(typeof window !== 'undefined' ? window : globalThis);