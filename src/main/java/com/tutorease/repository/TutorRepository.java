package com.tutorease.repository;

import com.tutorease.model.Tutor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TutorRepository extends JpaRepository<Tutor, Long> {
    List<Tutor> findBySubjectContainingIgnoreCase(String subject);
    List<Tutor> findByLocationContainingIgnoreCase(String location);
    List<Tutor> findByGradeLevel(String gradeLevel);
    java.util.Optional<Tutor> findByUsername(String username);
    java.util.Optional<Tutor> findByEmail(String email);
}
