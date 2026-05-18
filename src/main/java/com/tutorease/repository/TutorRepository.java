package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Tutor;
public interface TutorRepository extends JpaRepository<Tutor, Long> {}
