package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "booking_id", unique = true, nullable = false)
    private Booking booking;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "tutor_id", nullable = false)
    private Tutor tutor;

    private Double amount;
    private String paymentMethod; // CARD, CASH, OTHER
    private String status = "PENDING"; // PENDING, PAID, FAILED
    
    private LocalDateTime paymentDate = LocalDateTime.now();
}
