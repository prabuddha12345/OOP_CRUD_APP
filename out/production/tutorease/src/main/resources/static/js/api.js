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
  }
};

// ---- GENERIC HELPERS ----

async function apiGet(path) {
  const res = await fetch(API_CONFIG.BASE_URL + path);
  if (!res.ok) throw new Error(`GET ${path} failed: ${res.status}`);
  return res.json();
}

async function apiPost(path, body) {
  const res = await fetch(API_CONFIG.BASE_URL + path, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  if (!res.ok) throw new Error(`POST ${path} failed: ${res.status}`);
  return res.json();
}

async function apiPut(path, body) {
  const res = await fetch(API_CONFIG.BASE_URL + path, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  if (!res.ok) throw new Error(`PUT ${path} failed: ${res.status}`);
  return res.json();
}

async function apiDelete(path) {
  const res = await fetch(API_CONFIG.BASE_URL + path, { method: "DELETE" });
  if (!res.ok) throw new Error(`DELETE ${path} failed: ${res.status}`);
  return true;
}
