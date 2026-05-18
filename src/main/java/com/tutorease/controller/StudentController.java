package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/students")
public class StudentController {
    @GetMapping("/{id}")
    public String getStudent() { return "student"; }
}
