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
