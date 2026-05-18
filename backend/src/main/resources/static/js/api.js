// ============================================================
//  api.js — Backend API configuration
//  🔧 Only edit BASE_URL when deploying to a real server
// ============================================================

const API_CONFIG = {
  BASE_URL: "http://localhost:8081/api",   // ← Change this when deploying

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
