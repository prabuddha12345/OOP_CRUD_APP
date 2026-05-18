package com.tutorease.controller;

import com.tutorease.model.Tutor;
import com.tutorease.repository.TutorRepository;
import com.tutorease.repository.PaymentRepository;
import com.tutorease.repository.BookingRepository;
import com.tutorease.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import com.tutorease.util.CrudLogger;

@RestController
@RequestMapping("/api/tutors")
@CrossOrigin(origins = "*")
public class TutorController {

    @Autowired
    private TutorRepository repo;

    @Autowired
    private PaymentRepository paymentRepo;

    @Autowired
    private BookingRepository bookingRepo;

    @Autowired
    private ReviewRepository reviewRepo;

    @GetMapping
    public List<Tutor> getAll() { 
        return repo.findAll(); 
    }

    @GetMapping("/{id}")
    public Tutor getById(@PathVariable Long id) {
        return repo.findById(id).orElseThrow();
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Tutor tutor) {
        // Prevent duplicate tutor registrations with the same email or username
        if (tutor.getUsername() != null && repo.findByUsername(tutor.getUsername()).isPresent()) {
            return ResponseEntity.status(400).body(new HashMap<String, String>() {{
                put("message", "Username is already registered!");
            }});
        }
        if (tutor.getEmail() != null && repo.findByEmail(tutor.getEmail()).isPresent()) {
            return ResponseEntity.status(400).body(new HashMap<String, String>() {{
                put("message", "Email is already registered!");
            }});
        }

        Tutor saved = repo.save(tutor);
        CrudLogger.log("CREATE", "Tutor", saved.getId(), "SUCCESS");
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public Tutor update(@PathVariable Long id, @RequestBody Tutor tutor) {
        Tutor existing = repo.findById(id).orElseThrow();
        if (tutor.getName() != null) existing.setName(tutor.getName());
        if (tutor.getUsername() != null) existing.setUsername(tutor.getUsername());
        if (tutor.getPassword() != null && !tutor.getPassword().trim().isEmpty()) {
            existing.setPassword(tutor.getPassword());
        }
        if (tutor.getEmail() != null) existing.setEmail(tutor.getEmail());
        if (tutor.getPhone() != null) existing.setPhone(tutor.getPhone());
        if (tutor.getLocation() != null) existing.setLocation(tutor.getLocation());
        if (tutor.getSubject() != null) existing.setSubject(tutor.getSubject());
        if (tutor.getGradeLevel() != null) existing.setGradeLevel(tutor.getGradeLevel());
        if (tutor.getQualifications() != null) existing.setQualifications(tutor.getQualifications());
        if (tutor.getHourlyRate() != null) existing.setHourlyRate(tutor.getHourlyRate());
        if (tutor.getExperience() != null) existing.setExperience(tutor.getExperience());
        if (tutor.getBio() != null) existing.setBio(tutor.getBio());

        Tutor saved = repo.save(existing);
        CrudLogger.log("UPDATE", "Tutor", saved.getId(), "SUCCESS");
        return saved;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        System.out.println("Deleting tutor: " + id);
        try {
            // Delete all payments linked directly to this tutor
            List<com.tutorease.model.Payment> payments = paymentRepo.findByTutorId(id);
            for (com.tutorease.model.Payment p : payments) {
                paymentRepo.delete(p);
            }
            
            // Delete all bookings linked to this tutor
            List<com.tutorease.model.Booking> bookings = bookingRepo.findByTutorId(id);
            for (com.tutorease.model.Booking b : bookings) {
                // Delete payments associated with the booking first
                paymentRepo.findByBookingId(b.getId()).ifPresent(p -> paymentRepo.delete(p));
                bookingRepo.delete(b);
            }
            
            // Delete all reviews linked to this tutor
            List<com.tutorease.model.Review> reviews = reviewRepo.findByTutorId(id);
            for (com.tutorease.model.Review r : reviews) {
                reviewRepo.delete(r);
            }
            
            repo.deleteById(id);
            CrudLogger.log("DELETE", "Tutor", id, "SUCCESS");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(new HashMap<String, String>() {{
                put("message", "Could not delete tutor. Dependency error.");
            }});
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Tutor loginRequest) {
        return repo.findByUsername(loginRequest.getUsername())
                .filter(t -> t.getPassword() != null && t.getPassword().equals(loginRequest.getPassword()))
                .map(t -> {
                    Map<String, Object> response = new HashMap<>();
                    response.put("id", t.getId());
                    response.put("username", t.getUsername());
                    response.put("name", t.getName());
                    response.put("role", "tutor");
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.status(401).build());
    }
}
