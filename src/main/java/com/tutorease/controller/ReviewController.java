package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/reviews")
public class ReviewController {
    @PostMapping
    public String addReview() { return "added"; }
    @DeleteMapping("/{id}")
    public String deleteReview() { return "deleted"; }
}
