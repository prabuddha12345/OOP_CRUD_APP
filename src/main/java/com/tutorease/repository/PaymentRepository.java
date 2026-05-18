package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Payment;
import java.util.List;
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByBookingId(Long bookingId);
}
