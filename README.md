# 🎓 TutorEase — Premium Home Tutoring Search, Booking & CRUD Management System
**A sleek, responsive, and robust full-stack platform for connecting students with expert tutors.**

---

## 🌟 Key Features
- **🔑 Role-Based Authentication & Registry**: Dynamic sign-up and login workflows for **Students**, **Tutors**, and **Admins** with secure token simulation.
- **📁 Comprehensive CRUD Modules**:
  - **Tutors**: Profile creation, subject offerings, grade level coverage, experience tracking, and biological details.
  - **Students**: Dynamic directory, registration profile, details, and active status.
  - **Bookings**: Student-to-tutor appointment scheduling, time/date/address inputs, and status tracking (`PENDING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`).
  - **Reviews & Ratings**: Student-submitted ratings and detailed reviews for tutors with permanent delete-cascading.
  - **Payments**: Integrated payment portal enabling students to settle fees for pending or confirmed bookings safely.
- **🎨 Premium UI/UX Design**: Sleek glassmorphism style sheet, smooth transitions, harmonized status badges, and interactive dashboard analy## 📁 Project Structure

```
tutorease/
├── pom.xml                    ← Maven Dependencies & Plugins
├── README.md                  ← Comprehensive platform documentation
└── src/main/
    ├── java/com/tutorease/
    │   ├── TutorApiApplication.java    ← Spring Boot Core Bootstrapper
    │   ├── controller/
    │   │   ├── AuthController.java     ← Credentials & Session controller
    │   │   ├── BookingController.java  ← Appointment booking coordinator
    │   │   ├── PageController.java     ← Dynamic Page JSP Router
    │   │   ├── PaymentController.java  ← Transaction processing API
    │   │   ├── ReviewController.java   ← Reviews, scores, & ratings API
    │   │   ├── StudentController.java  ← Student profiles manager
    │   │   └── TutorController.java    ← Tutor registries coordinator
    │   ├── model/
    │   │   ├── Booking.java            ← JPA Entity for appointments
    │   │   ├── Payment.java            ← JPA Entity for payment records
    │   │   ├── Review.java             ← JPA Entity for reviews & ratings
    │   │   ├── Student.java            ← JPA Entity for student details
    │   │   └── Tutor.java              ← JPA Entity for professional tutors
    │   ├── repository/
    │   │   ├── BookingRepository.java
    │   │   ├── PaymentRepository.java
    │   │   ├── ReviewRepository.java
    │   │   ├── StudentRepository.java
    │   │   └── TutorRepository.java
    │   └── util/
    │       └── CrudLogger.java         ← Global database transaction logging
    ├── resources/
    │   └── application.properties      ← Datasource & JPA configuration (runs on port 8081)
    └── webapp/
        └── WEB-INF/
            ├── web.xml                 ← Servlet web deployment settings
            └── jsp/                    ← Integrated Dynamic Web Views
                ├── about.jsp
                ├── admin.jsp
                ├── bookings.jsp
                ├── contact.jsp
                ├── header.jsp          ← Shared navigation, styling & custom components
                ├── index.jsp           ← Main Landing Page (with premium search widget)
                ├── login.jsp
                ├── privacy.jsp
                ├── profile.jsp
                ├── register-student.jsp
                ├── register-tutor.jsp
                ├── teacher-dashboard.jsp
                └── tutors.jsp
```

---

## ⚡ Unified Execution — Build & Run

TutorEase is a fully unified enterprise Spring Boot web application. You do NOT need separate frontend servers or Live Server extensions. The JSPs compile dynamically under Tomcat.

### Step 1: System Configurations (`application.properties`)
Configure `src/main/resources/application.properties` to connect to your local MySQL database:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/tutorease_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
server.port=8081
```

### Step 2: Build & Start the Web Application
Open the root `tutorease` folder in IntelliJ IDEA or your terminal and run:

```bash
mvn spring-boot:run
```

Once started, the application compiles the JSPs and boots Tomcat.
Open your browser and navigate to:
👉 **[http://localhost:8081](http://localhost:8081)**


## 🗄️ STEP 3 — MySQL Database Schema Setup

Database tables are automatically initialized and updated by Hibernate using `ddl-auto=update`. If you wish to manually query or verify the table definitions in MySQL Workbench, use the following schema:

```sql
CREATE DATABASE IF NOT EXISTS tutorease_db;
USE tutorease_db;

-- Tutor Table
CREATE TABLE tutor (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(150) NOT NULL UNIQUE,
  phone        VARCHAR(20)  NOT NULL,
  location     VARCHAR(150) NOT NULL,
  subject      VARCHAR(100) NOT NULL,
  grade_level  VARCHAR(50)  NOT NULL,
  hourly_rate  DECIMAL(10,2) DEFAULT 0.0,
  experience   INT DEFAULT 0,
  bio          TEXT
);

-- Student Table
CREATE TABLE student (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(150) NOT NULL UNIQUE,
  phone        VARCHAR(20)  NOT NULL,
  grade_level  VARCHAR(50)  NOT NULL,
  location     VARCHAR(150) NOT NULL
);

-- Booking Table
CREATE TABLE booking (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  tutor_id     BIGINT       NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  phone        VARCHAR(20)  NOT NULL,
  session_date VARCHAR(50)  NOT NULL,
  session_time VARCHAR(50)  NOT NULL,
  address      VARCHAR(255) NOT NULL,
  notes        TEXT,
  status       VARCHAR(50) DEFAULT 'PENDING',
  tutor_name   VARCHAR(100),
  subject      VARCHAR(100),
  FOREIGN KEY (tutor_id) REFERENCES tutor(id) ON DELETE CASCADE
);

-- Review Table
CREATE TABLE review (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  tutor_id     BIGINT NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  rating       INT NOT NULL,
  comment      TEXT,
  FOREIGN KEY (tutor_id) REFERENCES tutor(id) ON DELETE CASCADE
);

-- Payment Table
CREATE TABLE payment (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  booking_id   BIGINT NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  tutor_name   VARCHAR(100) NOT NULL,
  amount       DECIMAL(10,2) NOT NULL,
  payment_date VARCHAR(50) NOT NULL,
  card_number  VARCHAR(20) NOT NULL,
  status       VARCHAR(50) NOT NULL
);
```

---

## 🔧 STEP 4 — Java OOP REST APIs Reference

### 📁 1. Models & Entities
All data is handled securely as robust Java entities inside `com.tutorease.model`:
- **`Tutor.java`**: Fields include name, hourlyRate, experience, subject, and gradeLevel.
- **`Student.java`**: Fields include name, gradeLevel, phone, and location.
- **`Booking.java`**: Manages tutor associations, date, time, and session status.
- **`Review.java`**: Stores tutor ratings ($1-5$ stars) and comments.
- **`Payment.java`**: Records amount, booking mapping, date, and processing state.

### 📁 2. Repository Layer
Inherited from standard `JpaRepository` to perform lightning-fast Hibernate SQL actions:
- `TutorRepository`: Features search filters for subject, location, and grade level.
- `StudentRepository`: Direct profile checks and authentication hooks.
- `BookingRepository`: Filters active lists by status or specific tutor keys.
- `ReviewRepository`: Allows fetching rating lists belonging to individual instructors.
- `PaymentRepository`: Tracks individual transaction audits.

### 📁 3. Controller Layer (CRUD Routes)

| Component | Method | API Endpoint | Description |
|-----------|--------|--------------|-------------|
| **Auth** | `POST` | `/api/auth/login` | Validates session credentials and assigns roles. |
| **Tutors** | `GET` | `/api/tutors` | Retrieves the list of all active instructors. |
| **Tutors** | `POST` | `/api/tutors` | Adds a new tutor registry to the system. |
| **Tutors** | `PUT` | `/api/tutors/{id}` | Updates profile details (experience, rates). |
| **Tutors** | `DELETE`| `/api/tutors/{id}` | Deletes a tutor profile permanently. |
| **Students**| `GET` | `/api/students` | Gets all registered students' lists. |
| **Students**| `POST` | `/api/students` | Registers a new student profile. |
| **Bookings**| `GET` | `/api/bookings` | Fetches appointment logs. |
| **Bookings**| `POST` | `/api/bookings` | Submits a new booking request. |
| **Bookings**| `PUT` | `/api/bookings/{id}/status`| Alters booking status (`CONFIRMED`, `COMPLETED`, `CANCELLED`). |
| **Bookings**| `DELETE`| `/api/bookings/{id}` | Removes a scheduled booking. |
| **Reviews** | `GET` | `/api/reviews/tutor/{tutorId}`| Fetches ratings/feedback history for a tutor. |
| **Reviews** | `POST` | `/api/reviews` | Submits a tutor review & score. |
| **Reviews** | `DELETE`| `/api/reviews/{id}` | Safely deletes tutor review. |
| **Payments**| `POST` | `/api/payments` | Records card payments & updates booking state. |

---

## ▶️ STEP 5 — Run Everything

1. **MySQL Server**: Ensure MySQL local service is started.
2. **Spring Boot (IntelliJ)**: Run `TutorApiApplication.java` (Click the green play button ▶).
3. **Frontend (VS Code)**: Open `index.html` using the **Live Server** extension.
4. Access the gorgeous app dashboard in your browser: **`http://127.0.0.1:5500`**! 🎉

---

## 🐛 Common Problems & Quick Fixes

| Problem | Explanation | Resolution |
|---------|-------------|------------|
| **"Backend: Offline" badge** | The frontend can't fetch data from the Spring API. | Verify that your backend application is actively running on port `8080`. |
| **CORS Policy Blocking** | The browser blocks cross-origin requests. | Ensure all controllers in the Java layer have `@CrossOrigin(origins = "*")`. |
| **MySQL Connection Denied** | Spring Boot cannot query database tables. | Verify database credentials match inside `application.properties` and start local MySQL service. |
| **Port 8080 is in use** | A local port conflict exists. | Edit `server.port=8081` in your properties, and update `BASE_URL` in `js/api.js`. |
