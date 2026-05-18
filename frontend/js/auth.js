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
  const isProtected = window.location.pathname.includes("admin.html") || 
                      window.location.pathname.includes("bookings.html");
  
  if (isProtected) {
    window.location.href = window.location.pathname.includes("/pages/") ? "../index.html" : "index.html";
  } else {
    window.location.reload();
  }
}

function checkAuth(requiredRole) {
  const user = getCurrentUser();
  if (!user || user.role !== requiredRole) {
    const inPagesDir = window.location.pathname.includes("/pages/");
    window.location.href = inPagesDir ? "login.html" : "pages/login.html";
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
  const inPagesDir = window.location.pathname.includes("/pages/");
  const prefix = inPagesDir ? "" : "pages/";
  const homePrefix = inPagesDir ? "../" : "";

  // Logo structure (should already be in HTML, but we can ensure it's correct)
  let navHTML = `
    <a href="${homePrefix}index.html" class="nav-logo">Tutor<span>Ease</span></a>
    <div class="hamburger" onclick="toggleMobileMenu()">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <div class="nav-links">
      <a href="${homePrefix}index.html" id="nav-home">Home</a>
      <a href="${prefix}tutors.html" id="nav-tutors">Find Tutors</a>
  `;

  if (user) {
    if (user.role === "student") {
      navHTML += `
        <a href="${prefix}bookings.html" id="nav-bookings">My Bookings</a>
        <a href="${prefix}profile.html" id="nav-profile">My Profile</a>
      `;
    } else if (user.role === "tutor") {
      navHTML += `<a href="${prefix}teacher-dashboard.html" id="nav-teacher">Teacher Dashboard</a>`;
    } else if (user.role === "admin") {
      navHTML += `<a href="${prefix}admin.html" id="nav-admin">Admin Dashboard</a>`;
    }
    navHTML += `
      <a href="#" onclick="logout()">Logout (${user.username})</a>
    `;
  } else {
    navHTML += `
      <a href="${prefix}register-tutor.html" id="nav-become-tutor">Become a Tutor</a>
      <a href="${prefix}login.html" class="btn btn-primary" style="color: white; opacity: 1;">Sign In</a>
    `;
  }

  navHTML += `</div>`;
  navbar.innerHTML = navHTML;

  // Set active class
  const currentPath = window.location.pathname;
  if (currentPath.includes("index.html") || currentPath.endsWith("/")) {
    document.getElementById("nav-home")?.classList.add("active");
  } else if (currentPath.includes("tutors.html")) {
    document.getElementById("nav-tutors")?.classList.add("active");
  } else if (currentPath.includes("bookings.html")) {
    document.getElementById("nav-bookings")?.classList.add("active");
  } else if (currentPath.includes("profile.html")) {
    document.getElementById("nav-profile")?.classList.add("active");
  } else if (currentPath.includes("admin.html")) {
    document.getElementById("nav-admin")?.classList.add("active");
  } else if (currentPath.includes("teacher-dashboard.html")) {
    document.getElementById("nav-teacher")?.classList.add("active");
  } else if (currentPath.includes("register-tutor.html")) {
    document.getElementById("nav-become-tutor")?.classList.add("active");
  }
}

document.addEventListener("DOMContentLoaded", () => {
  updateNavbar();

  // Route Protection Logic
  const user = getCurrentUser();
  const currentPath = window.location.pathname;

  if (currentPath.includes("admin.html")) {
    if (!user || user.role !== "admin") {
      const inPagesDir = window.location.pathname.includes("/pages/");
      window.location.href = inPagesDir ? "login.html" : "pages/login.html";
    }
  }

  if (currentPath.includes("bookings.html") || currentPath.includes("profile.html")) {
    if (!user || user.role !== "student") {
      const inPagesDir = window.location.pathname.includes("/pages/");
      window.location.href = inPagesDir ? "login.html" : "pages/login.html";
    }
  }

  if (currentPath.includes("teacher-dashboard.html")) {
    if (!user || user.role !== "tutor") {
      const inPagesDir = window.location.pathname.includes("/pages/");
      window.location.href = inPagesDir ? "login.html" : "pages/login.html";
    }
  }
});
