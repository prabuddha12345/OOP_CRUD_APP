package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Tutor;
import java.util.List;
public interface TutorRepository extends JpaRepository<Tutor, Long> {
    List<Tutor> findBySubject(String subject);
}
