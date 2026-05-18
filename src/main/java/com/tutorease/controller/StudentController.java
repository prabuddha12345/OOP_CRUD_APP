package com.tutorease.controller;

import com.tutorease.model.Student;
import com.tutorease.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.tutorease.util.CrudLogger;

@RestController
@RequestMapping("/api/students")
@CrossOrigin(origins = "*")
public class StudentController {

    @Autowired
    private StudentRepository studentRepo;

    @Autowired
    private com.tutorease.repository.PaymentRepository paymentRepo;

    @Autowired
    private com.tutorease.repository.BookingRepository bookingRepo;

    @GetMapping
    public List<Student> getAll() {
        return studentRepo.findAll();
    }

    @GetMapping("/{id}")
    public Student getById(@PathVariable Long id) {
        return studentRepo.findById(id).orElseThrow();
    }

    @PostMapping
    public Student create(@RequestBody Student student) {
        Student saved = studentRepo.save(student);
        CrudLogger.log("CREATE", "Student", saved.getId(), "SUCCESS");
        return saved;
    }

    @PutMapping("/{id}")
    public Student update(@PathVariable Long id, @RequestBody Student student) {
        Student existing = studentRepo.findById(id).orElseThrow();
        
        if (student.getName() != null) existing.setName(student.getName());
        if (student.getEmail() != null) existing.setEmail(student.getEmail());
        if (student.getPhone() != null) existing.setPhone(student.getPhone());
        if (student.getGradeLevel() != null) existing.setGradeLevel(student.getGradeLevel());
        if (student.getUsername() != null) existing.setUsername(student.getUsername());
        if (student.getPassword() != null && !student.getPassword().trim().isEmpty()) {
            existing.setPassword(student.getPassword());
        }
        if (student.getAddress() != null) existing.setAddress(student.getAddress());
        if (student.getProfilePicture() != null) existing.setProfilePicture(student.getProfilePicture());
        
        Student saved = studentRepo.save(existing);
        CrudLogger.log("UPDATE", "Student", saved.getId(), "SUCCESS");
        return saved;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            Student student = studentRepo.findById(id).orElse(null);
            if (student != null) {
                // Delete all payments linked to this student
                List<com.tutorease.model.Payment> payments = paymentRepo.findByStudentId(id);
                for (com.tutorease.model.Payment p : payments) {
                    paymentRepo.delete(p);
                }
                
                // Delete all bookings linked to this student
                List<com.tutorease.model.Booking> bookings = bookingRepo.findAll();
                for (com.tutorease.model.Booking b : bookings) {
                    if (student.getUsername().equalsIgnoreCase(b.getStudentName()) || 
                        (student.getName() != null && student.getName().equalsIgnoreCase(b.getStudentName()))) {
                        
                        // First delete payments associated with this booking
                        paymentRepo.findByBookingId(b.getId()).ifPresent(p -> paymentRepo.delete(p));
                        
                        bookingRepo.delete(b);
                    }
                }
            }
            
            studentRepo.deleteById(id);
            CrudLogger.log("DELETE", "Student", id, "SUCCESS");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(new java.util.HashMap<String, String>() {{
                put("message", "Could not delete student. Dependency error.");
            }});
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Student loginRequest) {
        return studentRepo.findByUsername(loginRequest.getUsername())
                .filter(s -> s.getPassword() != null && s.getPassword().equals(loginRequest.getPassword()))
                .map(s -> {
                    Map<String, Object> response = new HashMap<>();
                    response.put("id", s.getId());
                    response.put("username", s.getUsername());
                    response.put("name", s.getName());
                    response.put("role", "student");
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.status(401).build());
    }
}
