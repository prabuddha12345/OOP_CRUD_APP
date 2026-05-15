package com.tutorease.controller;

import com.tutorease.model.Booking;
import com.tutorease.model.Tutor;
import com.tutorease.repository.BookingRepository;
import com.tutorease.repository.TutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import com.tutorease.util.CrudLogger;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = "*")
public class BookingController {

    @Autowired BookingRepository bookingRepo;
    @Autowired TutorRepository   tutorRepo;

    @GetMapping
    public List<Booking> getAll() { return bookingRepo.findAll(); }

    @PostMapping
    public Booking create(@RequestBody Booking booking) {
        tutorRepo.findById(booking.getTutorId()).ifPresent(tutor -> {
            booking.setTutorName(tutor.getName());
            booking.setSubject(tutor.getSubject());
        });
        booking.setStatus("PENDING");
        Booking saved = bookingRepo.save(booking);
        CrudLogger.log("CREATE", "Booking", saved.getId(), "SUCCESS");
        return saved;
    }

    @PutMapping("/{id}/status")
    public Booking updateStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Booking b = bookingRepo.findById(id).orElseThrow();
        b.setStatus(body.get("status"));
        Booking saved = bookingRepo.save(b);
        CrudLogger.log("UPDATE", "Booking", saved.getId(), "SUCCESS");
        return saved;
    }

    @DeleteMapping("/{id}")
    public org.springframework.http.ResponseEntity<?> delete(@PathVariable Long id) {
        System.out.println("Deleting booking: " + id);
        try {
            bookingRepo.deleteById(id);
            CrudLogger.log("DELETE", "Booking", id, "SUCCESS");
            return org.springframework.http.ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return org.springframework.http.ResponseEntity.status(500).body(e.getMessage());
        }
    }
}
