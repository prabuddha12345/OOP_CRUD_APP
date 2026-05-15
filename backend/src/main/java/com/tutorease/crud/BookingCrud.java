package com.tutorease.crud;

import com.tutorease.model.Booking;
import com.tutorease.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/crud/bookings")
@CrossOrigin(origins = "*")
public class BookingCrud {

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping
    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    @PostMapping
    public Booking createBooking(@RequestBody Booking booking) {
        return bookingRepository.save(booking);
    }

    @GetMapping("/{id}")
    public Booking getBookingById(@PathVariable Long id) {
        return bookingRepository.findById(id).orElse(null);
    }

    @PutMapping("/{id}")
    public Booking updateBooking(@PathVariable Long id, @RequestBody Booking updatedBooking) {
        return bookingRepository.findById(id).map(booking -> {
            booking.setTutorId(updatedBooking.getTutorId());
            booking.setStudentName(updatedBooking.getStudentName());
            booking.setPhone(updatedBooking.getPhone());
            booking.setSessionDate(updatedBooking.getSessionDate());
            booking.setSessionTime(updatedBooking.getSessionTime());
            booking.setAddress(updatedBooking.getAddress());
            booking.setNotes(updatedBooking.getNotes());
            booking.setStatus(updatedBooking.getStatus());
            booking.setTutorName(updatedBooking.getTutorName());
            booking.setSubject(updatedBooking.getSubject());
            return bookingRepository.save(booking);
        }).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteBooking(@PathVariable Long id) {
        bookingRepository.deleteById(id);
    }
}
