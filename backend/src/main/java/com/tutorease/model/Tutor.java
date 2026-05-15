package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Tutor {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    
    @Column(unique = true)
    private String username;
    private String password;
    
    private String email;
    private String phone;
    private String location;
    private String subject;
    private String gradeLevel;
    private Double hourlyRate;
    private Integer experience;
    @Column(length = 1000)
    private String bio;

    @Transient
    private String role = "tutor";
}
