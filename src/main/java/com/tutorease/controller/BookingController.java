package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/bookings")
public class BookingController {
    @PostMapping
    public String createBooking() { return "created"; }
    @PutMapping("/{id}/status")
    public String updateStatus() { return "updated"; }
}
