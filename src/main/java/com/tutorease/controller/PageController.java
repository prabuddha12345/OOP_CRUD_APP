package com.tutorease.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/admin")
    public String admin() {
        return "admin";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register-student")
    public String registerStudent() {
        return "register-student";
    }

    @GetMapping("/register-tutor")
    public String registerTutor() {
        return "register-tutor";
    }

    @GetMapping("/tutors")
    public String tutors() {
        return "tutors";
    }

    @GetMapping("/bookings")
    public String bookings() {
        return "bookings";
    }

    @GetMapping("/profile")
    public String profile() {
        return "profile";
    }

    @GetMapping("/teacher-dashboard")
    public String teacherDashboard() {
        return "teacher-dashboard";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }

    @GetMapping("/privacy")
    public String privacy() {
        return "privacy";
    }
}
