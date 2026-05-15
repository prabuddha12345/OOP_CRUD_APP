package com.tutorease.controller;

import com.tutorease.model.Student;
import com.tutorease.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private StudentRepository studentRepo;

    @PostMapping("/register")
    public ResponseEntity<?> registerStudent(@RequestBody Student student) {
        // Check if username exists
        if (studentRepo.findByUsername(student.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "Username already exists"));
        }
        
        // In a real application, you MUST hash the password using BCrypt before saving!
        // Since we don't have Spring Security installed yet, we are saving it directly.
        Student savedStudent = studentRepo.save(student);
        return ResponseEntity.ok(savedStudent);
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginStudent(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        Optional<Student> studentOpt = studentRepo.findByUsername(username);
        
        if (studentOpt.isPresent() && studentOpt.get().getPassword().equals(password)) {
            Student student = studentOpt.get();
            // Return user details without password
            Map<String, Object> response = new HashMap<>();
            response.put("id", student.getId());
            response.put("username", student.getUsername());
            response.put("role", "student");
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "Invalid username or password"));
        }
    }
}
