// Sonic Chaos Arena service worker: keeps a copy of everything the game has loaded, so it starts fast and works offline.
// Bump VERSION whenever you upload a new build, so players get the update.
const VERSION = 'sca-demo-1';
self.addEventListener('install', (e) => { self.skipWaiting(); e.waitUntil(caches.open(VERSION).then((c) => c.addAll(['./', './index.html', './sonic-chaos-arena.html', './manifest.webmanifest', './icon-192.png', './icon-512.png']).catch(() => {}))); });
self.addEventListener('activate', (e) => { e.waitUntil(caches.keys().then((ks) => Promise.all(ks.filter((k) => k !== VERSION).map((k) => caches.delete(k)))).then(() => self.clients.claim())); });
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET' || new URL(req.url).origin !== location.origin) return; // fonts etc. go straight to the network
  const isPage = req.mode === 'navigate' || /\.html$/.test(new URL(req.url).pathname);
  // pages: network first (so updates show up), falling back to the saved copy; everything else: saved copy first
  e.respondWith(isPage
    ? fetch(req).then((r) => { const c = r.clone(); caches.open(VERSION).then((ca) => ca.put(req, c)); return r; }).catch(() => caches.match(req))
    : caches.match(req).then((hit) => hit || fetch(req).then((r) => { if (r.ok) { const c = r.clone(); caches.open(VERSION).then((ca) => ca.put(req, c)); } return r; })));
});
