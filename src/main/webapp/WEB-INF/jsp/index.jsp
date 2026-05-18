<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>TutorEase — Find Your Perfect Tutor</title>
  <jsp:include page="header.jsp"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&family=Nunito:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
</head>
<body>

  <!-- NAV -->
  <nav class="navbar">
    <!-- Content injected by js/auth.js -->
  </nav>

  <!-- HERO -->
  <section class="hero">
    <div class="hero-content">
      <div class="hero-tag">🎓 Sri Lanka's #1 Tutoring Platform</div>
      <h1>Find the <em>Perfect Tutor</em> for your child's future</h1>
      <p>Connect with verified home tutors. Search by subject, grade, and location to book your first session instantly.</p>

      <!-- INTEGRATED SEARCH WIDGET -->
      <div class="search-container">
        <div class="search-box">
          <div class="search-field">
            <label>Subject</label>
            <select id="s-subject">
              <option value="">All Subjects</option>
              <option>Mathematics</option>
              <option>Science</option>
              <option>English</option>
              <option>Physics</option>
              <option>Chemistry</option>
              <option>Biology</option>
              <option>ICT</option>
              <option>History</option>
            </select>
          </div>
          <div class="search-field">
            <label>Grade / Level</label>
            <select id="s-grade">
              <option value="">All Grades</option>
              <option>Grade 1–5</option>
              <option>Grade 6–9</option>
              <option>O/L (Grade 10–11)</option>
              <option>A/L (Grade 12–13)</option>
            </select>
          </div>
          <div class="search-field">
            <label>Location</label>
            <input type="text" id="s-location" placeholder="e.g. Colombo, Kandy..."/>
          </div>
          <button class="btn btn-search" onclick="searchTutors()">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <span>Search Tutors</span>
          </button>
        </div>
      </div>
    </div>
  </section>

  <!-- HOW IT WORKS -->
  <section class="section how zen-layout">
    <span class="section-label">Our Process</span>
    <h2 class="section-title">How it works</h2>
    <div class="steps">
      <div class="step">
        <span class="step-num">01.</span>
        <span class="step-icon">🔍</span>
        <h3>Discover Tutors</h3>
        <p>Browse our curated selection of verified tutors based on your specific needs and location.</p>
      </div>
      <div class="step">
        <span class="step-num">02.</span>
        <span class="step-icon">📅</span>
        <h3>Pick a Schedule</h3>
        <p>Choose a date and time that fits your lifestyle. Our tutors are flexible and come to you.</p>
      </div>
      <div class="step">
        <span class="step-num">03.</span>
        <span class="step-icon">✨</span>
        <h3>Start Learning</h3>
        <p>Confirm your booking and get ready for a premium learning experience at home.</p>
      </div>
    </div>
  </section>

  <!-- FEATURED TUTORS -->
  <section class="section featured">
    <span class="section-label">Top Rated</span>
    <h2 class="section-title">Featured Tutors</h2>
    <div class="tutor-grid" id="featured-grid">
      <!-- Loaded by JS -->
      <div class="loading-msg">Loading tutors from backend...</div>
    </div>
    <div style="margin-top: 64px">
      <button class="btn btn-outline" onclick="location.href='/tutors'">View All Tutors</button>
    </div>
  </section>

  <!-- FOOTER -->
  <footer class="footer">
    <div class="footer-content">
      <div>
        <div class="footer-logo">Tutor<span>Ease</span></div>
        <p>Elevating home education through professional, verified tutoring services across Sri Lanka.</p>
      </div>
      <div class="footer-links-col">
        <h4>Platform</h4>
        <div class="footer-links">
          <a href="/">Home</a>
          <a href="/tutors">Find Tutors</a>
          <a href="/register-tutor">Register as Tutor</a>
        </div>
      </div>
      <div class="footer-links-col">
        <h4>Support</h4>
        <div class="footer-links">
          <a href="/contact">Contact Us</a>
          <a href="/about">About Us</a>
          <a href="/privacy">Privacy Policy</a>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p class="footer-copy">© 2024 TutorEase. All rights reserved.</p>
      <div class="footer-links" style="flex-direction: row; gap: 24px;">
        <a href="#">Twitter</a>
        <a href="#">Instagram</a>
        <a href="#">LinkedIn</a>
      </div>
    </div>
  </footer>

  
  
  
  <script>
    loadFeaturedTutors();
  </script>
</body>
</html>


