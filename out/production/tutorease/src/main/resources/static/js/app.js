// ============================================================
//  app.js — All CRUD logic for TutorEase
//  Tutors + Bookings
// ============================================================

let allTutors   = [];
let allBookings = [];

// ---- AVATAR EMOJIS ----
const AVATARS = ["👩‍🏫","👨‍🏫","👩‍💼","👨‍💼","🧑‍🏫","👩‍🔬","👨‍🔬","🧑‍💼"];
function getAvatar(id) { return AVATARS[id % AVATARS.length]; }

// ================================================================
//  TUTORS
// ================================================================

// READ - Load all tutors (tutors.html)
async function loadAllTutors() {
  const grid = document.getElementById("tutor-grid");
  if (!grid) return;
  grid.innerHTML = `<div class="loading-msg">Fetching tutors from backend...</div>`;
  try {
    allTutors = await apiGet(API_CONFIG.ENDPOINTS.tutors);
    renderTutors(allTutors, "tutor-grid");
    updateResultCount(allTutors.length);
  } catch {
    grid.innerHTML = `<div class="loading-msg">⚠ Could not load tutors. Is the backend running on localhost:8080?</div>`;
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
    grid.innerHTML = `<div class="loading-msg">⚠ Backend not connected. Start your Spring Boot app to see tutors.</div>`;
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
      <button class="btn btn-book" onclick="openBookModal(${t.id}, '${escJs(t.name)}', '${escJs(t.subject)}')">Book Session</button>
    </div>
  `).join("");
  updateResultCount(tutors.length);
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
  location.href = `pages/tutors.html?${params}`;
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

  if (!name || !email || !phone || !location) {
    showMsg(msg, "⚠ Please fill in all required fields.", "var(--danger)"); return;
  }

  try {
    await apiPost(API_CONFIG.ENDPOINTS.tutors, { name, email, phone, location, subject, gradeLevel, hourlyRate, experience, bio });
    showMsg(msg, "✅ Tutor registered successfully!", "var(--accent)");
    clearForm(["t-name","t-email","t-phone","t-location","t-bio","t-rate","t-exp"]);
    setTimeout(() => closeModal("add-tutor-modal"), 1200);
    loadAllTutors();
  } catch {
    showMsg(msg, "❌ Failed to register. Backend error.", "var(--danger)");
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
  console.log("DEBUG: deleteTutor called for ID:", id);
  // Temporarily removing confirm() to bypass potential browser blocks
  console.log("DEBUG: Proceeding without confirm...");
  try {
    const url = `${API_CONFIG.ENDPOINTS.tutor}/${id}`;
    console.log("DEBUG: Calling apiDelete for:", url);
    await apiDelete(url);
    console.log("DEBUG: Tutor delete successful");
    loadAdminData();
  } catch (err) {
    console.error("DEBUG: Tutor delete failed:", err);
    alert("❌ Could not delete tutor: " + err.message);
  }
}

// ================================================================
//  BOOKINGS
// ================================================================

// Open booking modal
function openBookModal(tutorId, tutorName, subject) {
  document.getElementById("book-tutor-id").value = tutorId;
  const info = document.getElementById("book-tutor-info");
  if (info) info.innerHTML = `📚 Booking session with <strong>${esc(tutorName)}</strong> — ${esc(subject)}`;
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
    showMsg(msg, "⚠ Please fill in all required fields.", "var(--danger)"); return;
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
  tbody.innerHTML = `<tr><td colspan="8" class="empty">Loading...</td></tr>`;
  try {
    allBookings = await apiGet(API_CONFIG.ENDPOINTS.bookings);
    renderBookings(allBookings);
    updateBookingStats(allBookings);
  } catch {
    tbody.innerHTML = `<tr><td colspan="8" class="empty">⚠ Cannot load bookings. Is the backend running?</td></tr>`;
  }
}

function renderBookings(bookings) {
  const tbody = document.getElementById("bookings-tbody");
  if (!tbody) return;
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
          <button class="btn btn-edit btn-sm" onclick="openStatusModal(${b.id},'${b.status}')">Status</button>
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
  console.log("DEBUG: deleteBooking called for ID:", id);
  // Temporarily removing confirm() to see if it's the blocker
  console.log("DEBUG: Proceeding without confirm...");
  try {
    const url = `${API_CONFIG.ENDPOINTS.booking}/${id}`;
    console.log("DEBUG: Calling apiDelete for:", url);
    await apiDelete(url);
    console.log("DEBUG: Delete request finished successfully");
    loadBookings();
    if (typeof loadAdminData === "function") loadAdminData();
  } catch (err) {
    console.error("DEBUG: Delete failed with error:", err);
    alert("❌ Could not delete booking: " + err.message);
  }
}

// ================================================================
//  ADMIN
// ================================================================

async function loadAdminData() {
  try {
    // Load tutors
    const tutors = await apiGet(API_CONFIG.ENDPOINTS.tutors);
    const tbody  = document.getElementById("admin-tutors-tbody");
    if (tbody) {
      tbody.innerHTML = tutors.length === 0
        ? `<tr><td colspan="8" class="empty">No tutors yet.</td></tr>`
        : tutors.map(t => `
          <tr>
            <td>#${t.id}</td>
            <td>${esc(t.name)}<br/><span style="font-size:0.75rem;color:var(--muted)">${esc(t.email)}</span></td>
            <td>${esc(t.subject)}</td>
            <td>${esc(t.gradeLevel)}</td>
            <td>${esc(t.location)}</td>
            <td>LKR ${Number(t.hourlyRate||0).toLocaleString()}</td>
            <td>${t.experience} yrs</td>
            <td>
              <div class="action-btns">
                <button class="btn btn-edit btn-sm" onclick='openEditTutorModal(${JSON.stringify(t)})'>Edit</button>
                <button class="btn btn-danger btn-sm" onclick="deleteTutor(${t.id})">Delete</button>
              </div>
            </td>
          </tr>`).join("");
      const atEl = document.getElementById("a-tutors");
      if (atEl) atEl.textContent = tutors.length;
    }

    // Load bookings
    const bookings = await apiGet(API_CONFIG.ENDPOINTS.bookings);
    const btbody   = document.getElementById("admin-bookings-tbody");
    if (btbody) {
      btbody.innerHTML = bookings.length === 0
        ? `<tr><td colspan="7" class="empty">No bookings yet.</td></tr>`
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
                <button class="btn btn-danger btn-sm" onclick="deleteBooking(${b.id})">Delete</button>
              </div>
            </td>
          </tr>`).join("");
      const abEl = document.getElementById("a-bookings");
      if (abEl) abEl.textContent = bookings.length;
      const apEl = document.getElementById("a-pending");
      if (apEl) apEl.textContent = bookings.filter(b => b.status === "PENDING").length;
      const acEl = document.getElementById("a-completed");
      if (acEl) acEl.textContent = bookings.filter(b => b.status === "COMPLETED").length;
    }
  } catch {
    console.warn("Admin: could not load data — is the backend running?");
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

function esc(str = "") {
  return String(str)
    .replace(/&/g,"&amp;").replace(/</g,"&lt;")
    .replace(/>/g,"&gt;").replace(/"/g,"&quot;");
}
function escJs(str = "") { return String(str).replace(/'/g,"\\'"); }
