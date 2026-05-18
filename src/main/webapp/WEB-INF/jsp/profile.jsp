<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Profile — TutorEase</title>
  <jsp:include page="header.jsp"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&family=Nunito:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    .profile-grid {
      display: grid;
      grid-template-columns: 320px 1fr;
      gap: 32px;
      margin-top: 32px;
    }
    
    @media (max-width: 992px) {
      .profile-grid {
        grid-template-columns: 1fr;
      }
    }
    
    .profile-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 32px;
      text-align: center;
      box-shadow: var(--shadow);
      height: fit-content;
      position: sticky;
      top: 120px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
    }
    
    .profile-avatar-display {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      background: var(--accent-light);
      border: 4px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 4rem;
      color: var(--accent);
      box-shadow: var(--shadow-md);
      transition: transform 0.3s;
      overflow: hidden;
    }
    .profile-avatar-display img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    
    .profile-avatar-display:hover {
      transform: scale(1.05) rotate(5deg);
    }
    
    .profile-card h3 {
      font-family: var(--font-head);
      font-size: 1.5rem;
      font-weight: 800;
      color: var(--text);
      margin-top: 8px;
    }
    
    .grade-badge {
      background: var(--accent-light);
      color: var(--accent);
      padding: 6px 16px;
      border-radius: 99px;
      font-weight: 700;
      font-size: 0.85rem;
      border: 1px solid var(--accent);
    }
    
    .avatar-selection-title {
      font-size: 0.75rem;
      font-weight: 800;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-top: 16px;
    }
    
    .avatar-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      width: 100%;
    }
    
    .avatar-option {
      background: var(--surface2);
      border: 2px solid transparent;
      border-radius: 12px;
      font-size: 2rem;
      padding: 10px;
      cursor: pointer;
      transition: all 0.2s;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .avatar-option:hover {
      background: var(--accent-light);
      transform: scale(1.1);
    }
    
    .avatar-option.active {
      border-color: var(--accent);
      background: var(--accent-light);
      box-shadow: var(--shadow-sm);
    }
    
    .profile-main-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 40px;
      box-shadow: var(--shadow);
      display: flex;
      flex-direction: column;
      gap: 32px;
    }
    
    .profile-main-card h2 {
      font-family: var(--font-head);
      font-size: 2rem;
      font-weight: 800;
    }
    
    .section-subtitle {
      font-size: 0.95rem;
      color: var(--muted);
      margin-top: -24px;
      margin-bottom: 8px;
    }
    
    .form-msg-box {
      display: none;
      padding: 16px 20px;
      border-radius: 12px;
      font-weight: 600;
      font-size: 0.95rem;
      margin-bottom: 8px;
      animation: slideIn 0.3s ease;
    }
    
    @keyframes slideIn {
      from { transform: translateY(-10px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    
    .form-msg-box.success {
      background: #e6f7f0;
      color: #1b6844;
      border: 1px solid #99e2bf;
    }
    
    .form-msg-box.error {
      background: #fff3f3;
      color: #b83232;
      border: 1px solid #ffa3a3;
    }
    
    .required-star {
      color: var(--danger);
      font-weight: bold;
      margin-left: 2px;
    }
    
    .collapsible-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      background: var(--surface2);
      padding: 16px 24px;
      border-radius: 12px;
      border: 1px solid var(--border);
      transition: all 0.3s;
      user-select: none;
    }
    
    .collapsible-header:hover {
      border-color: var(--accent);
      background: var(--accent-light);
    }
    
    .collapsible-header h4 {
      font-family: var(--font-body);
      font-size: 1.05rem;
      font-weight: 700;
      color: var(--text);
    }
    
    .collapsible-header span {
      font-size: 1.2rem;
      transition: transform 0.3s;
    }
    
    .collapsible-header.active span {
      transform: rotate(180deg);
    }
    
    .collapsible-content {
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.3s ease-out, padding 0.3s;
      padding: 0 24px;
    }
    
    .collapsible-content.active {
      max-height: 500px;
      padding: 24px;
      border: 1px solid var(--border);
      border-top: none;
      border-bottom-left-radius: 12px;
      border-bottom-right-radius: 12px;
    }
    
    .collapsible-header.active {
      border-bottom-left-radius: 0;
      border-bottom-right-radius: 0;
    }
  </style>
</head>
<body>

  <nav class="navbar">
    <!-- Content injected by js/auth.js -->
  </nav>

  <div class="inner-page">
    <div class="inner-header">
      <div>
        <h1>My Profile</h1>
        <p>Manage your account configurations and credentials</p>
      </div>
    </div>

    <!-- NOTIFICATION BOX -->
    <div class="form-msg-box" id="profile-msg"></div>

    <div class="profile-grid">
      <!-- LEFT PROFILE CARD -->
      <div class="profile-card">
        <div class="profile-avatar-display" id="avatar-container">
          🎓
        </div>
        <div>
          <h3 id="sidebar-name">Loading...</h3>
          <p id="sidebar-username" style="color: var(--muted); font-size: 0.9rem; font-weight: 500;"></p>
        </div>
        <div class="grade-badge" id="sidebar-grade">-- Grade</div>
        
        <div class="avatar-selection-title">Choose an Avatar</div>
        <div class="avatar-grid">
          <div class="avatar-option active" onclick="selectEmojiAvatar('🎓')">🎓</div>
          <div class="avatar-option" onclick="selectEmojiAvatar('🧑‍🎓')">🧑‍🎓</div>
          <div class="avatar-option" onclick="selectEmojiAvatar('🧑‍💻')">🧑‍💻</div>
          <div class="avatar-option" onclick="selectEmojiAvatar('🎨')">🎨</div>
          <div class="avatar-option" onclick="selectEmojiAvatar('🚀')">🚀</div>
          <div class="avatar-option" onclick="selectEmojiAvatar('🌟')">🌟</div>
        </div>
        
        <div style="width: 100%; margin-top: 8px;">
          <div class="field-group" style="margin-bottom: 0;">
            <label style="font-size: 0.75rem;">Or Custom Image URL</label>
            <input type="text" id="p-avatar-url" placeholder="https://example.com/pic.png" style="padding: 10px; font-size: 0.85rem;" oninput="selectCustomAvatar(this.value)"/>
          </div>
        </div>
      </div>

      <!-- RIGHT FORM -->
      <div class="profile-main-card">
        <h2>Personal Details</h2>
        <div class="section-subtitle">Keep your contact information up-to-date</div>
        
        <div class="modal-form">
          <div class="form-row-2">
            <div class="field-group">
              <label>Full Name <span class="required-star">*</span></label>
              <input type="text" id="p-name" placeholder="John Doe" required/>
            </div>
            <div class="field-group">
              <label>Grade Level</label>
              <select id="p-grade">
                <option value="">Select Grade</option>
                <option value="Grade 1">Grade 1</option>
                <option value="Grade 2">Grade 2</option>
                <option value="Grade 3">Grade 3</option>
                <option value="Grade 4">Grade 4</option>
                <option value="Grade 5">Grade 5</option>
                <option value="Grade 6">Grade 6</option>
                <option value="Grade 7">Grade 7</option>
                <option value="Grade 8">Grade 8</option>
                <option value="Grade 9">Grade 9</option>
                <option value="Grade 10">Grade 10</option>
                <option value="Grade 11 (O/L)">Grade 11 (O/L)</option>
                <option value="Grade 12 (A/L)">Grade 12 (A/L)</option>
                <option value="Grade 13 (A/L)">Grade 13 (A/L)</option>
                <option value="University / Higher Ed">University / Higher Ed</option>
              </select>
            </div>
          </div>

          <div class="form-row-2">
            <div class="field-group">
              <label>Email Address <span class="required-star">*</span></label>
              <input type="email" id="p-email" placeholder="student@example.com" required/>
            </div>
            <div class="field-group">
              <label>Phone Number <span class="required-star">*</span></label>
              <input type="text" id="p-phone" placeholder="e.g. 0771234567" required/>
            </div>
          </div>

          <div class="field-group">
            <label>Residential Address</label>
            <textarea id="p-address" rows="3" placeholder="Enter your full home address"></textarea>
          </div>

          <!-- COLLAPSIBLE SECURE PASSWORD MANAGER -->
          <div style="margin-top: 16px;">
            <div class="collapsible-header" id="pwd-header" onclick="togglePasswordPanel()">
              <h4>🛡️ Security & Password Configuration</h4>
              <span id="pwd-caret">▼</span>
            </div>
            <div class="collapsible-content" id="pwd-content">
              <div class="field-group">
                <label>Current Password <span class="required-star">* (To authorize password change)</span></label>
                <input type="password" id="p-curr-password" placeholder="Verify current password"/>
              </div>
              <div class="form-row-2" style="margin-top: 16px;">
                <div class="field-group">
                  <label>New Password</label>
                  <input type="password" id="p-new-password" placeholder="Create a new password"/>
                </div>
                <div class="field-group">
                  <label>Confirm New Password</label>
                  <input type="password" id="p-conf-password" placeholder="Re-type new password"/>
                </div>
              </div>
            </div>
          </div>

          <div class="modal-btns" style="margin-top: 32px; border-top: 1px solid var(--border); padding-top: 24px;">
            <button class="btn btn-primary" id="save-btn" onclick="saveProfile()" style="min-width: 160px; height: 50px;">
              💾 Save Profile
            </button>
            <button class="btn btn-outline" onclick="loadStudentProfile()">
              🔄 Discard Changes
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <footer class="footer" style="margin-top: 80px;">
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
    let activeStudent = null;
    let selectedAvatarValue = "🎓";
    let isEmojiAvatar = true;

    document.addEventListener("DOMContentLoaded", () => {
      loadStudentProfile();
    });

    // Toggle secure password card
    function togglePasswordPanel() {
      const header = document.getElementById("pwd-header");
      const content = document.getElementById("pwd-content");
      header.classList.toggle("active");
      content.classList.toggle("active");
    }

    // Dynamic avatar loaders
    function selectEmojiAvatar(emoji) {
      isEmojiAvatar = true;
      selectedAvatarValue = emoji;
      
      // Clear custom text field
      document.getElementById("p-avatar-url").value = "";
      
      // Highlight selected option
      document.querySelectorAll(".avatar-option").forEach(opt => {
        opt.classList.remove("active");
        if (opt.textContent === emoji) opt.classList.add("active");
      });
      
      // Load display
      const container = document.getElementById("avatar-container");
      container.innerHTML = emoji;
    }

    function selectCustomAvatar(url) {
      if (!url.trim()) {
        // Revert to first emoji if cleared
        selectEmojiAvatar("🎓");
        return;
      }
      isEmojiAvatar = false;
      selectedAvatarValue = url.trim();
      
      // Remove all emoji highlights
      document.querySelectorAll(".avatar-option").forEach(opt => opt.classList.remove("active"));
      
      // Load image display with standard fail-safe checks
      const container = document.getElementById("avatar-container");
      container.innerHTML = `<img src="${url.trim()}" alt="Profile Avatar" onerror="handleImageError(this)"/>`;
    }

    function handleImageError(img) {
      img.onerror = null;
      // If image loading fails, display a generic symbol rather than broken UI
      img.parentElement.innerHTML = "👤";
    }

    // API Dynamic Fetching
    async function loadStudentProfile() {
      const user = getCurrentUser();
      if (!user || user.role !== "student") {
        window.location.href = "/login";
        return;
      }

      showMessage("", "");

      try {
        let student = null;
        if (user.id) {
          try {
            student = await apiGet(`/students/${user.id}`);
          } catch (e) {
            console.warn("Fetch by user.id failed, trying fallback by username");
          }
        }

        if (!student) {
          // Fallback: Fetch all students and find matching username
          const allStudents = await apiGet("/students");
          student = allStudents.find(s => s.username.toLowerCase() === user.username.toLowerCase());
          if (student) {
            // Update localStorage session to store ID permanently
            user.id = student.id;
            localStorage.setItem(AUTH_KEY, JSON.stringify(user));
          }
        }

        if (!student) {
          throw new Error("Student profile not found.");
        }

        activeStudent = student;

        // Load fields
        document.getElementById("p-name").value = student.name || "";
        document.getElementById("p-email").value = student.email || "";
        document.getElementById("p-phone").value = student.phone || "";
        document.getElementById("p-address").value = student.address || "";
        document.getElementById("p-grade").value = student.gradeLevel || "";

        // Reset password fields
        document.getElementById("p-curr-password").value = "";
        document.getElementById("p-new-password").value = "";
        document.getElementById("p-conf-password").value = "";

        // Sidebar indicators
        document.getElementById("sidebar-name").textContent = student.name || user.username;
        document.getElementById("sidebar-username").textContent = `@${student.username}`;
        document.getElementById("sidebar-grade").textContent = student.gradeLevel || "Grade Undefined";

        // Render profile picture
        if (student.profilePicture) {
          const isUrl = student.profilePicture.startsWith("http://") || 
                        student.profilePicture.startsWith("https://") || 
                        student.profilePicture.startsWith("data:image");
          if (isUrl) {
            document.getElementById("p-avatar-url").value = student.profilePicture;
            selectCustomAvatar(student.profilePicture);
          } else {
            selectEmojiAvatar(student.profilePicture);
          }
        } else {
          selectEmojiAvatar("🎓");
        }

      } catch (error) {
        console.error("Failed to load profile:", error);
        showMessage("Failed to load profile details from backend.", "error");
      } finally {
        showSpinner(false);
      }
    }

    // Save and PUT Update mapping
    async function saveProfile() {
      if (!activeStudent) return;

      const name = document.getElementById("p-name").value.trim();
      const email = document.getElementById("p-email").value.trim();
      const phone = document.getElementById("p-phone").value.trim();
      const address = document.getElementById("p-address").value.trim();
      const gradeLevel = document.getElementById("p-grade").value;

      const currPassword = document.getElementById("p-curr-password").value;
      const newPassword = document.getElementById("p-new-password").value;
      const confPassword = document.getElementById("p-conf-password").value;

      // Clean validations
      if (!name || !email || !phone) {
        showMessage("Please fill in all required fields (Name, Email, Phone Number).", "error");
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
      }

      // Email regex
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        showMessage("Please enter a valid email address.", "error");
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return;
      }

      // Password changes checks
      let updatedPassword = null;
      if (currPassword || newPassword || confPassword) {
        if (!currPassword) {
          showMessage("You must input your current password to authorize a password change.", "error");
          window.scrollTo({ top: 0, behavior: 'smooth' });
          return;
        }
        
        // Match current password
        if (currPassword !== activeStudent.password) {
          showMessage("Invalid current password. Changes unauthorized.", "error");
          window.scrollTo({ top: 0, behavior: 'smooth' });
          return;
        }

        if (!newPassword) {
          showMessage("Please choose a new password.", "error");
          window.scrollTo({ top: 0, behavior: 'smooth' });
          return;
        }

        if (newPassword !== confPassword) {
          showMessage("New password and confirm password fields do not match.", "error");
          window.scrollTo({ top: 0, behavior: 'smooth' });
          return;
        }

        updatedPassword = newPassword;
      }

      showSpinner(true);
      showMessage("Saving changes...", "");

      const updatePayload = {
        name,
        email,
        phone,
        address,
        gradeLevel,
        profilePicture: selectedAvatarValue
      };

      if (updatedPassword) {
        updatePayload.password = updatedPassword;
      }

      try {
        const response = await apiPut(`/students/${activeStudent.id}`, updatePayload);
        if (response && response.id) {
          
          // Sync localStorage session display immediately
          const user = getCurrentUser();
          localStorage.setItem("tutorease_user", JSON.stringify({
            username: user.username,
            role: user.role,
            id: user.id
          }));

          // Trigger dynamic update reload
          await loadStudentProfile();
          updateNavbar(); // Refresh dynamically computed logout name

          showMessage("Your student profile has been updated successfully!", "success");
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }
      } catch (error) {
        console.error("Failed to update profile:", error);
        showMessage("An error occurred while saving your changes.", "error");
        window.scrollTo({ top: 0, behavior: 'smooth' });
      } finally {
        showSpinner(false);
      }
    }

    // Helper alerts UI manager
    function showMessage(text, type) {
      const box = document.getElementById("profile-msg");
      if (!text) {
        box.style.display = "none";
        return;
      }
      box.textContent = text;
      box.className = `form-msg-box ${type}`;
      box.style.display = "block";
    }

    function showSpinner(show) {
      const btn = document.getElementById("save-btn");
      if (show) {
        btn.disabled = true;
        btn.innerHTML = `⏳ Saving...`;
      } else {
        btn.disabled = false;
        btn.innerHTML = `💾 Save Profile`;
      }
    }
  </script>
</body>
</html>


