<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Bookings — TutorEase</title>
  <jsp:include page="header.jsp"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&family=Nunito:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
</head>
<body>

  <nav class="navbar">
    <!-- Content injected by js/auth.js -->
  </nav>

  <div class="inner-page">
    <div class="inner-header">
      <div>
        <h1>My Bookings</h1>
        <p>Track and manage all your tutoring sessions</p>
      </div>
      <div class="header-actions">
        <select id="status-filter" onchange="filterBookings()" class="status-select">
          <option value="">All Status</option>
          <option value="PENDING">Pending</option>
          <option value="CONFIRMED">Confirmed</option>
          <option value="COMPLETED">Completed</option>
          <option value="CANCELLED">Cancelled</option>
        </select>
        <button class="btn btn-outline" onclick="loadBookings()">🔄 Refresh</button>
      </div>
    </div>

    <!-- STATS ROW -->
    <div class="booking-stats">
      <div class="bstat">
        <div class="bstat-num" id="bs-total">--</div>
        <div class="bstat-label">Total Bookings</div>
      </div>
      <div class="bstat">
        <div class="bstat-num pending" id="bs-pending">--</div>
        <div class="bstat-label">Pending</div>
      </div>
      <div class="bstat">
        <div class="bstat-num confirmed" id="bs-confirmed">--</div>
        <div class="bstat-label">Confirmed</div>
      </div>
      <div class="bstat">
        <div class="bstat-num completed" id="bs-completed">--</div>
        <div class="bstat-label">Completed</div>
      </div>
    </div>

    <!-- BOOKINGS TABLE -->
    <div class="card table-card">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Student</th>
              <th>Tutor</th>
              <th>Subject</th>
              <th>Date & Time</th>
              <th>Address</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="bookings-tbody">
            <tr><td colspan="8" class="empty">Loading bookings...</td></tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- REVIEWS SECTION -->
    <div class="inner-header" style="margin-top: 60px;">
      <div>
        <h1>My Reviews</h1>
        <p>Your feedback on tutors you've studied with</p>
      </div>
    </div>
    
    <div class="card table-card">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Tutor</th>
              <th>Rating</th>
              <th>Comment</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="student-reviews-tbody">
            <tr><td colspan="4" class="empty">No reviews left yet.</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- UPDATE STATUS MODAL -->
  <div class="modal-overlay" id="status-modal" style="display:none">
    <div class="modal modal-sm">
      <h3>Update Booking Status</h3>
      <input type="hidden" id="update-booking-id"/>
      <div class="field-group">
        <label>New Status</label>
        <select id="new-status">
          <option value="PENDING">Pending</option>
          <option value="CONFIRMED">Confirmed</option>
          <option value="COMPLETED">Completed</option>
          <option value="CANCELLED">Cancelled</option>
        </select>
      </div>
      <div class="modal-btns" style="margin-top:20px">
        <button class="btn btn-primary" onclick="updateBookingStatus()">Update</button>
        <button class="btn btn-outline" onclick="closeModal('status-modal')">Cancel</button>
      </div>
    </div>
  </div>

  <!-- LEAVE REVIEW MODAL -->
  <div class="modal-overlay" id="review-modal" style="display:none">
    <div class="modal modal-sm">
      <h3>Leave a Review</h3>
      <input type="hidden" id="r-tutor-id"/>
      <div class="field-group">
        <label>Rating (1-5)</label>
        <select id="r-rating">
          <option value="5">5 - Excellent</option>
          <option value="4">4 - Very Good</option>
          <option value="3">3 - Good</option>
          <option value="2">2 - Fair</option>
          <option value="1">1 - Poor</option>
        </select>
      </div>
      <div class="field-group">
        <label>Comment</label>
        <textarea id="r-comment" rows="3" placeholder="How was your session?"></textarea>
      </div>
      <div id="review-msg" style="margin-bottom: 16px; font-size: 0.9rem;"></div>
      <div class="modal-btns" style="margin-top:20px">
        <button class="btn btn-primary" onclick="submitReview()">Submit</button>
        <button class="btn btn-outline" onclick="closeModal('review-modal')">Cancel</button>
      </div>
    </div>
  </div>

  <!-- PAYMENT MODAL -->
  <div class="modal-overlay" id="payment-modal" style="display:none">
    <div class="modal modal-sm">
      <h3>Make Payment</h3>
      <input type="hidden" id="p-booking-id"/>
      <input type="hidden" id="p-tutor-id"/>
      <div class="field-group">
        <label>Tutor</label>
        <p id="p-tutor-name" style="font-weight: 600; color: var(--primary); margin: 0;"></p>
      </div>
      <div class="field-group">
        <label>Session Details</label>
        <p id="p-details" style="font-size: 0.9rem; color: var(--muted); margin: 0;"></p>
      </div>
      <div class="field-group">
        <label>Amount (LKR)</label>
        <input type="text" id="p-amount" disabled style="background-color: #f1f5f9; cursor: not-allowed; color: #64748b; font-weight: 600;"/>
      </div>
      <div class="field-group">
        <label>Payment Method</label>
        <select id="p-method">
          <option value="CARD">Credit / Debit Card</option>
          <option value="CASH">Cash</option>
          <option value="OTHER">Other</option>
        </select>
      </div>
      <div id="payment-msg" style="margin-bottom: 16px; font-size: 0.9rem;"></div>
      <div class="modal-btns" style="margin-top:20px">
        <button class="btn btn-primary" id="p-submit-btn" onclick="submitPayment()">Confirm Payment</button>
        <button class="btn btn-outline" onclick="closeModal('payment-modal')">Cancel</button>
      </div>
    </div>
  </div>

  <footer class="footer">
    <div class="footer-content">
      <div class="footer-info">
        <div class="footer-logo">Tutor<span>Ease</span></div>
        <p>Connecting students with expert tutors across Sri Lanka. Quality education, personalized for you.</p>
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
      <div class="footer-copy">&copy; 2024 TutorEase Platform. All rights reserved.</div>
    </div>
  </footer>

  
  
  
  <script>
    document.addEventListener("DOMContentLoaded", () => {
      loadBookings();
      if (typeof loadStudentReviews === 'function') loadStudentReviews();
    });
  </script>
</body>
</html>


