<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<style>
/* ===== RESET & BASE ===== */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --bg: #faf8f5;
  --surface: #ffffff;
  --surface2: #f4f1ec;
  --border: #e8e2d9;
  --accent: #2a7c5a;       /* Forest green */
  --accent-light: #e8f5ef;
  --accent2: #f4a135;      /* Warm amber */
  --danger: #e05555;
  --text: #1a1a2e;
  --muted: #7a7a8c;
  --font-head: 'Playfair Display', Georgia, serif;
  --font-body: 'Nunito', sans-serif;
  --radius: 16px;
  --radius-lg: 24px;
  --shadow: 0 4px 20px rgba(0,0,0,0.05);
  --shadow-lg: 0 10px 40px rgba(0,0,0,0.1);
  --shadow-glow: 0 0 20px rgba(42, 124, 90, 0.2);
  --nav-h: 80px;
  --primary: #2a7c5a;
  --secondary: #f4a135;
}

body {
  font-family: var(--font-body);
  background: var(--bg);
  color: var(--text);
  min-height: 100vh;
  line-height: 1.6;
}

/* ===== HELPER CLASSES ===== */
.zen-layout {
  padding: 140px 64px !important;
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
}
.zen-layout .section-title {
  margin-left: auto;
  margin-right: auto;
}

/* ===== NAVBAR ===== */
.navbar {
  position: sticky; 
  top: 0; 
  z-index: 1000;
  height: var(--nav-h);
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(15px);
  -webkit-backdrop-filter: blur(15px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  padding: 0 5%;
  transition: all 0.3s ease;
}

.nav-logo {
  font-family: var(--font-head);
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--text);
  margin-right: auto;
  letter-spacing: -0.02em;
  text-decoration: none;
}
.nav-logo span { color: var(--accent); }

.nav-links { 
  display: flex; 
  gap: 32px; 
  align-items: center;
}

.nav-links a {
  text-decoration: none;
  color: var(--text);
  font-weight: 600;
  font-size: 0.95rem;
  transition: all 0.2s;
  opacity: 0.8;
  position: relative;
}

.nav-links a:hover, .nav-links a.active { 
  color: var(--accent); 
  opacity: 1; 
}

.nav-links a.active::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 100%;
  height: 2px;
  background: var(--accent);
  border-radius: 2px;
}

/* HAMBURGER */
.hamburger {
  display: none;
  flex-direction: column;
  gap: 6px;
  cursor: pointer;
  z-index: 1001;
  padding: 10px;
}

.hamburger span {
  width: 25px;
  height: 2px;
  background: var(--text);
  transition: all 0.3s ease;
}

/* MOBILE MENU */
@media (max-width: 992px) {
  .hamburger { display: flex; }
  
  .nav-links {
    position: fixed;
    top: 0;
    right: -100%;
    width: 80%;
    max-width: 400px;
    height: 100vh;
    background: var(--surface);
    flex-direction: column;
    justify-content: center;
    padding: 60px 40px;
    box-shadow: -10px 0 30px rgba(0,0,0,0.1);
    transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 1000;
    gap: 40px;
  }

  .nav-links.active {
    right: 0;
  }

  .navbar .btn-primary {
    display: none; /* Hide on small screens unless we put it inside menu */
  }

  .nav-links .btn-primary {
    display: flex;
    width: 100%;
  }
}

.hamburger.active span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
.hamburger.active span:nth-child(2) { opacity: 0; }
.hamburger.active span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }

/* ===== HERO ===== */
.hero {
  position: relative;
  padding: 140px 48px 100px;
  text-align: center;
  overflow: hidden;
  background: radial-gradient(circle at top right, var(--accent-light) 0%, transparent 40%),
              radial-gradient(circle at bottom left, #fff4e0 0%, transparent 40%);
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
  position: relative;
  z-index: 2;
}

.hero-tag {
  display: inline-block;
  background: var(--surface);
  color: var(--accent);
  font-size: 0.85rem;
  font-weight: 700;
  padding: 8px 20px;
  border-radius: 999px;
  margin-bottom: 32px;
  border: 1px solid var(--border);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.hero h1 {
  font-family: var(--font-head);
  font-size: 4.2rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 24px;
  color: var(--text);
}
.hero h1 em {
  font-style: italic;
  color: var(--accent);
}

.hero p {
  color: var(--muted);
  font-size: 1.25rem;
  margin-bottom: 48px;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

/* SEARCH WIDGET */
.search-container {
  max-width: 950px;
  margin: 0 auto;
  position: relative;
  z-index: 10;
}

.search-box {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 100px;
  padding: 6px 8px 6px 12px;
  display: flex;
  align-items: center;
  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
  gap: 0;
  transition: border-color 0.25s ease;
}
.search-box:focus-within {
  border-color: rgba(34, 139, 94, 0.4);
}

.search-field {
  display: flex;
  flex-direction: column;
  padding: 12px 28px;
  text-align: left;
  flex: 1;
  border: none;
  border-radius: 100px;
  position: relative;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

/* Semi-height clean vertical dividers */
.search-field:not(:last-of-type)::after {
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  height: 24px;
  width: 1px;
  background-color: var(--border);
  transition: opacity 0.2s ease;
}

/* Hover/active segment modular highlighting */
.search-field:hover {
  background: rgba(0, 0, 0, 0.035);
}
.search-field:focus-within {
  background: var(--surface);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

/* Hide adjacent dividers on hover or focus */
.search-field:hover::after,
.search-field:focus-within::after,
.search-field:hover + .search-field::after,
.search-field:focus-within + .search-field::after {
  opacity: 0;
}

.search-field label {
  font-size: 0.65rem;
  font-weight: 800;
  color: var(--muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 4px;
  pointer-events: none;
}

.search-field select, 
.search-field input[type="text"] {
  border: none !important;
  padding: 0 !important;
  font-size: 0.95rem;
  font-weight: 700;
  color: var(--text);
  background: transparent !important;
  box-shadow: none !important;
  border-radius: 0 !important;
  width: 100%;
}
.search-field select:focus, 
.search-field input[type="text"]:focus { 
  outline: none !important;
  box-shadow: none !important;
}

/* Sleek custom dropdown indicator */
.search-field select {
  appearance: none !important;
  -webkit-appearance: none !important;
  -moz-appearance: none !important;
  padding-right: 20px !important;
  background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23a0aec0' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E") !important;
  background-repeat: no-repeat !important;
  background-position: right center !important;
  background-size: 14px !important;
  cursor: pointer;
}

.search-field input[type="text"]::placeholder {
  color: var(--muted);
  font-weight: 500;
}

/* Elevated visual search button */
.btn-search {
  background: var(--accent);
  color: #fff;
  padding: 14px 32px;
  border-radius: 100px;
  font-size: 0.95rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: none;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(34, 139, 94, 0.15);
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.btn-search svg {
  width: 18px;
  height: 18px;
  fill: none;
  stroke: currentColor;
  stroke-width: 3;
  stroke-linecap: round;
  stroke-linejoin: round;
}
.btn-search:hover {
  background: #1c6b48;
  transform: scale(1.025) translateY(-1px);
  box-shadow: 0 6px 20px rgba(34, 139, 94, 0.25);
}
.btn-search:active {
  transform: scale(0.97) translateY(0);
}

/* ===== SECTION ===== */
.section {
  padding: 100px 64px;
}
.section-label {
  font-size: 0.85rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--accent);
  margin-bottom: 16px;
  display: block;
}
.section-title {
  font-family: var(--font-head);
  font-size: 2.8rem;
  font-weight: 800;
  margin-bottom: 64px;
  color: var(--text);
}

/* HOW IT WORKS */
.how { background: var(--surface); text-align: center; }
.steps {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  max-width: 1100px;
  margin: 0 auto;
}
.step {
  text-align: left;
  padding: 40px;
  background: var(--bg);
  border-radius: var(--radius);
  transition: border-color 0.3s;
  border: 1px solid transparent;
}
.step:hover { border-color: var(--accent); }
.step-num { 
  font-family: var(--font-head);
  font-size: 1.2rem; 
  font-weight: 800; 
  color: var(--accent2); 
  margin-bottom: 24px; 
  display: block;
}
.step-icon { font-size: 2.5rem; margin-bottom: 20px; display: block; }
.step h3 { font-family: var(--font-head); font-size: 1.5rem; font-weight: 700; margin-bottom: 12px; }
.step p  { font-size: 1rem; color: var(--muted); }
.step-arrow { display: none; }

/* ===== TUTOR CARDS ===== */
.featured { text-align: center; }
.tutor-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 32px;
}

.tutor-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 32px;
  box-shadow: none;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  gap: 20px;
  text-align: left;
}
.tutor-card:hover { 
  border-color: var(--accent);
  background: var(--surface);
}

.tc-head { display: flex; align-items: center; gap: 20px; }
.tc-avatar {
  width: 64px; height: 64px;
  border-radius: 50%;
  background: var(--surface2);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.8rem; flex-shrink: 0;
  border: 1px solid var(--border);
}
.tc-name { font-family: var(--font-head); font-weight: 700; font-size: 1.2rem; }
.tc-sub  { font-size: 0.85rem; color: var(--muted); margin-top: 2px; }

.tc-tags { display: flex; flex-wrap: wrap; gap: 8px; }
.tag {
  font-size: 0.75rem;
  font-weight: 700;
  padding: 4px 12px;
  border-radius: 99px;
  background: var(--surface2);
  color: var(--text);
  border: 1px solid var(--border);
}

.tc-info { display: flex; gap: 20px; font-size: 0.9rem; color: var(--muted); font-weight: 500; }
.tc-info span { display: flex; align-items: center; gap: 6px; }

.tc-footer { 
  display: flex; 
  align-items: center; 
  justify-content: space-between; 
  padding-top: 20px;
  border-top: 1px solid var(--border);
  margin-top: 8px;
}
.tc-rate { font-weight: 800; color: var(--text); font-size: 1.1rem; }
.tc-rate span { color: var(--muted); font-size: 0.85rem; font-weight: 500; }
.tc-rating { font-size: 0.85rem; color: var(--accent2); font-weight: 700; display: flex; align-items: center; gap: 4px; }

/* ===== BUTTONS ===== */
.btn {
  padding: 12px 28px;
  border-radius: 12px;
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 700;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
  white-space: nowrap;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.btn-primary  { background: var(--accent); color: #fff; }
.btn-primary:hover  { background: #22654a; }
.btn-outline  { background: transparent; border: 2px solid var(--border); color: var(--text); }
.btn-outline:hover  { border-color: var(--accent); color: var(--accent); }
.btn-book { 
  background: var(--accent); 
  color: #fff; 
  padding: 10px 20px; 
  font-size: 0.9rem; 
  margin-top: auto; 
  width: 100%;
}
.btn-book:hover { background: #22654a; }

/* ===== FOOTER ===== */
.footer {
  background: var(--surface);
  color: var(--text);
  text-align: left;
  padding: 100px 64px 64px;
  border-top: 1px solid var(--border);
}
.footer-content {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  gap: 80px;
  max-width: 1200px;
  margin: 0 auto;
}
.footer-logo { font-family: var(--font-head); font-size: 1.8rem; font-weight: 800; color: var(--text); margin-bottom: 24px; }
.footer-logo span { color: var(--accent); }
.footer p { font-size: 1rem; color: var(--muted); max-width: 300px; }
.footer-links-col h4 { font-family: var(--font-head); margin-bottom: 24px; font-size: 1.1rem; }
.footer-links { display: flex; flex-direction: column; gap: 12px; }
.footer-links a { color: var(--muted); text-decoration: none; font-size: 0.95rem; transition: color 0.2s; }
.footer-links a:hover { color: var(--accent); }
.footer-bottom {
  max-width: 1200px;
  margin: 80px auto 0;
  padding-top: 32px;
  border-top: 1px solid var(--border);
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.footer-copy { font-size: 0.85rem; color: var(--muted); }

/* ===== PAGE LAYOUT (tutors, bookings, admin) ===== */
.page-wrap {
  display: flex;
  padding: 60px 64px;
  gap: 48px;
  min-height: calc(100vh - var(--nav-h));
  max-width: 1400px;
  margin: 0 auto;
}

.filter-sidebar {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 32px;
  background: var(--surface);
  padding: 32px;
  border-radius: var(--radius);
  border: 1px solid var(--border);
  height: fit-content;
  position: sticky;
  top: 120px;
}
.filter-sidebar h3 { 
  font-family: var(--font-head); 
  font-size: 1.4rem; 
  font-weight: 700; 
  margin-bottom: 8px;
}
.filter-group { display: flex; flex-direction: column; gap: 8px; }
.filter-group label { 
  font-size: 0.75rem; 
  font-weight: 800; 
  color: var(--muted); 
  text-transform: uppercase; 
  letter-spacing: 0.08em; 
}

.tutor-main { flex: 1; display: flex; flex-direction: column; gap: 32px; }
.tutor-main-header { display: flex; align-items: flex-end; justify-content: space-between; }
.tutor-main-header h2 { font-family: var(--font-head); font-size: 2.2rem; font-weight: 800; }
.result-count { font-size: 0.95rem; color: var(--muted); font-weight: 600; margin-bottom: 6px; }

.inner-page { 
  padding: 80px 64px; 
  max-width: 1200px;
  margin: 0 auto;
  min-height: calc(100vh - var(--nav-h));
}
.inner-header { 
  display: flex; 
  align-items: center; 
  justify-content: space-between; 
  margin-bottom: 48px; 
  flex-wrap: wrap; 
  gap: 24px; 
}
.inner-header h1 { font-family: var(--font-head); font-size: 3rem; font-weight: 800; }
.inner-header p { color: var(--muted); font-size: 1.1rem; margin-top: 8px; }
.header-actions { display: flex; gap: 16px; align-items: center; }

/* ===== INPUTS ===== */
input[type="text"],
input[type="email"],
input[type="number"],
input[type="date"],
input[type="time"],
select,
textarea {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--text);
  border-radius: 12px;
  padding: 12px 16px;
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 500;
  outline: none;
  transition: all 0.2s;
  width: 100%;
}
input:focus, select:focus, textarea:focus { 
  border-color: var(--accent); 
  background: var(--surface);
  box-shadow: 0 0 0 4px var(--accent-light);
}
input::placeholder, textarea::placeholder { color: #aaa; }
textarea { resize: vertical; }
.status-select { width: auto; min-width: 160px; }

/* ===== BUTTONS EXTRA ===== */
.btn-sm       { padding: 8px 16px; font-size: 0.85rem; border-radius: 8px; }
.btn-edit     { background: var(--accent-light); color: var(--accent); }
.btn-edit:hover     { background: var(--accent); color: #fff; }
.btn-danger   { background: #fff1f1; color: var(--danger); }
.btn-danger:hover   { background: var(--danger); color: #fff; }

/* ===== TABLE ===== */
.card { 
  background: var(--surface); 
  border: 1px solid var(--border); 
  border-radius: var(--radius); 
  overflow: hidden;
}
.table-card { padding: 0; box-shadow: var(--shadow); }
.table-top  { 
  padding: 32px; 
  display: flex; 
  justify-content: space-between; 
  align-items: center; 
  border-bottom: 1px solid var(--border); 
}
.table-top h3 { font-family: var(--font-head); font-size: 1.5rem; font-weight: 700; }

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-size: 0.95rem; }
thead tr { background: var(--surface2); }
th { 
  text-align: left; 
  padding: 18px 24px; 
  color: var(--muted); 
  font-size: 0.75rem; 
  text-transform: uppercase; 
  letter-spacing: 0.1em; 
  font-weight: 800; 
  border-bottom: 1px solid var(--border);
}
td { 
  padding: 20px 24px; 
  border-bottom: 1px solid var(--border); 
  color: var(--text); 
  vertical-align: middle; 
  transition: background 0.2s;
}
tbody tr:last-child td { border-bottom: none; }
tbody tr:hover td { background: var(--accent-light); }
.empty { text-align: center; color: var(--muted); padding: 80px !important; font-size: 1.1rem; }
.action-btns { display: flex; gap: 10px; }

/* STATUS BADGES */
.status { 
  padding: 6px 14px; 
  border-radius: 99px; 
  font-size: 0.75rem; 
  font-weight: 800; 
  text-transform: uppercase; 
  letter-spacing: 0.05em; 
  display: inline-block;
}
.status.PENDING   { background: #fff8e6; color: #b07400; }
.status.CONFIRMED { background: var(--accent-light); color: var(--accent); }
.status.COMPLETED { background: #eef7ff; color: #1a6ea8; }
.status.CANCELLED { background: #fff1f1; color: var(--danger); }

/* ===== BOOKING STATS ===== */
.booking-stats { 
  display: grid; 
  grid-template-columns: repeat(4,1fr); 
  gap: 24px; 
  margin-bottom: 48px; 
}
.bstat { 
  background: var(--surface); 
  border: 1px solid var(--border); 
  border-radius: var(--radius); 
  padding: 32px; 
  text-align: center; 
  transition: transform 0.3s;
}
.bstat:hover { transform: translateY(-4px); border-color: var(--accent); }
.bstat-num { font-family: var(--font-head); font-size: 2.8rem; font-weight: 800; color: var(--text); line-height: 1; }
.bstat-num.pending   { color: var(--accent2); }
.bstat-num.confirmed { color: var(--accent); }
.bstat-num.completed { color: #1a6ea8; }
.bstat-label { 
  font-size: 0.85rem; 
  color: var(--muted); 
  margin-top: 12px; 
  text-transform: uppercase; 
  letter-spacing: 0.1em; 
  font-weight: 700;
}

/* ===== ADMIN STATS ===== */
.admin-stats { 
  display: grid; 
  grid-template-columns: repeat(4,1fr); 
  gap: 24px; 
  margin-bottom: 48px; 
}
.astat-card { 
  background: var(--surface); 
  border: 1px solid var(--border); 
  border-radius: var(--radius); 
  padding: 40px 32px; 
  text-align: center; 
  box-shadow: var(--shadow);
  transition: all 0.3s;
}
.astat-card:hover { border-color: var(--accent); box-shadow: var(--shadow-lg); }
.astat-icon { font-size: 2.8rem; margin-bottom: 16px; display: block; }
.astat-num  { font-family: var(--font-head); font-size: 2.8rem; font-weight: 800; color: var(--accent); line-height: 1; }
.astat-label{ 
  font-size: 0.9rem; 
  color: var(--muted); 
  margin-top: 12px; 
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* ===== TABS ===== */
.tab-bar { 
  display: flex; 
  gap: 8px; 
  background: var(--surface2); 
  border: 1px solid var(--border); 
  border-radius: 16px; 
  padding: 6px; 
  width: fit-content; 
  margin-bottom: 32px; 
}
.tab { 
  background: transparent; 
  border: none; 
  padding: 12px 28px; 
  border-radius: 12px; 
  font-family: var(--font-body); 
  font-size: 0.95rem; 
  font-weight: 700; 
  cursor: pointer; 
  color: var(--muted); 
  transition: all 0.3s; 
}
.tab.active { background: var(--accent); color: #fff; box-shadow: 0 4px 12px rgba(42, 124, 90, 0.2); }

/* ===== MODAL ===== */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(26,26,46,0.4);
  backdrop-filter: blur(12px);
  display: flex; align-items: center; justify-content: center;
  z-index: 999;
}
.modal {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 24px;
  padding: 48px;
  width: 640px; max-width: 95vw;
  max-height: 90vh; overflow-y: auto;
  display: flex; flex-direction: column; gap: 32px;
  box-shadow: 0 24px 64px rgba(0,0,0,0.15);
}
.modal.modal-sm { width: 400px; padding: 40px; }
.modal h3 { font-family: var(--font-head); font-size: 1.8rem; font-weight: 800; }
.modal-form { display: flex; flex-direction: column; gap: 24px; }
.form-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
.field-group { display: flex; flex-direction: column; gap: 8px; }
.field-group label { 
  font-size: 0.75rem; 
  font-weight: 800; 
  color: var(--muted); 
  text-transform: uppercase; 
  letter-spacing: 0.08em; 
}
.modal-btns { display: flex; gap: 16px; justify-content: flex-end; margin-top: 8px; }

.book-tutor-info {
  background: var(--accent-light);
  border-radius: 12px;
  padding: 16px 20px;
  font-size: 1rem;
  font-weight: 600;
  color: var(--accent);
  border: 1px solid var(--accent);
}

/* ===== RESPONSIVE ===== */
@media (max-width: 1024px) {
  .hero h1 { font-size: 3.2rem; }
  .search-box { flex-direction: column; border-radius: 24px; padding: 16px; }
  .search-field { border-right: none; border-bottom: 1px solid var(--border); width: 100%; }
  .btn-search { width: 100%; margin-top: 8px; }
  .steps { grid-template-columns: 1fr; }
  .footer-content { grid-template-columns: 1fr; gap: 40px; }
}
@media (max-width: 768px) {
  .navbar { padding: 0 24px; }
  .hero { padding: 100px 24px 60px; }
  .section { padding: 60px 24px; }
  .zen-layout { padding: 60px 24px; }
}
/* ===== MODERN INPUTS ===== */
.field-group {
  margin-bottom: 20px;
}
.field-group label {
  display: block;
  font-weight: 600;
  margin-bottom: 8px;
  font-size: 0.9rem;
  color: var(--text);
}
.field-group input, 
.field-group select, 
.field-group textarea {
  width: 100%;
  padding: 14px 16px;
  border: 1px solid var(--border);
  border-radius: 12px;
  background: var(--surface);
  font-family: inherit;
  font-size: 1rem;
  transition: all 0.2s ease;
}
.field-group input:focus {
  outline: none;
  border-color: var(--accent);
  box-shadow: 0 0 0 4px var(--accent-light);
}

/* ===== GLASSMORPHISM ===== */
.glass {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

</style>

<script>
// ---- HTML/JS ESCAPE HELPERS ----
function esc(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}
function escJs(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replace(/\\/g, "\\\\")
    .replace(/'/g, "\\'")
    .replace(/"/g, '\\"')
    .replace(/\n/g, "\\n")
    .replace(/\r/g, "\\r");
}

// ============================================================
//  api.js — Backend API configuration
// ============================================================
const API_CONFIG = {
  BASE_URL: window.location.origin + "/api", // ← Dynamically use current host

  ENDPOINTS: {
    tutors:   "/tutors",      // GET all, POST new
    tutor:    "/tutors",      // GET /:id, PUT /:id, DELETE /:id
    bookings: "/bookings",    // GET all, POST new
    booking:  "/bookings",    // PUT /:id, DELETE /:id
    students: "/students",    // GET all, POST new, PUT /:id, DELETE /:id
    reviews:  "/reviews",     // GET all, POST new, GET /tutor/:tutorId
    payments: "/payments",    // GET all, POST new, GET /student/:id, GET /tutor/:id
    login:    "/students/login",
    register: "/students"
  }
};

// ---- GENERIC HELPERS ----
async function apiGet(path) {
  const res = await fetch(API_CONFIG.BASE_URL + path);
  if (!res.ok) {
    let msg = `GET ${path} failed: ${res.status}`;
    try { const data = await res.json(); if (data && (data.message || data.error)) msg = data.message || data.error; } catch {}
    throw new Error(msg);
  }
  return res.json();
}

async function apiPost(path, body) {
  const res = await fetch(API_CONFIG.BASE_URL + path, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  if (!res.ok) {
    let msg = `POST ${path} failed: ${res.status}`;
    try { const text = await res.text(); msg = text || msg; } catch {}
    throw new Error(msg);
  }
  return res.json();
}

async function apiPut(path, body) {
  const res = await fetch(API_CONFIG.BASE_URL + path, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  if (!res.ok) {
    let msg = `PUT ${path} failed: ${res.status}`;
    try { const text = await res.text(); msg = text || msg; } catch {}
    throw new Error(msg);
  }
  return res.json();
}

async function apiDelete(path) {
  const url = API_CONFIG.BASE_URL + path;
  console.log("API DELETE Request to:", url);
  const res = await fetch(url, { method: "DELETE" });
  if (!res.ok) throw new Error(`DELETE ${path} failed: ${res.status}`);
  return true;
}

// ============================================================
//  auth.js — Modern Frontend Authentication & Navbar
// ============================================================
const AUTH_KEY = "tutorease_user";

function getCurrentUser() {
  const user = localStorage.getItem(AUTH_KEY);
  return user ? JSON.parse(user) : null;
}

async function login(username, password, role) {
  if (role === "admin") {
    if (username === "admin" && password === "admin") {
      localStorage.setItem(AUTH_KEY, JSON.stringify({ username, role }));
      return true;
    }
    return false;
  } else if (role === "student") {
    try {
      const response = await apiPost(API_CONFIG.ENDPOINTS.login, { username, password });
      if (response && response.role === "student") {
        localStorage.setItem(AUTH_KEY, JSON.stringify({ 
          username: response.username, 
          role: response.role,
          id: response.id 
        }));
        return true;
      }
    } catch (error) {
      console.error("Login failed:", error);
      return false;
    }
  } else if (role === "tutor") {
    try {
      const response = await apiPost(API_CONFIG.ENDPOINTS.tutor + "/login", { username, password });
      if (response && response.role === "tutor") {
        localStorage.setItem(AUTH_KEY, JSON.stringify({ 
          username: response.username,
          name: response.name,
          role: response.role,
          id: response.id 
        }));
        return true;
      }
    } catch (error) {
      console.error("Tutor login failed:", error);
      return false;
    }
  }
  return false;
}

function logout() {
  localStorage.removeItem(AUTH_KEY);
  window.location.href = "/";
}

function checkAuth(requiredRole) {
  const user = getCurrentUser();
  if (!user || user.role !== requiredRole) {
    window.location.href = "/login";
  }
}

function toggleMobileMenu() {
  const navLinks = document.querySelector(".nav-links");
  const hamburger = document.querySelector(".hamburger");
  if (navLinks && hamburger) {
    navLinks.classList.toggle("active");
    hamburger.classList.toggle("active");
  }
}

function updateNavbar() {
  const navbar = document.querySelector(".navbar");
  if (!navbar) return;

  const user = getCurrentUser();

  // Logo structure
  let navHTML = `
    <a href="/" class="nav-logo">Tutor<span>Ease</span></a>
    <div class="hamburger" onclick="toggleMobileMenu()">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <div class="nav-links">
      <a href="/" id="nav-home">Home</a>
      <a href="/tutors" id="nav-tutors">Find Tutors</a>
  `;

  if (user) {
    if (user.role === "student") {
      navHTML += `
        <a href="/bookings" id="nav-bookings">My Bookings</a>
        <a href="/profile" id="nav-profile">My Profile</a>
      `;
    } else if (user.role === "tutor") {
      navHTML += `<a href="/teacher-dashboard" id="nav-teacher">Teacher Dashboard</a>`;
    } else if (user.role === "admin") {
      navHTML += `<a href="/admin" id="nav-admin">Admin Dashboard</a>`;
    }
    navHTML += `
      <a href="#" onclick="logout()">Logout (${user.username})</a>
    `;
  } else {
    navHTML += `
      <a href="/register-tutor" id="nav-become-tutor">Become a Tutor</a>
      <a href="/login" class="btn btn-primary" style="color: white; opacity: 1;">Sign In</a>
    `;
  }

  navHTML += `</div>`;
  navbar.innerHTML = navHTML;

  // Set active class based on window path
  const currentPath = window.location.pathname;
  if (currentPath === "/" || currentPath === "/index") {
    document.getElementById("nav-home")?.classList.add("active");
  } else if (currentPath.includes("tutors")) {
    document.getElementById("nav-tutors")?.classList.add("active");
  } else if (currentPath.includes("bookings")) {
    document.getElementById("nav-bookings")?.classList.add("active");
  } else if (currentPath.includes("profile")) {
    document.getElementById("nav-profile")?.classList.add("active");
  } else if (currentPath.includes("admin")) {
    document.getElementById("nav-admin")?.classList.add("active");
  } else if (currentPath.includes("teacher-dashboard")) {
    document.getElementById("nav-teacher")?.classList.add("active");
  } else if (currentPath.includes("register-tutor")) {
    document.getElementById("nav-become-tutor")?.classList.add("active");
  }
}

document.addEventListener("DOMContentLoaded", () => {
  updateNavbar();

  // Route Protection Logic
  const user = getCurrentUser();
  const currentPath = window.location.pathname;

  if (currentPath.includes("admin")) {
    if (!user || user.role !== "admin") {
      window.location.href = "/login";
    }
  }

  if (currentPath.includes("bookings") || currentPath.includes("profile")) {
    if (!user || user.role !== "student") {
      window.location.href = "/login";
    }
  }

  if (currentPath.includes("teacher-dashboard")) {
    if (!user || user.role !== "tutor") {
      window.location.href = "/login";
    }
  }
});

// ============================================================
//  app.js — All CRUD logic for TutorEase (Tutors + Bookings)
// ============================================================
let allTutors   = [];
let allBookings = [];

// ---- AVATAR EMOJIS ----
const AVATARS = ["👩‍🏫", "👨‍🏫", "👩‍💻", "👨‍💻", "🧑‍🏫", "👩‍🔬", "👨‍🔬", "🧑‍💻"];
function getAvatar(id) {
  return AVATARS[id % AVATARS.length];
}

// READ - Load all tutors (tutors.html)
async function loadAllTutors() {
  const grid = document.getElementById("tutor-grid");
  if (!grid) return;
  grid.innerHTML = `<div class="loading-msg">Fetching tutors from backend...</div>`;
  try {
    allTutors = await apiGet(API_CONFIG.ENDPOINTS.tutors);
    
    // Check if query parameters from home page search exist
    const params = new URLSearchParams(location.search);
    const subParam = params.get("sub") || "";
    const gradeParam = params.get("grade") || "";
    const locParam = params.get("loc") || "";
    
    // Set filter input values if elements exist
    const fSub = document.getElementById("f-subject");
    const fGrade = document.getElementById("f-grade");
    const fLoc = document.getElementById("f-location");
    
    if (subParam && fSub) fSub.value = subParam;
    if (gradeParam && fGrade) {
      fGrade.value = gradeParam;
      if (!fGrade.value) {
        // Fallback: match dash-insensitively
        const norm = s => s.toLowerCase().replace(/[\u2013\u2014-]/g, "-");
        const normParam = norm(gradeParam);
        for (let i = 0; i < fGrade.options.length; i++) {
          if (norm(fGrade.options[i].value) === normParam || norm(fGrade.options[i].text) === normParam) {
            fGrade.selectedIndex = i;
            break;
          }
        }
      }
    }
    if (locParam && fLoc) fLoc.value = locParam;
    
    // If any search parameter was passed, run applyFilters(), otherwise render all
    if (subParam || gradeParam || locParam) {
      applyFilters();
    } else {
      renderTutors(allTutors, "tutor-grid");
      updateResultCount(allTutors.length);
    }
  } catch (err) {
    console.error("Failed to load tutors:", err);
    grid.innerHTML = `<div class="loading-msg">⚠️ Could not load tutors. Is the backend running?</div>`;
  }
}

// READ - Featured tutors (index.html, max 4)
async function loadFeaturedTutors() {
  const grid = document.getElementById("featured-grid");
  if (!grid) return;
  try {
    const tutors = await apiGet(API_CONFIG.ENDPOINTS.tutors);
    renderTutors(tutors.slice(0, 4), "featured-grid");
  } catch {
    grid.innerHTML = `<div class="loading-msg">⚠️ Backend not connected. Start your Spring Boot app to see tutors.</div>`;
  }
}

// Render tutor cards
function renderTutors(tutors, gridId) {
  const grid = document.getElementById(gridId);
  if (!grid) return;
  if (tutors.length === 0) {
    grid.innerHTML = `<div class="loading-msg">No tutors found. Register the first tutor!</div>`;
    updateResultCount(0);
    return;
  }
  grid.innerHTML = tutors.map(t => `
    <div class="tutor-card">
      <div class="tc-head">
        <div class="tc-avatar">${getAvatar(t.id || 0)}</div>
        <div>
          <div class="tc-name">${esc(t.name)}</div>
          <div class="tc-sub">${esc(t.subject)}</div>
        </div>
      </div>
      <div class="tc-tags">
        <span class="tag">${esc(t.gradeLevel)}</span>
        <span class="tag">📍 ${esc(t.location)}</span>
      </div>
      <div class="tc-info">
        <span>🎓 ${esc(String(t.experience))} yrs exp</span>
        <span>📞 ${esc(t.phone)}</span>
      </div>
      ${t.bio ? `<p style="font-size:0.82rem;color:var(--muted);line-height:1.5">${esc(t.bio)}</p>` : ""}
      <div class="tc-footer">
        <div class="tc-rate">LKR ${Number(t.hourlyRate || 0).toLocaleString()}/hr</div>
        <div class="tc-rating">⭐ 4.${7 + (t.id % 3)}</div>
      </div>
      <div class="tutor-reviews-container" id="reviews-${t.id}" style="margin-bottom:12px; font-size:0.85rem; max-height:80px; overflow-y:auto; display:none;">
         <span style="color:var(--muted)">Loading reviews...</span>
      </div>
      <div style="display:flex; gap:8px;">
        <button class="btn btn-outline btn-sm" onclick="toggleReviews(${t.id})" style="flex:1">View Reviews</button>
        <button class="btn btn-book btn-sm" onclick="openBookModal(${t.id}, '${escJs(t.name)}', '${escJs(t.subject)}')" style="flex:1">Book Session</button>
      </div>
    </div>
  `).join("");
  updateResultCount(tutors.length);

  // Fetch and render reviews asynchronously
  tutors.forEach(async (t) => {
    try {
      const revs = await loadTutorReviews(t.id);
      const revContainer = document.getElementById(`reviews-${t.id}`);
      if (revContainer) {
        if (revs.length === 0) {
          revContainer.innerHTML = `<span style="color:var(--muted)">No reviews yet.</span>`;
        } else {
          revContainer.innerHTML = revs.map(r => `<div><strong>${esc(r.studentName)}</strong> (${r.rating}⭐): ${esc(r.comment)}</div>`).join("");
        }
      }
    } catch (e) {
      // ignore
    }
  });
}

async function toggleReviews(id) {
  const container = document.getElementById(`reviews-${id}`);
  if (!container) return;
     
  const isHidden = container.style.display === "none";
  if (isHidden) {
    container.style.display = "block";
    container.innerHTML = `<span style="color:var(--muted)">Loading reviews...</span>`;
    try {
      const reviews = await apiGet(`${API_CONFIG.ENDPOINTS.reviews}/tutor/${id}`);
      if (reviews.length === 0) {
        container.innerHTML = `<div style="color:var(--muted); font-style:italic;">No reviews yet.</div>`;
      } else {
        container.innerHTML = reviews.map(r => `
          <div style="border-bottom:1px solid #eee; padding:4px 0;">
            <strong>${esc(r.studentName)}:</strong> ${r.rating}⭐ - ${esc(r.comment)}
          </div>
        `).join("");
      }
    } catch (err) {
      container.innerHTML = `<div style="color:var(--danger)">Failed to load reviews.</div>`;
    }
  } else {
    container.style.display = "none";
  }
}

// Filter tutors locally (no extra API call)
function applyFilters() {
  const sub   = (document.getElementById("f-subject")?.value  || "").toLowerCase();
  const grade = (document.getElementById("f-grade")?.value    || "").toLowerCase();
  const loc   = (document.getElementById("f-location")?.value || "").toLowerCase();
  const rate  = parseFloat(document.getElementById("f-rate")?.value || 0);

  const filtered = allTutors.filter(t => {
    if (sub   && !t.subject?.toLowerCase().includes(sub))     return false;
    if (grade && !t.gradeLevel?.toLowerCase().includes(grade)) return false;
    if (loc   && !t.location?.toLowerCase().includes(loc))    return false;
    if (rate  && t.hourlyRate > rate)                          return false;
    return true;
  });
  renderTutors(filtered, "tutor-grid");
}

function clearFilters() {
  ["f-subject","f-grade","f-location","f-rate"].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = "";
  });
  renderTutors(allTutors, "tutor-grid");
}

// Search from homepage
function searchTutors() {
  const sub  = document.getElementById("s-subject")?.value  || "";
  const grade= document.getElementById("s-grade")?.value    || "";
  const loc  = document.getElementById("s-location")?.value || "";
  const params = new URLSearchParams({ sub, grade, loc });
  location.href = `/tutors?${params}`;
}

function updateResultCount(n) {
  const el = document.getElementById("result-count");
  if (el) el.textContent = `${n} tutor${n !== 1 ? "s" : ""} found`;
}

// CREATE - Add tutor
function openAddTutorModal() {
  document.getElementById("add-tutor-modal").style.display = "flex";
}

async function addTutor() {
  const username   = val("t-username");
  const password   = val("t-password");
  const name       = val("t-name");
  const email      = val("t-email");
  const phone      = val("t-phone");
  const location   = val("t-location");
  const subject    = val("t-subject");
  const gradeLevel = val("t-grade");
  const hourlyRate = parseFloat(val("t-rate")) || 0;
  const experience = parseInt(val("t-exp"))    || 0;
  const bio        = val("t-bio");
  const msg        = document.getElementById("tutor-msg");

  if (!username || !password || !name || !email || !phone || !location) {
    showMsg(msg, "⚠️ Please fill in all required fields (Username, Password, Name, etc.).", "var(--danger)"); return;
  }

  try {
    await apiPost(API_CONFIG.ENDPOINTS.tutors, { 
      username, password, name, email, phone, location, subject, gradeLevel, hourlyRate, experience, bio
    });
    showMsg(msg, "✅ Tutor registered successfully! You can now log in.", "var(--accent)");
    clearForm(["t-username", "t-password", "t-name", "t-email", "t-phone", "t-location", "t-bio", "t-rate", "t-exp"]);
    
    // Redirect to login after a short delay
    setTimeout(() => {
      if (window.location.pathname.includes("register-tutor")) {
        window.location.href = "/login";
      } else {
        closeModal("add-tutor-modal");
        loadAllTutors();
      }
    }, 2000);
  } catch (err) {
    const errorMsg = err.message || "Failed to register. Backend error.";
    showMsg(msg, `❌ ${errorMsg}`, "var(--danger)");
  }
}

// UPDATE tutor (admin)
function openEditTutorModal(t) {
  set("et-id",       t.id);
  set("et-name",     t.name);
  set("et-email",    t.email);
  set("et-phone",    t.phone);
  set("et-location", t.location);
  set("et-subject",  t.subject);
  set("et-grade",    t.gradeLevel);
  set("et-rate",     t.hourlyRate);
  set("et-exp",      t.experience);
  set("et-bio",      t.bio);
  document.getElementById("edit-tutor-modal").style.display = "flex";
}

async function updateTutor() {
  const id = val("et-id");
  const body = {
    name:       val("et-name"),
    email:      val("et-email"),
    phone:      val("et-phone"),
    location:   val("et-location"),
    subject:    val("et-subject"),
    gradeLevel: val("et-grade"),
    hourlyRate: parseFloat(val("et-rate")) || 0,
    experience: parseInt(val("et-exp"))    || 0,
    bio:        val("et-bio")
  };
  try {
    await apiPut(`${API_CONFIG.ENDPOINTS.tutor}/${id}`, body);
    closeModal("edit-tutor-modal");
    loadAdminData();
  } catch {
    alert("❌ Update failed. Backend error.");
  }
}

// DELETE tutor
async function deleteTutor(id) {
  if (!confirm("Delete this tutor permanently?")) return;
  try {
    await apiDelete(`${API_CONFIG.ENDPOINTS.tutor}/${id}`);
    loadAdminData();
  } catch (err) {
    alert("❌ Could not delete tutor: " + err.message);
  }
}

// ================================================================
//  BOOKINGS
// ================================================================

// Open booking modal
function openBookModal(tutorId, tutorName, subject) {
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  
  if (!user || user.role !== 'student') {
    if (confirm("Please log in as a student to book a tutor. Would you like to go to the login page?")) {
      window.location.href = "/login";
    }
    return;
  }

  document.getElementById("book-tutor-id").value = tutorId;
  const info = document.getElementById("book-tutor-info");
  if (info) info.innerHTML = `📚 Booking session with <strong>${esc(tutorName)}</strong> — ${esc(subject)}`;
  
  // Prefill student name if available
  const studentInput = document.getElementById("b-student");
  if (studentInput && user.username) {
    studentInput.value = user.username;
    studentInput.readOnly = true;
  }

  // Set min date to today
  const dateEl = document.getElementById("b-date");
  if (dateEl) dateEl.min = new Date().toISOString().split("T")[0];
  document.getElementById("book-modal").style.display = "flex";
}

// CREATE booking
async function confirmBooking() {
  const tutorId    = val("book-tutor-id");
  const studentName= val("b-student");
  const phone      = val("b-phone");
  const sessionDate= val("b-date");
  const sessionTime= val("b-time");
  const address    = val("b-address");
  const notes      = val("b-notes");
  const msg        = document.getElementById("book-msg");

  if (!studentName || !phone || !sessionDate || !sessionTime || !address) {
    showMsg(msg, "⚠️ Please fill in all required fields.", "var(--danger)"); return;
  }

  try {
    await apiPost(API_CONFIG.ENDPOINTS.bookings, {
      tutorId: parseInt(tutorId),
      studentName, phone, sessionDate, sessionTime, address, notes,
      status: "PENDING"
    });
    showMsg(msg, "✅ Booking confirmed! Tutor will contact you soon.", "var(--accent)");
    clearForm(["b-student","b-phone","b-date","b-time","b-address","b-notes"]);
    setTimeout(() => closeModal("book-modal"), 1500);
  } catch {
    showMsg(msg, "❌ Booking failed. Backend error.", "var(--danger)");
  }
}

// READ all bookings (bookings.html)
async function loadBookings() {
  const tbody = document.getElementById("bookings-tbody");
  if (!tbody) return;
  tbody.innerHTML = `<tr><td colspan="8" class="empty">Loading your bookings...</td></tr>`;
  
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;

  try {
    const rawBookings = await apiGet(API_CONFIG.ENDPOINTS.bookings);
    
    // Filter by student if logged in as student
    if (user && user.role === 'student' && user.username) {
      allBookings = rawBookings.filter(b => 
        b.studentName === user.username ||
        b.studentName === (user.name || "")
      );
    } else {
      allBookings = rawBookings; // Admins see all
    }
    
    // Fetch payments to check if already paid
    let studentPayments = [];
    if (user && user.role === 'student') {
      try {
        studentPayments = await apiGet(`${API_CONFIG.ENDPOINTS.payments}/student/${user.id}`);
      } catch (e) { console.log('Could not fetch payments'); }
    }

    // Attach payment status to bookings
    allBookings.forEach(b => {
      const p = studentPayments.find(pay => pay.booking && pay.booking.id === b.id);
      if (p) b.paymentStatus = p.status;
    });

    renderBookings(allBookings);
    updateBookingStats(allBookings);
  } catch (e) {
    console.error("Booking load error:", e);
    tbody.innerHTML = `<tr><td colspan="8" class="empty">⚠️ Cannot load bookings. Is the backend running?</td></tr>`;
  }
}

function renderBookings(bookings) {
  const tbody = document.getElementById("bookings-tbody");
  if (!tbody) return;
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (bookings.length === 0) {
    tbody.innerHTML = `<tr><td colspan="8" class="empty">No bookings found.</td></tr>`;
    return;
  }
  tbody.innerHTML = bookings.map(b => `
    <tr>
      <td>#${b.id}</td>
      <td>${esc(b.studentName)}<br/><span style="font-size:0.75rem;color:var(--muted)">${esc(b.phone)}</span></td>
      <td>${esc(b.tutorName || "Tutor #" + b.tutorId)}</td>
      <td>${esc(b.subject || "—")}</td>
      <td>${esc(b.sessionDate)} ${esc(b.sessionTime)}</td>
      <td>${esc(b.address)}</td>
      <td><span class="status ${esc(b.status)}">${esc(b.status)}</span></td>
      <td>
        <div class="action-btns">
          ${user && user.role !== 'student' ? `<button class="btn btn-edit btn-sm" onclick="openStatusModal(${b.id},'${b.status}')">Status</button>` : ''}
          
          ${b.paymentStatus === 'PAID' 
            ? `<span class="tag" style="background:#dcfce7;color:#166534">✅ PAID</span>`
            : (b.status === 'CONFIRMED' 
                ? `<button class="btn btn-primary btn-sm" onclick="openPaymentModal(${b.id}, ${b.tutorId})">💳 Pay Now</button>`
                : `<button class="btn btn-sm" disabled title="Tutor must confirm first" style="opacity:0.5; cursor:not-allowed">💳 Pay Now</button>`)
          }

          ${b.status === 'COMPLETED' 
            ? `<button class="btn btn-primary btn-sm" onclick="openReviewModal(${b.tutorId})">⭐ Review</button>`
            : `<button class="btn btn-sm" disabled title="Session must be completed first" style="opacity:0.5; cursor:not-allowed">⭐ Review</button>`
          }

          <button class="btn btn-danger btn-sm" onclick="deleteBooking(${b.id})">Cancel</button>
        </div>
      </td>
    </tr>
  `).join("");
}

function updateBookingStats(bookings) {
  const set = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
  set("bs-total",     bookings.length);
  set("bs-pending",   bookings.filter(b => b.status === "PENDING").length);
  set("bs-confirmed", bookings.filter(b => b.status === "CONFIRMED").length);
  set("bs-completed", bookings.filter(b => b.status === "COMPLETED").length);
}

function filterBookings() {
  const status = document.getElementById("status-filter")?.value || "";
  const filtered = status ? allBookings.filter(b => b.status === status) : allBookings;
  renderBookings(filtered);
}

// UPDATE booking status
function openStatusModal(id, currentStatus) {
  document.getElementById("update-booking-id").value = id;
  document.getElementById("new-status").value = currentStatus;
  document.getElementById("status-modal").style.display = "flex";
}

async function updateBookingStatus() {
  const id     = val("update-booking-id");
  const status = val("new-status");
  try {
    await apiPut(`${API_CONFIG.ENDPOINTS.booking}/${id}/status`, { status });
    closeModal("status-modal");
    loadBookings();
  } catch {
    alert("❌ Could not update status.");
  }
}

// DELETE booking
async function deleteBooking(id) {
  if (!confirm("Cancel this booking permanently?")) return;
  try {
    await apiDelete(`${API_CONFIG.ENDPOINTS.booking}/${id}`);
    loadBookings();
    if (typeof loadAdminData === "function") loadAdminData();
  } catch (err) {
    alert("❌ Could not delete booking: " + err.message);
  }
}

// ================================================================
//  PAYMENTS
// ================================================================
async function openPaymentModal(bookingId, tutorId) {
  document.getElementById("p-booking-id").value = bookingId;
  document.getElementById("p-tutor-id").value = tutorId;
  
  // Find booking details
  const booking = allBookings.find(b => b.id === bookingId);
  if (booking) {
    document.getElementById("p-tutor-name").textContent = booking.tutorName || "Tutor #" + tutorId;
    document.getElementById("p-details").textContent    = `${booking.subject} on ${booking.sessionDate} at ${booking.sessionTime}`;
  }

  // Fetch tutor rate
  try {
    const tutor = await apiGet(`${API_CONFIG.ENDPOINTS.tutors}/${tutorId}`);
    document.getElementById("p-amount").value = tutor.hourlyRate || 0;
  } catch (e) {
    document.getElementById("p-amount").value = 0;
  }

  const msg = document.getElementById("payment-msg");
  if (msg) msg.textContent = "";

  document.getElementById("payment-modal").style.display = "flex";
}

async function submitPayment() {
  const bookingId = val("p-booking-id");
  const tutorId = val("p-tutor-id");
  const amount = val("p-amount");
  const method = val("p-method");
  const msg = document.getElementById("payment-msg");

  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'student') {
    showMsg(msg, "⚠️ You must be logged in as a student to pay.", "var(--danger)");
    return;
  }

  try {
    document.getElementById("p-submit-btn").disabled = true;
    const payRes = await apiPost(API_CONFIG.ENDPOINTS.payments, {
      booking: { id: parseInt(bookingId) },
      student: { id: parseInt(user.id) },
      tutor: { id: parseInt(tutorId) },
      amount: parseFloat(amount),
      paymentMethod: method,
      status: "PAID"
    });
    showMsg(msg, "✅ Payment successful!", "var(--accent)");
    setTimeout(() => {
      closeModal("payment-modal");
      loadBookings();
    }, 1500);
  } catch (err) {
    showMsg(msg, `❌ Payment failed: ${err.message}`, "var(--danger)");
  } finally {
    document.getElementById("p-submit-btn").disabled = false;
  }
}

async function loadTeacherPayments() {
  const tbody = document.getElementById("teacher-payments-tbody");
  if (!tbody) return;
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'tutor') return;

  tbody.innerHTML = `<tr><td colspan="4" class="empty">Loading payments...</td></tr>`;
  try {
    const payments = await apiGet(`${API_CONFIG.ENDPOINTS.payments}/tutor/${user.id}`);
    if (payments.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" class="empty">No payments received yet.</td></tr>`;
    } else {
      tbody.innerHTML = payments.map(p => `
        <tr>
          <td>${esc(p.student ? p.student.name || p.student.username : "Unknown")}</td>
          <td>#${p.booking ? p.booking.id : "—"}</td>
          <td>LKR ${Number(p.amount||0).toLocaleString()}</td>
          <td><span class="status-badge status-${(p.status||"").toLowerCase()}">${esc(p.status)}</span></td>
        </tr>
      `).join("");
    }
  } catch (err) {
    tbody.innerHTML = `<tr><td colspan="4" class="empty">Could not load payments.</td></tr>`;
  }
}

// ================================================================
//  ADMIN
// ================================================================
async function loadAdminData() {
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  const isTutor = user && user.role === 'tutor';

  try {
    // Load tutors
    const rawTutors = await apiGet(API_CONFIG.ENDPOINTS.tutors);
    let tutors = rawTutors;
    
    if (isTutor) {
      tutors = rawTutors.filter(t => t.id == user.id);
    }

    const tbody  = document.getElementById("admin-tutors-tbody");
    if (tbody) {
      tbody.innerHTML = tutors.length === 0
        ? `<tr><td colspan="8" class="empty">No tutors found.</td></tr>`
        : tutors.map(t => `
          <tr>
            <td>#${t.id}</td>
            <td>${esc(t.name)}<br/><span style="font-size:0.75rem;color:var(--muted)">${esc(t.email)}</span>${t.id == user?.id ? ' <span class="tag">You</span>' : ''}</td>
            <td>${esc(t.subject)}</td>
            <td>${esc(t.gradeLevel)}</td>
            <td>${esc(t.location)}</td>
            <td>LKR ${Number(t.hourlyRate||0).toLocaleString()}</td>
            <td>${t.experience} yrs</td>
            <td>
              <div class="action-btns">
                <button class="btn btn-edit btn-sm" onclick='openEditTutorModal(${JSON.stringify(t)})'>Edit</button>
                ${!isTutor ? `<button class="btn btn-danger btn-sm" onclick="deleteTutor(${t.id})">Delete</button>` : ''}
              </div>
            </td>
          </tr>`).join("");
      const atEl = document.getElementById("a-tutors");
      if (atEl) atEl.textContent = tutors.length;
    }

    // Load bookings
    const rawBookings = await apiGet(API_CONFIG.ENDPOINTS.bookings);
    let bookings = rawBookings;

    if (isTutor) {
      bookings = rawBookings.filter(b => b.tutorId == user.id);
    }

    const btbody   = document.getElementById("admin-bookings-tbody");
    if (btbody) {
      btbody.innerHTML = bookings.length === 0
        ? `<tr><td colspan="7" class="empty">No bookings found.</td></tr>`
        : bookings.map(b => `
          <tr>
            <td>#${b.id}</td>
            <td>${esc(b.studentName)}</td>
            <td>${esc(b.tutorName || "Tutor #" + b.tutorId)}</td>
            <td>${esc(b.sessionDate)} ${esc(b.sessionTime)}</td>
            <td>${esc(b.address)}</td>
            <td><span class="status ${esc(b.status)}">${esc(b.status)}</span></td>
            <td>
              <div class="action-btns">
                <button class="btn btn-edit btn-sm" onclick="openStatusModal(${b.id},'${b.status}')">Update Status</button>
                ${!isTutor ? `<button class="btn btn-danger btn-sm" onclick="deleteBooking(${b.id})">Delete</button>` : ''}
              </div>
            </td>
          </tr>`).join("");
      // Update stats
      const abEl = document.getElementById("a-bookings");
      const apEl = document.getElementById("a-pending");
      const acEl = document.getElementById("a-completed");
      if (abEl) abEl.textContent = bookings.length;
      if (apEl) apEl.textContent = bookings.filter(b => b.status === "PENDING").length;
      if (acEl) acEl.textContent = bookings.filter(b => b.status === "COMPLETED").length;
    }

    // Load admin payments
    if (typeof loadAdminPayments === 'function') await loadAdminPayments();
    
    // Load admin students
    if (typeof loadAdminStudents === 'function') await loadAdminStudents();

  } catch (err) {
    console.error("Admin data load failed:", err);
  }
}

async function loadAdminPayments() {
  const tbody = document.getElementById("admin-payments-tbody");
  if (!tbody) return;
  try {
    const payments = await apiGet(API_CONFIG.ENDPOINTS.payments);
    tbody.innerHTML = payments.length === 0
      ? `<tr><td colspan="5" class="empty">No payments recorded.</td></tr>`
      : payments.map(p => `
        <tr>
          <td>#${p.id}</td>
          <td>${esc(p.student?.username || "Student")}</td>
          <td>#${p.booking?.id || "—"}</td>
          <td>LKR ${Number(p.amount||0).toLocaleString()}</td>
          <td><span class="tag" style="background:#dcfce7;color:#166534">${esc(p.status)}</span></td>
        </tr>`).join("");
  } catch (err) {
    console.error("Failed to load admin payments:", err);
  }
}

// ================================================================
//  BACKEND STATUS CHECK
// ================================================================
async function checkBackend() {
  const badge = document.getElementById("api-badge");
  if (!badge) return;
  try {
    await apiGet(API_CONFIG.ENDPOINTS.tutors);
    badge.textContent = "✅ Backend: Connected";
    badge.classList.add("online");
  } catch {
    badge.textContent = "❌ Backend: Offline";
    badge.classList.add("offline");
  }
}

// ================================================================
//  HELPERS
// ================================================================
function val(id)     { return (document.getElementById(id)?.value || "").trim(); }
function set(id, v)  { const el = document.getElementById(id); if (el) el.value = v || ""; }
function closeModal(id) { document.getElementById(id).style.display = "none"; }
function clearForm(ids)  { ids.forEach(id => { const el = document.getElementById(id); if (el) el.value = ""; }); }

function showMsg(el, text, color) {
  if (!el) return;
  el.textContent = text;
  el.style.color = color;
  setTimeout(() => { el.textContent = ""; }, 3000);
}

// ================================================================
//  STUDENT MANAGEMENT
// ================================================================
async function loadAllStudents() {
  const grid = document.getElementById("students-grid");
  if (!grid) return;
  grid.innerHTML = `<div class="loading-msg">Fetching students from backend...</div>`;
  try {
    const students = await apiGet(API_CONFIG.ENDPOINTS.students);
    grid.innerHTML = students.length === 0 ? `<div class="loading-msg">No students found.</div>` : students.map(s => `
      <div class="student-card">
        <div class="sc-head">
          <div class="sc-avatar">🎓</div>
          <div>
            <div class="sc-name">${esc(s.name || s.username)}</div>
            <div class="sc-username">@${esc(s.username)}</div>
          </div>
        </div>
        <div class="sc-info">
          <span>📧 ${esc(s.email || "No email")}</span>
          <span>📞 ${esc(s.phone || "No phone")}</span>
          <span>📚 ${esc(s.gradeLevel || "Grade not set")}</span>
        </div>
      </div>
    `).join("");
    const rc = document.getElementById("result-count");
    if (rc) rc.textContent = `${students.length} student${students.length !== 1 ? "s" : ""} found`;
  } catch (err) {
    grid.innerHTML = `<div class="loading-msg">⚠️ Could not load students.</div>`;
  }
}

async function loadAdminStudents() {
  const tbody = document.getElementById("admin-students-tbody");
  if (!tbody) return;
  try {
    const students = await apiGet(API_CONFIG.ENDPOINTS.students);
    tbody.innerHTML = students.length === 0 ? `<tr><td colspan="7" class="empty">No students.</td></tr>` : students.map(s => `
      <tr>
        <td>#${s.id}</td>
        <td>${esc(s.username)}</td>
        <td>${esc(s.name)}</td>
        <td>${esc(s.email)}</td>
        <td>${esc(s.phone)}</td>
        <td>${esc(s.gradeLevel)}</td>
        <td>
          <div class="action-btns">
            <button class="btn btn-edit btn-sm" onclick='openEditStudentModal(${JSON.stringify(s)})'>Edit</button>
            <button class="btn btn-danger btn-sm" onclick="deleteStudent(${s.id})">Delete</button>
          </div>
        </td>
      </tr>
    `).join("");
  } catch (err) {
    console.warn("Could not load admin students");
  }
}

function openAddStudentModal() {
  set("es-id", "");
  clearForm(["es-username", "es-password", "es-name", "es-email", "es-phone", "es-grade"]);
  document.getElementById("student-modal-title").textContent = "Add Student";
  document.getElementById("student-modal").style.display = "flex";
}

function openEditStudentModal(s) {
  set("es-id", s.id);
  set("es-username", s.username);
  set("es-password", "");
  set("es-name", s.name);
  set("es-email", s.email);
  set("es-phone", s.phone);
  set("es-grade", s.gradeLevel);
  document.getElementById("student-modal-title").textContent = "Edit Student";
  document.getElementById("student-modal").style.display = "flex";
}

async function saveStudent() {
  const id = val("es-id");
  const body = {
    username: val("es-username"),
    name: val("es-name"),
    email: val("es-email"),
    phone: val("es-phone"),
    gradeLevel: val("es-grade")
  };
  const pwd = val("es-password");
  if (pwd) body.password = pwd;

  try {
    if (id) {
      if (!pwd) {
        const existing = await apiGet(`${API_CONFIG.ENDPOINTS.students}/${id}`);
        body.password = existing.password;
      }
      await apiPut(`${API_CONFIG.ENDPOINTS.students}/${id}`, body);
    } else {
      if (!pwd) { alert("Password is required for new students"); return; }
      await apiPost(API_CONFIG.ENDPOINTS.students, body);
    }
    closeModal("student-modal");
    loadAdminStudents();
  } catch (err) {
    alert("❌ Failed to save student.");
  }
}

async function deleteStudent(id) {
  try {
    await apiDelete(`${API_CONFIG.ENDPOINTS.students}/${id}`);
    loadAdminStudents();
  } catch (err) {
    alert("❌ Could not delete student.");
  }
}

// ================================================================
//  REVIEW SYSTEM
// ================================================================
function openReviewModal(tutorId) {
  set("r-tutor-id", tutorId);
  set("r-rating", "5");
  set("r-comment", "");
  
  const title = document.querySelector("#review-modal h3");
  if (title) title.textContent = "Leave a Review";
  
  const btn = document.querySelector("#review-modal .btn-primary");
  if (btn) {
    btn.textContent = "Submit";
    btn.onclick = () => submitReview();
  }

  const msg = document.getElementById("review-msg");
  if (msg) msg.textContent = "";

  document.getElementById("review-modal").style.display = "flex";
}

async function submitReview() {
  const tutorId = val("r-tutor-id");
  const rating = parseInt(val("r-rating"));
  const comment = val("r-comment");
  const msg = document.getElementById("review-msg");

  const user = JSON.parse(localStorage.getItem("tutorease_user"));
  const studentName = user ? user.username : "Anonymous";

  if (!rating) {
    showMsg(msg, "⚠️ Rating is required.", "var(--danger)"); return;
  }

  try {
    await apiPost(API_CONFIG.ENDPOINTS.reviews, {
      tutorId: parseInt(tutorId),
      studentName: studentName,
      rating: rating,
      comment: comment
    });
    showMsg(msg, "✅ Review submitted successfully!", "var(--accent)");
    setTimeout(() => {
      closeModal("review-modal");
      if (typeof loadStudentReviews === 'function') loadStudentReviews();
    }, 1500);
  } catch (err) {
    showMsg(msg, "❌ Failed to submit review.", "var(--danger)");
  }
}

async function loadTutorReviews(tutorId) {
  try {
    return await apiGet(`${API_CONFIG.ENDPOINTS.reviews}/tutor/${tutorId}`);
  } catch (err) {
    return [];
  }
}

// ================================================================
//  TEACHER DASHBOARD LOGIC
// ================================================================
async function initTeacherDashboard() {
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'tutor') return;

  const nameEl = document.getElementById("teacher-name");
  if (nameEl) nameEl.textContent = `Welcome back, ${user.name || user.username}!`;
  const userEl = document.getElementById("teacher-username");
  if (userEl) userEl.textContent = `@${user.username}`;

  try {
    // 1. Load Tutor Profile Data
    const tutor = await apiGet(`${API_CONFIG.ENDPOINTS.tutors}/${user.id}`);
    if (tutor) {
      set("prof-name", tutor.name);
      set("prof-email", tutor.email);
      set("prof-phone", tutor.phone);
      set("prof-location", tutor.location);
      set("prof-subject", tutor.subject);
      set("prof-exp", tutor.experience);
      set("prof-bio", tutor.bio);
      
      const subEl = document.getElementById("stat-subject");
      if (subEl) subEl.textContent = tutor.subject || "Not set";
    }

    // 2. Load Bookings
    const bookings = await apiGet(API_CONFIG.ENDPOINTS.bookings);
    const myBookings = bookings.filter(b => b.tutorId == user.id);

    // Update Stats
    const totalEl = document.getElementById("stat-total");
    if (totalEl) totalEl.textContent = myBookings.length;
    
    const pendingEl = document.getElementById("stat-pending");
    if (pendingEl) pendingEl.textContent = myBookings.filter(b => b.status === "PENDING").length;
    
    const completedEl = document.getElementById("stat-completed");
    if (completedEl) completedEl.textContent = myBookings.filter(b => b.status === "COMPLETED").length;

    // Render Tables
    renderTeacherBookings(myBookings);
  } catch (err) {
    console.error("Dashboard init failed:", err);
  }
}

function renderTeacherBookings(bookings) {
  const upcomingTbody = document.getElementById("upcoming-tbody");
  const allTbody = document.getElementById("all-bookings-tbody");

  const upcoming = bookings.filter(b => b.status === "PENDING" || b.status === "CONFIRMED");

  if (upcomingTbody) {
    upcomingTbody.innerHTML = upcoming.length === 0 
      ? `<tr><td colspan="4" class="empty">No upcoming sessions.</td></tr>`
      : upcoming.map(b => `
        <tr>
          <td><strong>${esc(b.studentName)}</strong></td>
          <td>${esc(b.sessionDate)} @ ${esc(b.sessionTime)}</td>
          <td><span class="status-badge status-${b.status.toLowerCase()}">${esc(b.status)}</span></td>
          <td><button class="btn btn-sm btn-outline" onclick="openTeacherStatusModal(${b.id}, '${b.status}')">Update</button></td>
        </tr>
      `).join("");
  }

  if (allTbody) {
    allTbody.innerHTML = bookings.length === 0
      ? `<tr><td colspan="7" class="empty">No bookings found.</td></tr>`
      : bookings.map(b => `
        <tr>
          <td>#${b.id}</td>
          <td>${esc(b.studentName)}<br/><small>${esc(b.phone)}</small></td>
          <td>${esc(b.sessionDate)}</td>
          <td>${esc(b.sessionTime)}</td>
          <td>${esc(b.address)}</td>
          <td><span class="status-badge status-${b.status.toLowerCase()}">${esc(b.status)}</span></td>
          <td><button class="btn btn-sm btn-outline" onclick="openTeacherStatusModal(${b.id}, '${b.status}')">Update</button></td>
        </tr>
      `).join("");
  }
}

function openTeacherStatusModal(id, status) {
  set("update-booking-id", id);
  const sel = document.getElementById("new-status");
  if (sel) sel.value = status;
  document.getElementById("status-modal").style.display = "flex";
}

async function updateTeacherBookingStatus() {
  const id = val("update-booking-id");
  const status = document.getElementById("new-status").value;
  try {
    await apiPut(`${API_CONFIG.ENDPOINTS.booking}/${id}/status`, { status });
    closeModal("status-modal");
    initTeacherDashboard(); // Refresh
  } catch (err) {
    alert("Failed to update status.");
  }
}

async function updateTeacherProfile() {
  const user = getCurrentUser();
  const body = {
    name: val("prof-name"),
    email: val("prof-email"),
    phone: val("prof-phone"),
    location: val("prof-location"),
    subject: val("prof-subject"),
    experience: parseInt(val("prof-exp")) || 0,
    bio: val("prof-bio")
  };

  const msg = document.getElementById("profile-msg");
  try {
    await apiPut(`${API_CONFIG.ENDPOINTS.tutors}/${user.id}`, body);
    showMsg(msg, "✅ Profile updated successfully!", "var(--accent)");
    
    // Update local storage name if changed
    user.name = body.name;
    localStorage.setItem("tutorease_user", JSON.stringify(user));
    
    setTimeout(() => initTeacherDashboard(), 1000);
  } catch (err) {
    showMsg(msg, "❌ Failed to update profile.", "var(--danger)");
  }
}

// ================================================================
//  REVIEW MANAGEMENT (CRUD)
// ================================================================
async function loadStudentReviews() {
  const tbody = document.getElementById("student-reviews-tbody");
  if (!tbody) return;
  
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'student') return;

  try {
    const allReviews = await apiGet(API_CONFIG.ENDPOINTS.reviews);
    const myReviews = allReviews.filter(r => r.studentName === user.username);
    
    tbody.innerHTML = myReviews.length === 0 
      ? `<tr><td colspan="4" class="empty">You haven't left any reviews yet.</td></tr>`
      : myReviews.map(r => `
        <tr>
          <td>Tutor #${r.tutorId}</td>
          <td>${r.rating} ⭐</td>
          <td>${esc(r.comment)}</td>
          <td>
            <button class="btn btn-sm btn-outline" onclick="openEditReviewModal(${r.id}, ${r.rating}, '${escJs(r.comment)}')">Edit</button>
            <button class="btn btn-sm btn-danger" onclick="deleteReview(${r.id})">Delete</button>
          </td>
        </tr>
      `).join("");
  } catch (err) {
    console.error("Failed to load reviews:", err);
  }
}

async function loadTeacherReviews() {
  const tbody = document.getElementById("teacher-reviews-tbody");
  if (!tbody) return;
  
  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'tutor') return;

  try {
    const reviews = await apiGet(`${API_CONFIG.ENDPOINTS.reviews}/tutor/${user.id}`);
    tbody.innerHTML = reviews.length === 0
      ? `<tr><td colspan="3" class="empty">No reviews received yet.</td></tr>`
      : reviews.map(r => `
        <tr>
          <td><strong>${esc(r.studentName)}</strong></td>
          <td>${r.rating} ⭐</td>
          <td>${esc(r.comment)}</td>
        </tr>
      `).join("");
  } catch (err) {
    console.error("Failed to load teacher reviews:", err);
  }
}

function openEditReviewModal(id, rating, comment) {
  set("r-tutor-id", id);
  set("r-rating", rating);
  set("r-comment", comment);
  
  const title = document.querySelector("#review-modal h3");
  if (title) title.textContent = "Edit Your Review";
  
  const btn = document.querySelector("#review-modal .btn-primary");
  if (btn) {
    btn.textContent = "Update Review";
    btn.onclick = () => updateReview(id);
  }
  
  document.getElementById("review-modal").style.display = "flex";
}

async function updateReview(id) {
  const rating = parseInt(val("r-rating"));
  const comment = val("r-comment");
  const msg = document.getElementById("review-msg");

  try {
    await apiPut(`${API_CONFIG.ENDPOINTS.reviews}/${id}`, { rating, comment });
    showMsg(msg, "✅ Review updated successfully!", "var(--accent)");
    setTimeout(() => {
      closeModal("review-modal");
      loadStudentReviews();
    }, 1500);
  } catch (err) {
    showMsg(msg, "❌ Failed to update review.", "var(--danger)");
  }
}

// ================================================================
//  REVIEW DELETE (PRODUCTION)
// ================================================================
window.deleteReview = async function(id) {
  if (!id) return;

  const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
  if (!user || user.role !== 'student') {
    alert("You must be logged in as a student to delete reviews.");
    return;
  }

  if (!confirm("Are you sure you want to permanently delete this review?")) return;

  try {
    await apiDelete(`${API_CONFIG.ENDPOINTS.reviews}/${id}`);
    const row = document.querySelector(`button[onclick="deleteReview(${id})"]`)?.closest("tr");
    if (row) row.remove();
    if (typeof loadStudentReviews === 'function') loadStudentReviews();
    const msg = document.getElementById("review-msg");
    if (msg) {
      showMsg(msg, "✅ Review deleted.", "var(--accent)");
    }
  } catch (err) {
    alert("❌ Could not delete review: " + (err.message || "Server error."));
  }
};
</script>

