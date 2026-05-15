package com.tutorease.controller;

import com.tutorease.model.Review;
import com.tutorease.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.tutorease.util.CrudLogger;

@RestController
@RequestMapping("/api/reviews")
@CrossOrigin(origins = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE, RequestMethod.OPTIONS})
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepo;

    @GetMapping
    public List<Review> getAll() {
        return reviewRepo.findAll();
    }

    @GetMapping("/tutor/{tutorId}")
    public List<Review> getByTutorId(@PathVariable Long tutorId) {
        return reviewRepo.findByTutorId(tutorId);
    }

    @PostMapping
    public Review create(@RequestBody Review review) {
        Review saved = reviewRepo.save(review);
        CrudLogger.log("CREATE", "Review", saved.getId(), "SUCCESS");
        return saved;
    }

    @PutMapping("/{id}")
    public Review update(@PathVariable Long id, @RequestBody Review updatedReview) {
        return reviewRepo.findById(id).map(review -> {
            review.setRating(updatedReview.getRating());
            review.setComment(updatedReview.getComment());
            Review saved = reviewRepo.save(review);
            CrudLogger.log("UPDATE", "Review", saved.getId(), "SUCCESS");
            return saved;
        }).orElse(null);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            if (!reviewRepo.existsById(id)) {
                return ResponseEntity.status(404).body("Review not found.");
            }
            reviewRepo.deleteById(id);
            CrudLogger.log("DELETE", "Review", id, "SUCCESS");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error deleting review: " + e.getMessage());
        }
    }
}
