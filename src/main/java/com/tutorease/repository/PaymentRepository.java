package com.tutorease.repository;

import com.tutorease.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByStudentId(Long studentId);
    List<Payment> findByTutorId(Long tutorId);
    Optional<Payment> findByBookingId(Long bookingId);
}
