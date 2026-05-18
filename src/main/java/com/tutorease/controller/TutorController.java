package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/tutors")
public class TutorController {
    @GetMapping
    public String getTutors() { return "[]"; }
}
