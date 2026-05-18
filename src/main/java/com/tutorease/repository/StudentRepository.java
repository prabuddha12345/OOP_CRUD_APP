package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Student;
public interface StudentRepository extends JpaRepository<Student, Long> {}
