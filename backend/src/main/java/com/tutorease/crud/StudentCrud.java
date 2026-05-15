package com.tutorease.crud;

import com.tutorease.model.Student;
import com.tutorease.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/crud/students")
@CrossOrigin(origins = "*")
public class StudentCrud {

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping
    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    @PostMapping
    public Student createStudent(@RequestBody Student student) {
        return studentRepository.save(student);
    }

    @GetMapping("/{id}")
    public Student getStudentById(@PathVariable Long id) {
        return studentRepository.findById(id).orElse(null);
    }

    @PutMapping("/{id}")
    public Student updateStudent(@PathVariable Long id, @RequestBody Student updatedStudent) {
        return studentRepository.findById(id).map(student -> {
            student.setUsername(updatedStudent.getUsername());
            student.setPassword(updatedStudent.getPassword());
            student.setEmail(updatedStudent.getEmail());
            student.setPhone(updatedStudent.getPhone());
            student.setName(updatedStudent.getName());
            student.setGradeLevel(updatedStudent.getGradeLevel());
            return studentRepository.save(student);
        }).orElse(null);
    }

    @DeleteMapping("/{id}")
    public void deleteStudent(@PathVariable Long id) {
        studentRepository.deleteById(id);
    }
}
