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
    showMsg(msg, "⚠ Please fill in all required fields (Username, Password, Name, etc.).", "var(--danger)"); return;
  }

  try {
    await apiPost(API_CONFIG.ENDPOINTS.tutors, { 
      username, password, name, email, phone, location, subject, gradeLevel, hourlyRate, experience, bio 
    });
    showMsg(msg, "✅ Tutor registered successfully! You can now log in.", "var(--accent)");
    clearForm(["t-username", "t-password", "t-name", "t-email", "t-phone", "t-location", "t-bio", "t-rate", "t-exp"]);
    
    // Redirect to login after a short delay
    setTimeout(() => {
      if (window.location.pathname.includes("register-tutor.html")) {
        window.location.href = "login.html";
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
    const inPagesDir = window.location.pathname.includes("/pages/");
    const loginUrl = inPagesDir ? "login.html" : "pages/login.html";
    
    // Modern alert/confirm before redirect
    if (confirm("Please log in as a student to book a tutor. Would you like to go to the login page?")) {
      window.location.href = loginUrl;
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
    studentInput.readOnly = true; // Student name is fixed from account
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
    tbody.innerHTML = `<tr><td colspan="8" class="empty">⚠ Cannot load bookings. Is the backend running?</td></tr>`;
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
    showMsg(msg, "⚠ You must be logged in as a student to pay.", "var(--danger)");
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
      status: "PAID" // Directly set as PAID for simulation
    });
    showMsg(msg, "✅ Payment successful!", "var(--accent)");
    setTimeout(() => {
      closeModal("payment-modal");
      loadBookings(); // Refresh to show PAID status
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
    
    // If tutor logged in, they only see themselves in the tutor list (or we can hide the tutor management tab)
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

    // Filter bookings if tutor
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

function esc(str = "") {
  return String(str)
    .replace(/&/g,"&amp;").replace(/</g,"&lt;")
    .replace(/>/g,"&gt;").replace(/"/g,"&quot;");
}
function escJs(str = "") { return String(str).replace(/'/g,"\\'"); }

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
    grid.innerHTML = `<div class="loading-msg">⚠ Could not load students.</div>`;
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
        // fetch existing student to keep password if empty
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

// Ensure loadAdminStudents is called when loadAdminData runs
// (Removed monkey-patching in favor of direct calls in loadAdminData)

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
    showMsg(msg, "⚠ Rating is required.", "var(--danger)"); return;
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

  // Set UI basics
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
  // Use existing review-modal
  set("r-tutor-id", id); // Reusing this hidden field for review ID when editing
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
    // Instantly remove row from UI without a full reload
    const row = document.querySelector(`button[onclick="deleteReview(${id})"]`)?.closest("tr");
    if (row) row.remove();
    // Also do a full refresh to ensure consistency
    if (typeof loadStudentReviews === 'function') loadStudentReviews();
    // Show inline toast if possible, else alert
    const msg = document.getElementById("review-msg");
    if (msg) {
      showMsg(msg, "✅ Review deleted.", "var(--accent)");
    }
  } catch (err) {
    alert("❌ Could not delete review: " + (err.message || "Server error."));
  }
};

function escJs(str = "") {
  return String(str).replace(/'/g, "\\'").replace(/"/g, '\\"');
}

