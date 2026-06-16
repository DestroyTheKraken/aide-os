/* AIOS Education PWA — cache shell assets only */
const CACHE_VERSION = 'aios-v5';
const CACHE_SHELL = [
  '/',
  '/static/vendor/bootstrap-icons/bootstrap-icons.css',
  '/static/vendor/bootstrap-icons/fonts/bootstrap-icons.woff2',
  '/static/icons.js',
  '/static/themes.css',
  '/static/theme.js',
  '/static/lesson-md.css',
  '/static/ide-themes.js',
  '/static/ide-theme-sync.js',
  '/static/app.css',
  '/static/app.js',
  '/static/ai-chat.js',
  '/static/markdown.js',
  '/static/manifest.webmanifest',
  '/static/icons/icon.svg',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then((cache) => cache.addAll(CACHE_SHELL)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  if (url.pathname.startsWith('/data/') || url.pathname.startsWith('/ide/') || url.pathname.startsWith('/ai/')) {
    return;
  }
  if (event.request.method !== 'GET') return;
  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request))
  );
});