package com.tutorease.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.tutorease.model.Booking;
public interface BookingRepository extends JpaRepository<Booking, Long> {}
