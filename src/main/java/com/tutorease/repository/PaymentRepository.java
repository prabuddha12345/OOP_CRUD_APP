package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Payment;
public interface PaymentRepository extends JpaRepository<Payment, Long> {}
