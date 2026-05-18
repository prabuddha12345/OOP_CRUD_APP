<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard — TutorEase</title>
  <jsp:include page="header.jsp"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&family=Nunito:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
</head>
<body>

  <nav class="navbar" id="admin-nav-isolated">
    <a href="/admin" class="nav-logo">Tutor<span>Ease</span> <span style="font-size: 0.8rem; background: var(--accent); color: white; padding: 4px 8px; border-radius: 6px; margin-left: 8px; font-family: var(--font-body); font-weight: bold; vertical-align: middle;">Admin</span></a>
    <div class="nav-links">
      <a href="/admin" class="active" id="nav-admin">Admin Dashboard</a>
      <a href="#" onclick="logout()" style="opacity: 0.8; font-weight: 600; text-decoration: none; color: var(--text);">Logout (admin)</a>
    </div>
  </nav>

  <div class="inner-page">
    <div class="inner-header">
      <div>
        <h1>Admin Dashboard</h1>
        <p>Manage tutors, bookings and system data</p>
      </div>
    </div>

    <!-- OVERVIEW STATS -->
    <div class="admin-stats">
      <div class="astat-card">
        <div class="astat-icon">👨‍🏫</div>
        <div class="astat-num" id="a-tutors">--</div>
        <div class="astat-label">Total Tutors</div>
      </div>
      <div class="astat-card">
        <div class="astat-icon">📅</div>
        <div class="astat-num" id="a-bookings">--</div>
        <div class="astat-label">Total Bookings</div>
      </div>
      <div class="astat-card">
        <div class="astat-icon">⏳</div>
        <div class="astat-num" id="a-pending">--</div>
        <div class="astat-label">Pending Bookings</div>
      </div>
      <div class="astat-card">
        <div class="astat-icon">✅</div>
        <div class="astat-num" id="a-completed">--</div>
        <div class="astat-label">Completed Sessions</div>
      </div>
    </div>

    <!-- TABS -->
    <div class="tab-bar">
      <button class="tab active" onclick="switchTab('tutors-tab', this)">Manage Tutors</button>
      <button class="tab" onclick="switchTab('bookings-tab', this)">Manage Bookings</button>
      <button class="tab" onclick="switchTab('students-tab', this)">Manage Students</button>
      <button class="tab" onclick="switchTab('payments-tab', this)">Manage Payments</button>

    </div>

    <!-- TUTORS TAB -->
    <div id="tutors-tab" class="tab-content active">
      <div class="card table-card">
        <div class="table-top">
          <h3>All Tutors</h3>
          <button class="btn btn-primary" onclick="openAddTutorModal()">+ Add Tutor</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th><th>Name</th><th>Subject</th><th>Grade</th>
                <th>Location</th><th>Rate (LKR/hr)</th><th>Exp</th><th>Actions</th>
              </tr>
            </thead>
            <tbody id="admin-tutors-tbody">
              <tr><td colspan="8" class="empty">Loading...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- BOOKINGS TAB -->
    <div id="bookings-tab" class="tab-content">
      <div class="card table-card">
        <div class="table-top">
          <h3>All Bookings</h3>
          <button class="btn btn-outline" onclick="loadAdminData()">🔄 Refresh</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th><th>Student</th><th>Tutor</th><th>Date</th>
                <th>Address</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody id="admin-bookings-tbody">
              <tr><td colspan="7" class="empty">Loading...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- STUDENTS TAB -->
    <div id="students-tab" class="tab-content">
      <div class="card table-card">
        <div class="table-top">
          <h3>All Students</h3>
          <button class="btn btn-primary" onclick="openAddStudentModal()">+ Add Student</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th><th>Username</th><th>Name</th><th>Email</th>
                <th>Phone</th><th>Grade Level</th><th>Actions</th>
              </tr>
            </thead>
            <tbody id="admin-students-tbody">
              <tr><td colspan="7" class="empty">Loading...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- PAYMENTS TAB -->
    <div id="payments-tab" class="tab-content">
      <div class="card table-card">
        <div class="table-top">
          <h3>All Payments</h3>
          <button class="btn btn-outline" onclick="loadAdminData()">🔄 Refresh</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th><th>Student</th><th>Booking ID</th><th>Amount</th><th>Status</th>
              </tr>
            </thead>
            <tbody id="admin-payments-tbody">
              <tr><td colspan="5" class="empty">Loading...</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div>

  <!-- ADD TUTOR MODAL -->
  <div class="modal-overlay" id="add-tutor-modal" style="display:none">
    <div class="modal" style="max-width: 650px;">
      <h3>Add New Teacher</h3>
      
      <!-- Modal Error/Success Notification box -->
      <div id="tutor-msg" style="margin-bottom: 16px; font-weight: bold; text-align: center;"></div>
      
      <div class="modal-form">
        <div class="form-row-2">
          <div class="field-group">
            <label>Username <span style="color:var(--danger)">*</span></label>
            <input type="text" id="t-username" placeholder="Choose a username" required/>
          </div>
          <div class="field-group">
            <label>Password <span style="color:var(--danger)">*</span></label>
            <input type="password" id="t-password" placeholder="Create a password" required/>
          </div>
        </div>
        
        <div class="form-row-2">
          <div class="field-group">
            <label>Teacher Name <span style="color:var(--danger)">*</span></label>
            <input type="text" id="t-name" placeholder="John Doe" required/>
          </div>
          <div class="field-group">
            <label>Email Address <span style="color:var(--danger)">*</span></label>
            <input type="email" id="t-email" placeholder="teacher@example.com" required/>
          </div>
        </div>
        
        <div class="form-row-2">
          <div class="field-group">
            <label>Phone Number <span style="color:var(--danger)">*</span></label>
            <input type="text" id="t-phone" placeholder="Contact number" required/>
          </div>
          <div class="field-group">
            <label>Address / Location <span style="color:var(--danger)">*</span></label>
            <input type="text" id="t-location" placeholder="City or Full Address" required/>
          </div>
        </div>
        
        <div class="form-row-2">
          <div class="field-group">
            <label>Subject / Specialization <span style="color:var(--danger)">*</span></label>
            <select id="t-subject">
              <option value="Mathematics">Mathematics</option>
              <option value="Science">Science</option>
              <option value="English">English</option>
              <option value="Physics">Physics</option>
              <option value="Chemistry">Chemistry</option>
              <option value="Biology">Biology</option>
              <option value="ICT">ICT</option>
              <option value="History">History</option>
            </select>
          </div>
          <div class="field-group">
            <label>Grade Level</label>
            <select id="t-grade">
              <option value="Grade 1–5">Grade 1–5</option>
              <option value="Grade 6–9">Grade 6–9</option>
              <option value="O/L (Grade 10–11)">O/L (Grade 10–11)</option>
              <option value="A/L (Grade 12–13)">A/L (Grade 12–13)</option>
            </select>
          </div>
        </div>
        
        <div class="form-row-2">
          <div class="field-group">
            <label>Qualifications <span style="color:var(--danger)">*</span></label>
            <input type="text" id="t-qualifications" placeholder="e.g. BSc in Math, PGDE" required/>
          </div>
          <div class="field-group">
            <label>Experience (Years) <span style="color:var(--danger)">*</span></label>
            <input type="number" id="t-exp" min="0" placeholder="e.g. 5" required/>
          </div>
        </div>
        
        <div class="form-row-2">
          <div class="field-group">
            <label>Hourly Rate (LKR/hr) <span style="color:var(--danger)">*</span></label>
            <input type="number" id="t-rate" min="0" placeholder="Hourly teaching rate" required/>
          </div>
          <div class="field-group">
            <label>Biography / Bio</label>
            <input type="text" id="t-bio" placeholder="Brief professional intro"/>
          </div>
        </div>
      </div>
      
      <div class="modal-btns">
        <button class="btn btn-primary" onclick="addTutor()">Add Teacher</button>
        <button class="btn btn-outline" onclick="closeModal('add-tutor-modal')">Cancel</button>
      </div>
    </div>
  </div>

  <!-- EDIT TUTOR MODAL -->
  <div class="modal-overlay" id="edit-tutor-modal" style="display:none">
    <div class="modal" style="max-width: 650px;">
      <h3>Edit Tutor</h3>
      <input type="hidden" id="et-id"/>
      <div class="modal-form">
        <div class="form-row-2">
          <div class="field-group"><label>Name</label><input type="text" id="et-name"/></div>
          <div class="field-group"><label>Email</label><input type="email" id="et-email"/></div>
        </div>
        <div class="form-row-2">
          <div class="field-group"><label>Phone</label><input type="text" id="et-phone"/></div>
          <div class="field-group"><label>Location</label><input type="text" id="et-location"/></div>
        </div>
        <div class="form-row-2">
          <div class="field-group">
            <label>Subject</label>
            <select id="et-subject">
              <option>Mathematics</option><option>Science</option><option>English</option>
              <option>Physics</option><option>Chemistry</option><option>Biology</option>
              <option>ICT</option><option>History</option>
            </select>
          </div>
          <div class="field-group">
            <label>Grade</label>
            <select id="et-grade">
              <option>Grade 1–5</option><option>Grade 6–9</option>
              <option>O/L (Grade 10–11)</option><option>A/L (Grade 12–13)</option>
            </select>
          </div>
        </div>
        <div class="form-row-2">
          <div class="field-group"><label>Hourly Rate (LKR)</label><input type="number" id="et-rate"/></div>
          <div class="field-group"><label>Experience (years)</label><input type="number" id="et-exp"/></div>
        </div>
        <div class="form-row-2">
          <div class="field-group"><label>Qualifications</label><input type="text" id="et-qualifications" placeholder="Credentials"/></div>
          <div class="field-group"><label>Bio</label><textarea id="et-bio" rows="1" style="height:45px;"></textarea></div>
        </div>
      </div>
      <div class="modal-btns">
        <button class="btn btn-primary" onclick="updateTutor()">Save Changes</button>
        <button class="btn btn-outline" onclick="closeModal('edit-tutor-modal')">Cancel</button>
      </div>
    </div>
  </div>

  <!-- ADD/EDIT STUDENT MODAL -->
  <div class="modal-overlay" id="student-modal" style="display:none">
    <div class="modal">
      <h3 id="student-modal-title">Add/Edit Student</h3>
      <input type="hidden" id="es-id"/>
      <div class="modal-form">
        <div class="form-row-2">
          <div class="field-group"><label>Username</label><input type="text" id="es-username"/></div>
          <div class="field-group"><label>Password</label><input type="password" id="es-password" placeholder="Leave blank to keep current"/></div>
        </div>
        <div class="form-row-2">
          <div class="field-group"><label>Name</label><input type="text" id="es-name"/></div>
          <div class="field-group"><label>Email</label><input type="email" id="es-email"/></div>
        </div>
        <div class="form-row-2">
          <div class="field-group"><label>Phone</label><input type="text" id="es-phone"/></div>
          <div class="field-group"><label>Grade Level</label><input type="text" id="es-grade"/></div>
        </div>
      </div>
      <div class="modal-btns">
        <button class="btn btn-primary" onclick="saveStudent()">Save Changes</button>
        <button class="btn btn-outline" onclick="closeModal('student-modal')">Cancel</button>
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

  
  
  
  <script>
    loadAdminData();
    checkBackend();

    function switchTab(id, btn) {
      document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
      document.getElementById(id).classList.add('active');
      btn.classList.add('active');
    }
  </script>
</body>
</html>


