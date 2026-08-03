/**
 * AIOS Education Dashboard — LFCS MVP (monitoring + Home / Lesson / Workspace + Ara)
 */
(function () {
  'use strict';

  const TABS = [
    { id: 'home', label: 'Home', icon: 'house' },
    { id: 'lesson', label: 'Lesson', icon: 'book' },
    { id: 'workspace', label: 'Workspace', icon: 'keyboard' },
  ];

  function ico(name, extraClass) {
    return globalThis.LFCSIcon ? LFCSIcon.bi(name, extraClass) : '';
  }

  function icoLabel(name, text, extraClass) {
    return globalThis.LFCSIcon ? LFCSIcon.biLabel(name, text, extraClass) : `<span>${text}</span>`;
  }

  const GUIDES = [
    { href: '/guides/GETTING_STARTED.md', label: 'Start' },
    { href: '/guides/DAILY_STUDY_PROTOCOL.md', label: 'Protocol' },
    { href: '/guides/PROJECT_ROADMAP.md', label: 'Roadmap' },
    { href: '/guides/OBJECTIVES_TRACKER.md', label: 'Objectives' },
    { href: '/guides/CLUSTER_MAP.md', label: 'Cluster' },
    { href: '/guides/TABLET_QUICKSTART.md', label: 'Tablet' },
  ];

  const ua = navigator.userAgent;
  const isTouch = matchMedia('(pointer: coarse)').matches || 'ontouchstart' in window;
  const isNarrow = matchMedia('(max-width: 767px)').matches;
  const isMobile = /Android|iPhone|iPad|iPod|Mobile/i.test(ua) || (isTouch && isNarrow);

  document.documentElement.classList.add(isMobile ? 'env-mobile' : 'env-desktop');

  const STORAGE_SIDEBAR = 'lfcs-sidebar-open';

  const app = document.getElementById('app');
  const loadScreen = document.getElementById('load-screen');
  let clockTimer = null;
  let dashboardData = null;
  let aiSidebarEl = null;
  let aiChatApi = null;

  function esc(s) {
    const d = document.createElement('div');
    d.textContent = s == null ? '' : String(s);
    return d.innerHTML;
  }

  function renderMarkdown(text) {
    if (globalThis.LFCSMarkdown) return LFCSMarkdown.render(text);
    return `<article class="md"><pre class="md-pre"><code>${esc(text || '')}</code></pre></article>`;
  }

  function progressBar(data) {
    const p = data.progress;
    return `
      <section class="sidebar-card progress-block">
        <div class="progress-head">
          <span>Learning progress</span>
          <span class="progress-pct">${p.percent}%</span>
        </div>
        <div class="progress-track" role="progressbar" aria-valuenow="${p.percent}" aria-valuemin="0" aria-valuemax="100">
          <div class="progress-fill" style="width:${p.percent}%"></div>
        </div>
        <p class="progress-meta">${p.completed_count} of ${p.total_days} sessions logged · Day ${data.program_day} active</p>
      </section>`;
  }

  function monitoringBlock(data) {
    const m = data.monitoring;
    const nodes = data.cluster.length ? data.cluster : [];
    const cards = nodes.map((n) => {
      const statusClass = n.reachable ? 'status-up' : 'status-down';
      const statusLabel = n.reachable ? 'Online' : 'Offline';
      return `<article class="node-card"><span class="status ${statusClass}" title="${statusLabel}" aria-label="${statusLabel}">${ico('circle-fill')}</span><span class="name">${esc(n.name)}</span><code class="node-ip">${esc(n.tailscale_ip)}</code></article>`;
    }).join('');

    return `
      <section class="sidebar-card monitor-block">
        <h2>Monitoring</h2>
        <div class="stat-grid">
          <div class="stat-pill"><span class="stat-label">Tailscale</span><span class="stat-val">${m.tailscale.peers_online}/${m.tailscale.peers_total} peers</span></div>
          <div class="stat-pill"><span class="stat-label">Cluster</span><span class="stat-val">${m.cluster.nodes_up}/${m.cluster.nodes_total} up</span></div>
          <div class="stat-pill stat-pill-host"><span class="stat-label">This host</span><code class="stat-val">${esc(m.tailscale.self_ip)}</code></div>
          ${m.ara ? `<div class="stat-pill"><span class="stat-label">Ara RAG</span><span class="stat-val">${esc(m.ara.rag_status || '—')}${m.ara.last_rag_eval_pass_rate != null ? ' · ' + Math.round(m.ara.last_rag_eval_pass_rate * 100) + '%' : ''}</span></div>` : ''}
        </div>
        <div class="cluster-cards">${cards || '<p class="muted">Run cluster scan</p>'}</div>
      </section>`;
  }

  function renderThemePicker() {
    const api = window.LFCSTheme;
    if (!api) return '';
    const current = api.getStored();
    const opts = api.THEMES.map((t) =>
      `<option value="${esc(t.id)}"${t.id === current ? ' selected' : ''}>${esc(t.label)}</option>`
    ).join('');
    return `<label class="theme-picker" for="ui-theme-select">
      <span class="theme-picker-label">Theme</span>
      <select id="ui-theme-select" class="theme-select" aria-label="Dashboard color theme">${opts}</select>
    </label>`;
  }

  function renderSidebar(data) {
    const s = data.schedule;
    return `
      <aside class="sidebar" id="sidebar" aria-label="Monitoring sidebar">
        <header class="sidebar-hero">
          <div class="sidebar-hero-top">
            <span class="badge">Day ${data.program_day} / ${data.program_total}</span>
            <button type="button" class="sidebar-collapse" id="sidebar-collapse" aria-label="Collapse sidebar">${ico('chevron-left')}</button>
          </div>
          <h1>AIOS Education</h1>
          <p class="product-line">LFCS exam prep · Linux System Administration</p>
          <p class="datetime" id="live-datetime">${esc(data.datetime.date)} · <span id="live-time">${esc(data.datetime.time)}</span></p>
          <p class="meta">Project ${esc(s.project)} · Phase ${esc(s.phase)} · <strong>${esc(s.node)}</strong></p>
        </header>

        <div class="sidebar-cards">
          ${progressBar(data)}
          ${monitoringBlock(data)}
        </div>

        <section class="sidebar-card tips-card tips">
          <h2>Tips</h2>
          <details>
            <summary class="tip-summary">${icoLabel('tablet', 'Tablet')}</summary>
            <div class="tip-body">Toggle the sidebar with ${ico('list', 'tip-inline-icon')} — collapses on any screen size. Use <strong>Workspace</strong> for VS Code.</div>
          </details>
          <details>
            <summary class="tip-summary">${icoLabel('bar-chart', 'Progress')}</summary>
            <div class="tip-body">Log each session: <code>echo 'DATE Project NN phase DONE' >> notifications/study-journal.log</code> then rebuild portal.</div>
          </details>
          <details>
            <summary class="tip-summary">${icoLabel('display', 'Desktop')}</summary>
            <div class="tip-body"><strong>Home</strong> has today's welcome &amp; resources. <strong>Lesson</strong> navigates all 45 days.</div>
          </details>
        </section>

        <footer class="sidebar-footer">
          ${renderThemePicker()}
          <a class="btn btn-primary btn-sm" href="${esc(data.urls.browser)}" data-browser-link target="_blank" rel="noopener">${icoLabel('shield-lock', 'Lab Browser')}</a>
          <p class="muted">Tailnet · <a href="${esc(data.urls.portal)}">${esc(data.urls.portal)}</a></p>
        </footer>
      </aside>`;
  }

  function resourceSection(resources) {
    const kinds = [
      { key: 'youtube', label: 'YouTube', icon: 'youtube' },
      { key: 'docs', label: 'Official docs', icon: 'journal-text' },
      { key: 'articles', label: 'Industry articles', icon: 'newspaper' },
    ];
    return kinds.map((k) => {
      const items = (resources[k.key] || []);
      if (!items.length) return '';
      const list = items.map((r) =>
        `<a class="resource-link" href="${esc(r.url)}" target="_blank" rel="noopener"><span class="resource-title">${esc(r.title)}</span><span class="resource-src">${esc(r.source || '')}</span></a>`
      ).join('');
      return `<section class="resource-group"><h3>${ico(k.icon)}<span>${k.label}</span></h3><div class="resource-list">${list}</div></section>`;
    }).join('');
  }

  function renderHome(data) {
    const s = data.schedule;
    return `
      <div class="home-layout">
        <div class="home-top-row">
          <section class="panel-card welcome-card">
            <h2>Welcome — Day ${data.program_day}</h2>
            <div class="welcome-body">${renderMarkdown(data.guidance)}</div>
          </section>

          <section class="panel-card overview-card">
            <h2>Today's overview</h2>
            <p class="lead"><strong>${esc(s.title)}</strong></p>
            <ul class="overview-list">
              <li><span>Target node</span><strong>${esc(s.node)}</strong></li>
              <li><span>Duration</span><strong>~${s.duration_min} min</strong></li>
              <li><span>Domains</span><strong>${esc((s.domains || []).join(', '))}</strong></li>
              <li><span>Study guide</span><a href="${esc(s.study_guide_url)}">${esc(s.study_guide)}</a></li>
            </ul>
            <div class="home-actions">
              <button type="button" class="btn btn-primary btn-sm" id="home-open-ara">${icoLabel('chat-dots', 'Ask Ara')}</button>
              <button type="button" class="btn btn-secondary btn-sm" data-goto="lesson">${icoLabel('book', 'Full lesson steps')}</button>
              <button type="button" class="btn btn-secondary btn-sm" data-goto="workspace">${icoLabel('keyboard', 'Open workspace')}</button>
            </div>
          </section>
        </div>

        <section class="panel-card resources-card">
          <details class="resources-collapse">
            <summary>Learn more — Project ${esc(s.project)} resources</summary>
            <div class="resources-body">
              <p class="muted">Curated videos, official docs, and articles. Edit <code>schedule/lesson-resources.json</code> to add more.</p>
              ${resourceSection(data.resources)}
            </div>
          </details>
        </section>
      </div>`;
  }

  function lessonNavItem(d, selectedDay) {
    const cls = ['lesson-nav-item'];
    if (d.day === selectedDay) cls.push('is-selected');
    if (d.is_today) cls.push('is-today');
    if (d.completed) cls.push('is-done');
    if (d.is_future) cls.push('is-future');
    let mark;
    if (d.completed) mark = ico('check-circle-fill', 'lesson-nav-icon');
    else if (d.is_today) mark = ico('circle-fill', 'lesson-nav-icon lesson-nav-today');
    else mark = `<span class="lesson-nav-num">${d.day}</span>`;
    return `<button type="button" class="${cls.join(' ')}" data-lesson-day="${d.day}" title="${esc(d.title)}">
      <span class="lesson-nav-day">${mark}</span>
      <span class="lesson-nav-title">D${d.day} · P${esc(d.project)}</span>
    </button>`;
  }

  function renderLesson(data, selectedDay) {
    const dayInfo = data.days.find((d) => d.day === selectedDay) || data.days[data.program_day - 1];
    const isToday = selectedDay === data.program_day;
    const guidesBar = GUIDES.map((g) =>
      `<a class="guide-tab" href="${g.href}" target="_blank" rel="noopener">${g.label}</a>`
    ).join('');

    const body = isToday
      ? `<div class="guidance-wrap">${renderMarkdown(data.guidance)}</div>`
      : `<div class="lesson-placeholder">
          <p>${dayInfo.is_future ? 'This lesson is scheduled for a future day.' : 'Past lesson — open the study guide for full project content.'}</p>
          <ul class="overview-list">
            <li><span>Project</span><strong>${esc(dayInfo.project)}</strong></li>
            <li><span>Phase</span><strong>${esc(dayInfo.phase)}</strong></li>
            <li><span>Node</span><strong>${esc(dayInfo.node)}</strong></li>
            <li><span>Duration</span><strong>~${dayInfo.duration_min} min</strong></li>
          </ul>
          <a class="btn btn-secondary btn-sm" href="${esc(dayInfo.study_guide_url)}" target="_blank" rel="noopener">Open study guide</a>
        </div>`;

    return `
      <div class="lesson-layout">
        <nav class="guide-menu" aria-label="Study guides">${guidesBar}</nav>
        <div class="lesson-body">
          <aside class="lesson-nav" aria-label="Lesson calendar">
            <h3>All lessons</h3>
            <div class="lesson-nav-scroll">${data.days.map((d) => lessonNavItem(d, selectedDay)).join('')}</div>
          </aside>
          <section class="panel-card lesson-content">
            <header class="lesson-header">
              <h2>Day ${dayInfo.day}: ${esc(dayInfo.title)}</h2>
              <p class="muted">Project ${esc(dayInfo.project)} · Phase ${esc(dayInfo.phase)} · ${esc(dayInfo.node)}${dayInfo.completed ? ' · <span class="done-badge">Completed</span>' : ''}</p>
            </header>
            ${body}
          </section>
        </div>
      </div>`;
  }

  function renderWorkspace(data) {
    const w = data.workspace;
    const hasCreds = Boolean(w && w.username);
    return `
      <section class="panel-card workspace-panel">
        <div class="workspace-creds" id="workspace-creds">
          <h2>Workspace login</h2>
          <p class="muted">Browser VS Code on um690 — LFCS project files mounted at <code>/home/coder/LFCS</code></p>
          ${hasCreds ? `
            <dl class="creds-dl">
              <dt>URL</dt><dd><code>${esc(data.urls.portal)}ide/</code></dd>
              <dt>Username</dt><dd><code id="ws-user">${esc(w.username)}</code> <button type="button" class="copy-btn" data-copy="ws-user">Copy</button></dd>
              <dt>Password</dt><dd class="muted">${esc(w.hint || 'See tablet-credentials.txt on um690 via Termius')}</dd>
            </dl>
            <button type="button" class="btn btn-primary" id="launch-ide">Launch IDE</button>
          ` : `<p class="muted">Credentials not found. Run <code>sudo ./automation/lfcs-backend-deploy.sh</code> or check <code>notifications/tablet-credentials.txt</code>.</p>`}
        </div>
        <iframe class="ide-frame hidden" id="ide-frame" title="LFCS Workspace IDE" src="about:blank" allow="clipboard-read; clipboard-write"></iframe>
      </section>`;
  }

  function renderMain(data, activeTab, lessonDay) {
    const tabBar = TABS.map((t) =>
      `<button type="button" class="tab-btn${t.id === activeTab ? ' is-active' : ''}" data-tab="${t.id}" aria-selected="${t.id === activeTab}">${icoLabel(t.icon, t.label)}</button>`
    ).join('');

    let panel = '';
    if (activeTab === 'home') panel = renderHome(data);
    else if (activeTab === 'lesson') panel = renderLesson(data, lessonDay);
    else panel = renderWorkspace(data);

    return `
      <main class="main" id="main">
        <header class="main-header">
          <button type="button" class="sidebar-toggle" id="sidebar-toggle" aria-label="Toggle sidebar" aria-expanded="false" title="Toggle sidebar">${ico('list')}</button>
          <nav class="tab-bar" role="tablist" aria-label="Dashboard views">${tabBar}</nav>
          <button type="button" class="ai-toggle${globalThis.LFCSAiChat && LFCSAiChat.isOpen() ? ' is-active' : ''}" id="ai-toggle" aria-label="Open Ara" aria-expanded="${globalThis.LFCSAiChat && LFCSAiChat.isOpen() ? 'true' : 'false'}">Ara</button>
        </header>
        <div class="panel ${activeTab === 'home' ? 'panel-scroll' : ''}" role="tabpanel">${panel}</div>
      </main>`;
  }

  function startClock(tz) {
    if (clockTimer) clearInterval(clockTimer);
    const el = document.getElementById('live-time');
    if (!el) return;
    clockTimer = setInterval(() => {
      try {
        el.textContent = new Date().toLocaleTimeString('en-US', {
          hour: 'numeric', minute: '2-digit', hour12: true, timeZone: tz,
        });
      } catch (_) { /* ignore */ }
    }, 30000);
  }

  function mountAiSidebar(data) {
    if (!globalThis.LFCSAiChat) return;
    if (aiSidebarEl && aiSidebarEl.parentNode) {
      aiSidebarEl.parentNode.removeChild(aiSidebarEl);
    }
    const wasOpen = aiSidebarEl && aiSidebarEl.classList.contains('is-open');
    aiSidebarEl = LFCSAiChat.createSidebar(data);
    if (wasOpen) aiSidebarEl.classList.add('is-open');
    aiChatApi = LFCSAiChat.bind(aiSidebarEl, data, app);
    app.appendChild(aiSidebarEl);
    app.classList.toggle('ai-open', aiSidebarEl.classList.contains('is-open'));
  }

  function defaultSidebarOpen() {
    return !isMobile;
  }

  function isSidebarOpen() {
    try {
      const stored = localStorage.getItem(STORAGE_SIDEBAR);
      if (stored !== null) return stored === '1';
    } catch (_) { /* ignore */ }
    return defaultSidebarOpen();
  }

  function setSidebarOpen(open) {
    try { localStorage.setItem(STORAGE_SIDEBAR, open ? '1' : '0'); } catch (_) { /* ignore */ }
  }

  function applySidebarState(open) {
    app.classList.toggle('sidebar-open', open);
    const sidebar = document.getElementById('sidebar');
    const toggle = document.getElementById('sidebar-toggle');
    const backdrop = document.getElementById('sidebar-backdrop');
    if (sidebar) sidebar.classList.toggle('is-open', open);
    if (backdrop) backdrop.classList.toggle('is-visible', open && isMobile);
    if (toggle) toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  }

  function render(data, activeTab, lessonDay) {
    dashboardData = data;
    lessonDay = lessonDay || data.program_day;
    document.title = `AIOS Education — LFCS Day ${data.program_day}`;
    app.innerHTML = renderSidebar(data) + renderMain(data, activeTab, lessonDay);
    mountAiSidebar(data);
    applySidebarState(isSidebarOpen());
    app.removeAttribute('data-loading');
    startClock(data.datetime.timezone);
    bindEvents(data, activeTab, lessonDay);
  }

  function bindEvents(data, activeTab, lessonDay) {
    const sidebar = document.getElementById('sidebar');
    const toggle = document.getElementById('sidebar-toggle');
    const backdrop = document.createElement('div');
    backdrop.className = 'sidebar-backdrop';
    backdrop.id = 'sidebar-backdrop';
    app.appendChild(backdrop);

    function closeSidebar() {
      setSidebarOpen(false);
      applySidebarState(false);
    }

    function openSidebar() {
      setSidebarOpen(true);
      applySidebarState(true);
    }

    function toggleSidebar() {
      if (app.classList.contains('sidebar-open')) closeSidebar();
      else openSidebar();
    }

    toggle.addEventListener('click', toggleSidebar);
    backdrop.addEventListener('click', closeSidebar);

    const sidebarCollapse = document.getElementById('sidebar-collapse');
    if (sidebarCollapse) sidebarCollapse.addEventListener('click', closeSidebar);

    document.querySelectorAll('.tab-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        const tab = btn.getAttribute('data-tab');
        try { localStorage.setItem('lfcs-active-tab', tab); } catch (_) { /* ignore */ }
        render(data, tab, getSavedLessonDay(data));
        if (isMobile) closeSidebar();
      });
    });

    document.querySelectorAll('[data-goto]').forEach((el) => {
      el.addEventListener('click', () => {
        const tab = el.getAttribute('data-goto');
        try { localStorage.setItem('lfcs-active-tab', tab); } catch (_) { /* ignore */ }
        render(data, tab, getSavedLessonDay(data));
      });
    });

    document.querySelectorAll('[data-lesson-day]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const day = parseInt(btn.getAttribute('data-lesson-day'), 10);
        try { localStorage.setItem('lfcs-lesson-day', String(day)); } catch (_) { /* ignore */ }
        render(data, 'lesson', day);
      });
    });

    document.querySelectorAll('[data-browser-link]').forEach((el) => {
      el.addEventListener('click', () => {
        try { localStorage.setItem('lfcs-last-device', isMobile ? 'mobile' : 'desktop'); } catch (_) { /* ignore */ }
      });
    });

    document.querySelectorAll('.copy-btn').forEach((btn) => {
      btn.addEventListener('click', async () => {
        const id = btn.getAttribute('data-copy');
        const node = id && document.getElementById(id);
        const text = node ? node.textContent : '';
        if (!text) return;
        try {
          await navigator.clipboard.writeText(text);
          btn.textContent = 'Copied!';
          setTimeout(() => { btn.textContent = 'Copy'; }, 1500);
        } catch (_) { /* ignore */ }
      });
    });

    const launch = document.getElementById('launch-ide');
    const frame = document.getElementById('ide-frame');
    const creds = document.getElementById('workspace-creds');
    if (launch && frame) {
      const syncIdeTheme = () => {
        if (window.LFCSTheme && frame.contentWindow) {
          window.LFCSTheme.syncIde(window.LFCSTheme.getStored());
        }
      };
      frame.addEventListener('load', syncIdeTheme);
      launch.addEventListener('click', () => {
        frame.src = data.urls.ide;
        frame.classList.remove('hidden');
        if (creds) creds.classList.add('compact');
        launch.textContent = 'Reload IDE';
      });
    }

    function openAra() {
      if (!aiChatApi || !aiSidebarEl) return;
      const aiToggle = document.getElementById('ai-toggle');
      aiChatApi.toggleOpen(true);
      if (aiToggle) {
        aiToggle.classList.add('is-active');
        aiToggle.setAttribute('aria-expanded', 'true');
      }
      if (isMobile) closeSidebar();
    }

    const aiToggle = document.getElementById('ai-toggle');
    if (aiToggle && aiChatApi) {
      aiToggle.addEventListener('click', () => {
        const open = !aiSidebarEl.classList.contains('is-open');
        aiChatApi.toggleOpen(open);
        aiToggle.classList.toggle('is-active', open);
        aiToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        if (isMobile && open) closeSidebar();
      });
    }

    const homeAra = document.getElementById('home-open-ara');
    if (homeAra) homeAra.addEventListener('click', openAra);

    const themeSelect = document.getElementById('ui-theme-select');
    if (themeSelect && window.LFCSTheme) {
      themeSelect.addEventListener('change', () => {
        window.LFCSTheme.apply(themeSelect.value);
      });
    }

    applySidebarState(isSidebarOpen());
  }

  function getSavedTab() {
    try {
      const t = localStorage.getItem('lfcs-active-tab');
      if (TABS.some((x) => x.id === t)) return t;
    } catch (_) { /* ignore */ }
    return 'home';
  }

  function getSavedLessonDay(data) {
    try {
      const d = parseInt(localStorage.getItem('lfcs-lesson-day'), 10);
      if (d >= 1 && d <= data.program_total) return d;
    } catch (_) { /* ignore */ }
    return data.program_day;
  }

  fetch('/data/daily.json', { cache: 'no-store' })
    .then((r) => {
      if (!r.ok) throw new Error(`HTTP ${r.status}`);
      return r.json();
    })
    .then((data) => {
      if (loadScreen) loadScreen.remove();
      render(data, getSavedTab(), getSavedLessonDay(data));
    })
    .catch((err) => {
      if (loadScreen) {
        loadScreen.innerHTML = `<p>Could not load dashboard data.</p><p class="muted">${esc(err.message)}</p><p class="muted">Run: <code>./automation/lfcs-portal-build.sh</code></p>`;
      }
    });
})();