package com.tutorease.util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CrudLogger {
    // Determine path based on where the app is launched from (backend dir vs project root)
    private static final String FILE_PATH = System.getProperty("user.dir").endsWith("backend") ? "../crud" : "crud";

    public static void log(String operation, String entity, Long id, String status) {
        try (PrintWriter out = new PrintWriter(new FileWriter(FILE_PATH, true))) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            // Example: [2026-05-15 17:10] CREATE | Payment | id=12 | SUCCESS
            out.printf("[%s] %s | %s | id=%s | %s%n", timestamp, operation, entity, id, status);
        } catch (IOException e) {
            System.err.println("Failed to write to crud log: " + e.getMessage());
        }
    }
}
 