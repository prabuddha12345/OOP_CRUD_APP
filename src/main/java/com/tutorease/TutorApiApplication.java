package com.tutorease;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class TutorApiApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(TutorApiApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(TutorApiApplication.class, args);
    }

    @org.springframework.context.annotation.Bean
    org.springframework.boot.CommandLineRunner seedData(com.tutorease.repository.TutorRepository repo) {
        return args -> {
            if (repo.count() == 0) {
                com.tutorease.model.Tutor t1 = new com.tutorease.model.Tutor();
                t1.setName("Prabuddha Silva");
                t1.setUsername("tutor1");
                t1.setPassword("password123");
                t1.setSubject("Mathematics");
                t1.setGradeLevel("A/L (Grade 12–13)");
                t1.setLocation("Colombo");
                t1.setHourlyRate(2500.0);
                t1.setExperience(5);
                t1.setEmail("prabuddha@example.com");
                t1.setPhone("0771234567");
                t1.setBio("Expert math tutor with 5 years of experience.");
                repo.save(t1);

                com.tutorease.model.Tutor t2 = new com.tutorease.model.Tutor();
                t2.setName("Nimani Perera");
                t2.setSubject("Science");
                t2.setGradeLevel("O/L (Grade 10–11)");
                t2.setLocation("Kandy");
                t2.setHourlyRate(1800.0);
                t2.setExperience(3);
                t2.setEmail("nimani@example.com");
                t2.setPhone("0719876543");
                t2.setBio("Passionate science teacher focused on conceptual learning.");
                repo.save(t2);
            }
        };
    }
}
