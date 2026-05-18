package com.tutorease.controller;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/payments")
public class PaymentController {
    @PostMapping
    public String processPayment() { return "success"; }
    @GetMapping("/{id}")
    public String getReceipt() { return "receipt"; }
    private double calculateFee(double rate, double hours) { return rate * hours; }
}
