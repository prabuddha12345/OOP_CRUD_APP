package com.tutorease.controller;

import com.tutorease.model.Payment;
import com.tutorease.repository.PaymentRepository;
import com.tutorease.util.CrudLogger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
public class PaymentController {

    @Autowired
    private PaymentRepository paymentRepo;

    @Autowired
    private com.tutorease.repository.TutorRepository tutorRepo;

    @GetMapping
    public List<Payment> getAll() {
        return paymentRepo.findAll();
    }

    @GetMapping("/{id}")
    public Payment getById(@PathVariable Long id) {
        return paymentRepo.findById(id).orElseThrow();
    }

    @GetMapping("/student/{studentId}")
    public List<Payment> getByStudentId(@PathVariable Long studentId) {
        return paymentRepo.findByStudentId(studentId);
    }

    @GetMapping("/tutor/{tutorId}")
    public List<Payment> getByTutorId(@PathVariable Long tutorId) {
        return paymentRepo.findByTutorId(tutorId);
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Payment payment) {
        // Enforce the correct payment amount from the tutor's rate
        Double tutorRate = 0.0;
        if (payment.getTutor() != null && payment.getTutor().getId() != null) {
            com.tutorease.model.Tutor tutor = tutorRepo.findById(payment.getTutor().getId()).orElse(null);
            if (tutor != null && tutor.getHourlyRate() != null) {
                tutorRate = tutor.getHourlyRate();
            }
        }
        
        Double finalAmount = 1500.0;
        if (tutorRate > 0) {
            finalAmount = tutorRate;
        } else if (payment.getAmount() != null && payment.getAmount() > 0) {
            finalAmount = payment.getAmount();
        }
        
        // Prevent duplicate payment for same booking, but reuse/update pending/failed records
        if (payment.getBooking() != null && payment.getBooking().getId() != null) {
            Optional<Payment> existingOpt = paymentRepo.findByBookingId(payment.getBooking().getId());
            if (existingOpt.isPresent()) {
                Payment existing = existingOpt.get();
                if ("PAID".equalsIgnoreCase(existing.getStatus()) || "SUCCESS".equalsIgnoreCase(existing.getStatus())) {
                    return ResponseEntity.badRequest().body(new java.util.HashMap<String, String>() {{
                        put("message", "Payment already exists for this booking.");
                    }});
                } else {
                    // Update and reuse the existing pending/failed/cancelled row
                    existing.setPaymentMethod(payment.getPaymentMethod());
                    existing.setAmount(finalAmount);
                    existing.setStatus(payment.getStatus() != null && !payment.getStatus().isEmpty() ? payment.getStatus() : "PAID");
                    existing.setPaymentDate(LocalDateTime.now());
                    Payment saved = paymentRepo.save(existing);
                    CrudLogger.log("UPDATE", "Payment", saved.getId(), "SUCCESS");
                    return ResponseEntity.ok(saved);
                }
            }
        }

        // Create new payment
        payment.setAmount(finalAmount);
        if (payment.getStatus() == null || payment.getStatus().isEmpty()) {
            payment.setStatus("PAID"); // Simulated successful payment
        }
        payment.setPaymentDate(LocalDateTime.now());
        Payment saved = paymentRepo.save(payment);
        
        CrudLogger.log("CREATE", "Payment", saved.getId(), "SUCCESS");
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public Payment updateStatus(@PathVariable Long id, @RequestBody Payment updatedPayment) {
        Payment p = paymentRepo.findById(id).orElseThrow();
        if (updatedPayment.getStatus() != null) {
            p.setStatus(updatedPayment.getStatus());
        }
        Payment saved = paymentRepo.save(p);
        CrudLogger.log("UPDATE", "Payment", saved.getId(), "SUCCESS");
        return saved;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            paymentRepo.deleteById(id);
            CrudLogger.log("DELETE", "Payment", id, "SUCCESS");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }
}
