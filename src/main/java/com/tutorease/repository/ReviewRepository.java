package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Review;
public interface ReviewRepository extends JpaRepository<Review, Long> {}
