const STONE_COLORS = {
  1: 'var(--stone-1)',
  2: 'var(--stone-2)',
  3: 'var(--stone-3)',
  4: 'var(--stone-4)',
  5: 'var(--stone-5)',
  6: 'var(--stone-6)',
};

const timelineEl = document.getElementById('timeline');
const gauntletEl = document.getElementById('gauntlet');
const phaseSummaryEl = document.getElementById('phase-summary');
const emptyStateEl = document.getElementById('empty-state');
const searchInput = document.getElementById('search-input');
const filterButtons = document.querySelectorAll('.filter-button');
const statWatchedEl = document.getElementById('stat-watched');
const statRemainingEl = document.getElementById('stat-remaining');
const statProgressEl = document.getElementById('stat-progress');
const countAllEl = document.getElementById('count-all');
const countWatchingEl = document.getElementById('count-watching');
const countRemainingEl = document.getElementById('count-remaining');
const countWatchedEl = document.getElementById('count-watched');

let allItems = [];
let activeFilter = 'all';

function isWatched(item) {
  return item.watched === 2;
}

function isWatching(item) {
  return item.watched === 1;
}

function statusLabel(status) {
  return status === 2 ? 'Watched' : status === 1 ? 'Currently watching' : 'Not started';
}

async function loadItems() {
  const res = await fetch('/api/items');
  if (!res.ok) throw new Error('Failed to load items');
  return res.json();
}

function renderGauntlet(items) {
  const byPhase = {};
  for (const item of items) {
    (byPhase[item.phase] ??= []).push(item);
  }

  gauntletEl.innerHTML = '';
  for (let phase = 1; phase <= 6; phase++) {
    const group = byPhase[phase] || [];
    const total = group.length;
    const watched = group.filter(isWatched).length;
    const pct = total ? Math.round((watched / total) * 100) : 0;

    const stone = document.createElement('div');
    stone.className = 'stone' + (pct === 100 && total > 0 ? ' full' : '');
    stone.style.setProperty('--stone-color', STONE_COLORS[phase]);
    stone.style.setProperty('--fill', `${pct}%`);
    stone.title = `Phase ${phase}: ${watched}/${total} watched`;
    stone.innerHTML = `<span class="stone-pct">${pct}%</span>`;
    gauntletEl.appendChild(stone);
  }

}

function renderOverview(items) {
  const watched = items.filter(isWatched).length;
  const watching = items.filter(isWatching).length;
  const remaining = items.length - watched;
  const percent = items.length ? Math.round((watched / items.length) * 100) : 0;

  statWatchedEl.textContent = watched;
  statRemainingEl.textContent = remaining;
  statProgressEl.textContent = `${percent}%`;
  countAllEl.textContent = items.length;
  countWatchingEl.textContent = watching;
  countRemainingEl.textContent = remaining;
  countWatchedEl.textContent = watched;

  const byPhase = {};
  for (const item of items) (byPhase[item.phase] ??= []).push(item);
  phaseSummaryEl.innerHTML = '';
  for (let phase = 1; phase <= 6; phase++) {
    const group = byPhase[phase] || [];
    const phaseWatched = group.filter(isWatched).length;
    const phasePercent = group.length ? Math.round((phaseWatched / group.length) * 100) : 0;
    const phaseEl = document.createElement('div');
    phaseEl.className = 'phase-row';
    phaseEl.style.setProperty('--stone-color', STONE_COLORS[phase]);
    phaseEl.innerHTML = `<span>Phase ${phase}</span><strong>${phaseWatched}/${group.length}</strong><i><b style="width: ${phasePercent}%"></b></i>`;
    phaseSummaryEl.appendChild(phaseEl);
  }
}

function renderTimeline(items) {
  timelineEl.innerHTML = '';
  emptyStateEl.hidden = items.length > 0;
  for (const item of items) {
    const color = STONE_COLORS[item.phase];

    const li = document.createElement('li');
    li.className = 'entry';

    const node = document.createElement('span');
    node.className = 'entry-node';
    node.style.setProperty('--stone-color', color);
    li.appendChild(node);

    const card = document.createElement('div');
    card.className = `card ${isWatched(item) ? 'watched' : ''} ${isWatching(item) ? 'watching' : ''}`;
    card.style.setProperty('--stone-color', color);
    if (item.image_url) {
      try {
        const imageUrl = new URL(item.image_url, window.location.origin);
        if (imageUrl.protocol === 'http:' || imageUrl.protocol === 'https:') {
          card.style.setProperty('--card-image', `url("${imageUrl.href.replace(/"/g, '\\"')}")`);
        }
      } catch {
        // Ignore invalid image URLs and keep the card readable.
      }
    }

    const toggleId = `watch-${item.id}`;
    card.innerHTML = `
      <p class="card-era">${item.era}</p>
      <h2 class="card-title">${item.title}</h2>
      <div class="card-meta">
        <span class="card-type">${item.type}</span>
        <span class="card-franchise">${item.franchise === 'MCU' ? `MCU · Phase ${item.phase}` : item.franchise}</span>
      </div>
      <div>
        <span class="watch-toggle status-control" id="${toggleId}" aria-label="Status: ${statusLabel(item.watched)}">
          <span class="status-dot" aria-hidden="true"></span>
          <span class="status-label">${statusLabel(item.watched)}</span>
        </span>
      </div>
    `;

    li.appendChild(card);
    timelineEl.appendChild(li);
  }
}

function renderFilteredTimeline() {
  const query = searchInput.value.trim().toLowerCase();
  const filtered = allItems.filter((item) => {
    const matchesFilter = activeFilter === 'all'
      || (activeFilter === 'watched' ? isWatched(item)
        : activeFilter === 'watching' ? isWatching(item) : !isWatched(item));
    return matchesFilter && (!query || `${item.title} ${item.era} ${item.type}`.toLowerCase().includes(query));
  });
  renderTimeline(filtered);
}

async function init() {
  try {
    allItems = await loadItems();
    renderGauntlet(allItems);
    renderOverview(allItems);
    renderFilteredTimeline();
  } catch (err) {
    console.error(err);
  }
}

searchInput.addEventListener('input', renderFilteredTimeline);
for (const button of filterButtons) {
  button.addEventListener('click', () => {
    activeFilter = button.dataset.filter;
    filterButtons.forEach((filterButton) => filterButton.classList.toggle('active', filterButton === button));
    renderFilteredTimeline();
  });
}

init();
