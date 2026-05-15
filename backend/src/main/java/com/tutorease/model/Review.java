package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long tutorId;
    private String studentName;
    
    private Integer rating;
    
    @Column(length = 1000)
    private String comment;
}
