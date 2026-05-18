<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Student Registration — TutorEase</title>
  <jsp:include page="header.jsp"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,800;1,700;1,800&family=Nunito:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    .login-container {
      min-height: 80vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: var(--bg-alt);
      padding: 40px 20px;
    }
    .login-card {
      background: var(--surface);
      padding: 40px;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-md);
      width: 100%;
      max-width: 500px;
      text-align: center;
    }
    .login-card h2 {
      margin-bottom: 8px;
      font-family: var(--font-heading);
      color: var(--text-main);
    }
    .login-card p {
      color: var(--text-light);
      margin-bottom: 24px;
    }
    .login-form {
      text-align: left;
    }
    .form-msg {
      font-size: 14px;
      margin-bottom: 16px;
      text-align: center;
      display: none;
      padding: 10px;
      border-radius: 4px;
    }
    .form-msg.error {
      color: var(--danger);
      background-color: #ffeaea;
    }
    .form-msg.success {
      color: #155724;
      background-color: #d4edda;
    }
  </style>
</head>
<body>

  <nav class="navbar">
    <!-- Content injected by js/auth.js -->
  </nav>

  <div class="login-container">
    <div class="login-card">
      <h2>Create an Account</h2>
      <p>Register as a student to book tutors</p>

      <div class="form-msg" id="reg-msg"></div>

      <div class="login-form">
        <div class="field-group">
          <label>Username</label>
          <input type="text" id="r-username" placeholder="Choose a username" required/>
        </div>
        <div class="field-group">
          <label>Password</label>
          <input type="password" id="r-password" placeholder="Create a password" required/>
        </div>
        <div class="field-group">
          <label>Full Name</label>
          <input type="text" id="r-name" placeholder="John Doe" required/>
        </div>
        <div class="field-group">
          <label>Email Address</label>
          <input type="email" id="r-email" placeholder="student@example.com" required/>
        </div>
        <div class="field-group">
          <label>Phone Number</label>
          <input type="text" id="r-phone" placeholder="Contact number" required/>
        </div>
        
        <button class="btn btn-primary" style="width:100%; margin-top: 16px;" onclick="handleRegister()">Register</button>
      </div>
      <p style="margin-top:20px; font-size:14px;">
        Already have an account? <a href="/login" style="color:var(--primary); font-weight:bold;">Login here</a>
      </p>
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
    async function handleRegister() {
      const username = document.getElementById('r-username').value;
      const password = document.getElementById('r-password').value;
      const name = document.getElementById('r-name').value;
      const email = document.getElementById('r-email').value;
      const phone = document.getElementById('r-phone').value;
      const msgBox = document.getElementById('reg-msg');

      if (!username || !password || !name || !email) {
        msgBox.textContent = 'Please fill in all required fields.';
        msgBox.className = 'form-msg error';
        msgBox.style.display = 'block';
        return;
      }

      msgBox.textContent = 'Registering...';
      msgBox.className = 'form-msg';
      msgBox.style.display = 'block';

      try {
        const response = await apiPost(API_CONFIG.ENDPOINTS.register, {
          username, password, name, email, phone
        });
        
        if (response && response.id) {
          msgBox.textContent = 'Registration successful! You can now login.';
          msgBox.className = 'form-msg success';
          setTimeout(() => {
            window.location.href = '/login';
          }, 2000);
        }
      } catch (error) {
        console.error(error);
        msgBox.textContent = 'Registration failed. Username might already exist.';
        msgBox.className = 'form-msg error';
      }
    }
  </script>
</body>
</html>


