package com.tutorease.model;
public class Booking {
    private Long id;
    public enum BookingStatus { PENDING, CONFIRMED, COMPLETED, CANCELLED }
    public Long getId() { return id; }
}
