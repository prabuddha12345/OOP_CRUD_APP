package com.tutorease.model;
public class Payment {
    private Long id;
    private String bookingRef;
    public enum PaymentStatus { PENDING, SUCCESS, FAILED }
}
