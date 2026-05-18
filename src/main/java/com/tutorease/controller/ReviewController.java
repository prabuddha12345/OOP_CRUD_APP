package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/reviews")
public class ReviewController {
    @PostMapping
    public String addReview() { return "added"; }
    private boolean validateRating(int rating) { return rating >= 1 && rating <= 5; }
}
