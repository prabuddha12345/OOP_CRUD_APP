# 🎓 TutorEase — Home Tutoring Search & Booking System
**Frontend: VS Code (HTML+CSS+JS) | Backend: IntelliJ (Java + Spring Boot) | DB: MySQL**

---

## 📁 Project Structure

```
tutorease/
├── frontend/                      ← Open in VS Code
│   ├── index.html                 ← Homepage (search tutors)
│   ├── css/style.css              ← All styling (edit here)
│   ├── js/
│   │   ├── api.js                 ← Backend URL config
│   │   └── app.js                 ← All CRUD logic
│   └── pages/
│       ├── tutors.html            ← Browse & filter tutors
│       ├── bookings.html          ← Manage bookings
│       └── admin.html             ← Admin dashboard
│
└── backend/                       ← Create your Spring Boot project here
    └── (Spring Boot project via IntelliJ)
```

---

## ⚡ STEP 1 — Open Frontend in VS Code

1. Install **VS Code**: https://code.visualstudio.com
2. Install **Live Server** extension:
   - Click Extensions icon → search "Live Server" → Install
3. **File > Open Folder** → select the `frontend/` folder
4. Right-click `index.html` → **"Open with Live Server"**
5. Site opens at: `http://127.0.0.1:5500`

> The site shows "Backend: Offline" until Spring Boot is running — that's normal!

**Recommended VS Code extensions:**
| Extension | Purpose |
|-----------|---------|
| Live Server | Auto-refresh on save |
| Prettier | Format code automatically |
| HTML CSS Support | Better autocomplete |
| JavaScript (ES6) snippets | Faster JS coding |

---

## ☕ STEP 2 — Create Spring Boot Project (IntelliJ)

### 2a. Generate at start.spring.io
1. Go to: **https://start.spring.io**
2. Settings:
   - Project: **Maven**
   - Language: **Java**
   - Spring Boot: **3.x (latest)**
   - Group: `com.tutorease`
   - Artifact: `tutor-api`
3. Dependencies to add:
   - ✅ Spring Web
   - ✅ Spring Data JPA
   - ✅ MySQL Driver
   - ✅ Lombok *(reduces boilerplate)*
4. Click **Generate** → download ZIP → extract → open in IntelliJ

### 2b. application.properties
Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/tutorease_db
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
server.port=8080
```

---

## 🗄️ STEP 3 — MySQL Database Setup

```sql
-- Run in MySQL Workbench or terminal
CREATE DATABASE tutorease_db;
USE tutorease_db;

-- Tables will be auto-created by Spring Boot (ddl-auto=update)
-- But you can manually create them:

CREATE TABLE tutor (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL,
  phone       VARCHAR(20)  NOT NULL,
  location    VARCHAR(150) NOT NULL,
  subject     VARCHAR(100) NOT NULL,
  grade_level VARCHAR(50)  NOT NULL,
  hourly_rate DECIMAL(10,2) DEFAULT 0,
  experience  INT DEFAULT 0,
  bio         TEXT
);

CREATE TABLE booking (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  tutor_id     BIGINT       NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  phone        VARCHAR(20)  NOT NULL,
  session_date DATE         NOT NULL,
  session_time TIME         NOT NULL,
  address      VARCHAR(255) NOT NULL,
  notes        TEXT,
  status       ENUM('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  FOREIGN KEY (tutor_id) REFERENCES tutor(id) ON DELETE CASCADE
);
```

---

## 🔧 STEP 4 — Java Code to Write in IntelliJ

### 📄 Tutor.java (Entity)
```java
package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Tutor {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    private String phone;
    private String location;
    private String subject;
    private String gradeLevel;
    private Double hourlyRate;
    private Integer experience;
    @Column(length = 1000)
    private String bio;
}
```

### 📄 Booking.java (Entity)
```java
package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Booking {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long tutorId;
    private String studentName;
    private String phone;
    private String sessionDate;
    private String sessionTime;
    private String address;
    private String notes;
    private String status = "PENDING";

    // These are filled by the backend before saving
    private String tutorName;
    private String subject;
}
```

### 📄 TutorRepository.java
```java
package com.tutorease.repository;

import com.tutorease.model.Tutor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TutorRepository extends JpaRepository<Tutor, Long> {
    List<Tutor> findBySubjectContainingIgnoreCase(String subject);
    List<Tutor> findByLocationContainingIgnoreCase(String location);
    List<Tutor> findByGradeLevel(String gradeLevel);
}
```

### 📄 BookingRepository.java
```java
package com.tutorease.repository;

import com.tutorease.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByStatus(String status);
    List<Booking> findByTutorId(Long tutorId);
}
```

### 📄 TutorController.java (REST API — CRUD)
```java
package com.tutorease.controller;

import com.tutorease.model.Tutor;
import com.tutorease.repository.TutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/tutors")
@CrossOrigin(origins = "*")   // Allows frontend to call this API
public class TutorController {

    @Autowired TutorRepository repo;

    // GET all tutors
    @GetMapping
    public List<Tutor> getAll() { return repo.findAll(); }

    // GET single tutor by id
    @GetMapping("/{id}")
    public Tutor getById(@PathVariable Long id) {
        return repo.findById(id).orElseThrow();
    }

    // POST - create tutor
    @PostMapping
    public Tutor create(@RequestBody Tutor tutor) {
        return repo.save(tutor);
    }

    // PUT - update tutor
    @PutMapping("/{id}")
    public Tutor update(@PathVariable Long id, @RequestBody Tutor tutor) {
        tutor.setId(id);
        return repo.save(tutor);
    }

    // DELETE tutor
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repo.deleteById(id);
    }
}
```

### 📄 BookingController.java
```java
package com.tutorease.controller;

import com.tutorease.model.Booking;
import com.tutorease.model.Tutor;
import com.tutorease.repository.BookingRepository;
import com.tutorease.repository.TutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = "*")
public class BookingController {

    @Autowired BookingRepository bookingRepo;
    @Autowired TutorRepository   tutorRepo;

    // GET all bookings
    @GetMapping
    public List<Booking> getAll() { return bookingRepo.findAll(); }

    // POST - create booking
    @PostMapping
    public Booking create(@RequestBody Booking booking) {
        // Enrich booking with tutor info
        tutorRepo.findById(booking.getTutorId()).ifPresent(tutor -> {
            booking.setTutorName(tutor.getName());
            booking.setSubject(tutor.getSubject());
        });
        booking.setStatus("PENDING");
        return bookingRepo.save(booking);
    }

    // PUT - update booking status
    @PutMapping("/{id}/status")
    public Booking updateStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Booking b = bookingRepo.findById(id).orElseThrow();
        b.setStatus(body.get("status"));
        return bookingRepo.save(b);
    }

    // DELETE booking
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        bookingRepo.deleteById(id);
    }
}
```

---

## ▶️ STEP 5 — Run Everything

| What | How |
|------|-----|
| Start MySQL | Open MySQL Workbench or terminal |
| Start Backend | IntelliJ → Run `TutorApiApplication` (green ▶ button) |
| Start Frontend | VS Code → Right-click `index.html` → Open with Live Server |

Then open: **http://127.0.0.1:5500** 🎉

---

## 🔌 How Frontend ↔ Backend Works

All URLs are in `js/api.js`:
```js
BASE_URL: "http://localhost:8080/api"
```

| Action | Method | URL |
|--------|--------|-----|
| Get all tutors | GET | `/api/tutors` |
| Add tutor | POST | `/api/tutors` |
| Update tutor | PUT | `/api/tutors/{id}` |
| Delete tutor | DELETE | `/api/tutors/{id}` |
| Get all bookings | GET | `/api/bookings` |
| Create booking | POST | `/api/bookings` |
| Update booking status | PUT | `/api/bookings/{id}/status` |
| Delete booking | DELETE | `/api/bookings/{id}` |

---

## 🐛 Common Problems & Fixes

| Problem | Fix |
|---------|-----|
| "Backend: Offline" badge | Start Spring Boot in IntelliJ |
| CORS error in browser console | Add `@CrossOrigin(origins = "*")` to your controllers |
| MySQL connection refused | Start MySQL; check username/password in application.properties |
| Tables not created | Check ddl-auto=update; look at IntelliJ console for errors |
| Port 8080 busy | Change `server.port=8081` and update `api.js` BASE_URL |

---

## 📌 Files to Edit — Quick Reference

| To change... | Edit this file |
|-------------|---------------|
| Homepage layout | `frontend/index.html` |
| Tutor listings page | `frontend/pages/tutors.html` |
| Bookings page | `frontend/pages/bookings.html` |
| Admin dashboard | `frontend/pages/admin.html` |
| Colors, fonts, layout | `frontend/css/style.css` |
| Backend URL | `frontend/js/api.js` → `BASE_URL` |
| CRUD behavior | `frontend/js/app.js` |
| Database config | `backend/src/main/resources/application.properties` |
| API endpoints | `backend/.../TutorController.java` / `BookingController.java` |
