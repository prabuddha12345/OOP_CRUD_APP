package com.tutorease.controller;

import com.tutorease.model.Tutor;
import com.tutorease.repository.TutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.tutorease.util.CrudLogger;

@RestController
@RequestMapping("/api/tutors")
@CrossOrigin(origins = "*")
public class TutorController {

    @Autowired TutorRepository repo;

    @GetMapping
    public List<Tutor> getAll() { return repo.findAll(); }

    @GetMapping("/{id}")
    public Tutor getById(@PathVariable Long id) {
        return repo.findById(id).orElseThrow();
    }

    @PostMapping
    public org.springframework.http.ResponseEntity<?> create(@RequestBody Tutor tutor) {
        try {
            Tutor saved = repo.save(tutor);
            CrudLogger.log("CREATE", "Tutor", saved.getId(), "SUCCESS");
            return org.springframework.http.ResponseEntity.ok(saved);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            return org.springframework.http.ResponseEntity.status(400).body(new java.util.HashMap<String, String>() {{
                put("message", "Username already exists. Please choose another.");
            }});
        } catch (Exception e) {
            return org.springframework.http.ResponseEntity.status(500).body(new java.util.HashMap<String, String>() {{
                put("message", "Internal server error during registration.");
            }});
        }
    }

    @PutMapping("/{id}")
    public Tutor update(@PathVariable Long id, @RequestBody Tutor tutor) {
        System.out.println("Updating tutor ID: " + id);
        Tutor existing = repo.findById(id).orElseThrow(() -> {
            System.out.println("Tutor not found with ID: " + id);
            return new java.util.NoSuchElementException("Tutor not found");
        });
        
        System.out.println("Received tutor data: " + tutor);
        if (tutor.getName() != null) existing.setName(tutor.getName());
        if (tutor.getEmail() != null) existing.setEmail(tutor.getEmail());
        if (tutor.getPhone() != null) existing.setPhone(tutor.getPhone());
        if (tutor.getLocation() != null) existing.setLocation(tutor.getLocation());
        if (tutor.getSubject() != null) existing.setSubject(tutor.getSubject());
        if (tutor.getGradeLevel() != null) existing.setGradeLevel(tutor.getGradeLevel());
        if (tutor.getHourlyRate() != null) existing.setHourlyRate(tutor.getHourlyRate());
        if (tutor.getExperience() != null) existing.setExperience(tutor.getExperience());
        if (tutor.getBio() != null) existing.setBio(tutor.getBio());
        // Do NOT update username/password here unless explicitly sent
        if (tutor.getUsername() != null) existing.setUsername(tutor.getUsername());
        if (tutor.getPassword() != null) existing.setPassword(tutor.getPassword());
        
        Tutor saved = repo.save(existing);
        CrudLogger.log("UPDATE", "Tutor", saved.getId(), "SUCCESS");
        return saved;
    }

    @DeleteMapping("/{id}")
    public org.springframework.http.ResponseEntity<?> delete(@PathVariable Long id) {
        System.out.println("Deleting tutor: " + id);
        try {
            repo.deleteById(id);
            CrudLogger.log("DELETE", "Tutor", id, "SUCCESS");
            return org.springframework.http.ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return org.springframework.http.ResponseEntity.status(500).body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public org.springframework.http.ResponseEntity<?> login(@RequestBody Tutor loginRequest) {
        return repo.findByUsername(loginRequest.getUsername())
                .filter(t -> t.getPassword() != null && t.getPassword().equals(loginRequest.getPassword()))
                .map(t -> {
                    java.util.Map<String, Object> response = new java.util.HashMap<>();
                    response.put("id", t.getId());
                    response.put("username", t.getUsername());
                    response.put("name", t.getName());
                    response.put("role", "tutor");
                    return org.springframework.http.ResponseEntity.ok(response);
                })
                .orElse(org.springframework.http.ResponseEntity.status(401).build());
    }
}
