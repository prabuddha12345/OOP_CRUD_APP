package com.tutorease.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    private String email;
    private String phone;
    private String name;
    private String gradeLevel;
    private String address;
    private String profilePicture;
    
    @Transient
    private String role = "student";
}
