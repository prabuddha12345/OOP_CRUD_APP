package com.tutorease.crud;

import com.tutorease.model.Tutor;
import com.tutorease.repository.TutorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/crud/tutors")
@CrossOrigin(origins = "*")
public class TutorCrud {

    @Autowired
    private TutorRepository tutorRepository;

    @GetMapping
    public List<Tutor> getAllTutors() {
        return tutorRepository.findAll();
    }

    @PostMapping
    public Tutor createTutor(@RequestBody Tutor tutor) {
        return tutorRepository.save(tutor);
    }

    @GetMapping("/{id}")
    public Tutor getTutorById(@PathVariable Long id) {
        return tutorRepository.findById(id).orElse(null);
    }

    @PutMapping("/{id}")
    public Tutor updateTutor(@PathVariable Long id, @RequestBody Tutor updatedTutor) {
        return tutorRepository.findById(id).map(tutor -> {
            tutor.setName(updatedTutor.getName());
            tutor.setEmail(updatedTutor.getEmail());
            tutor.setPhone(updatedTutor.getPhone());
            tutor.setLocation(updatedTutor.getLocation());
            tutor.setSubject(updatedTutor.getSubject());
            tutor.setGradeLevel(updatedTutor.getGradeLevel());
            tutor.setHourlyRate(updatedTutor.getHourlyRate());
            tutor.setExperience(updatedTutor.getExperience());
            tutor.setBio(updatedTutor.getBio());
            return tutorRepository.save(tutor);
        }).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteTutor(@PathVariable Long id) {
        tutorRepository.deleteById(id);
    }
}
