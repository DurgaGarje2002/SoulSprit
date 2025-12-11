package com.soulsprit.test;

import com.soulsprit.dao.UserDAO;
import com.soulsprit.model.User;
import com.soulsprit.util.PasswordUtil;

public class TestDatabase {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        
        // Test 1: Register admin user
        System.out.println("=== Test 1: Register Admin User ===");
        User admin = new User();
        admin.setFullName("Admin User");
        admin.setEmail("admin@soulsprit.com");
        admin.setPassword(PasswordUtil.hashPassword("admin123"));
        admin.setRole("admin");
        
        boolean registered = userDAO.registerUser(admin);
        System.out.println("Admin registered: " + registered);
        
        // Test 2: Register student user
        System.out.println("\n=== Test 2: Register Student User ===");
        User student = new User();
        student.setFullName("John Student");
        student.setEmail("student@soulsprit.com");
        student.setPassword(PasswordUtil.hashPassword("student123"));
        student.setRole("student");
        
        registered = userDAO.registerUser(student);
        System.out.println("Student registered: " + registered);
        
        // Test 3: Authenticate user
        System.out.println("\n=== Test 3: Authenticate User ===");
        User authenticatedUser = userDAO.authenticateUser(
            "admin@soulsprit.com", 
            PasswordUtil.hashPassword("admin123")
        );
        
        if (authenticatedUser != null) {
            System.out.println("✅ Authentication successful!");
            System.out.println("User: " + authenticatedUser.getFullName());
            System.out.println("Role: " + authenticatedUser.getRole());
        } else {
            System.out.println("❌ Authentication failed!");
        }
        
        // Test 4: Get all users
        System.out.println("\n=== Test 4: Get All Users ===");
        userDAO.getAllUsers().forEach(u -> 
            System.out.println(u.getFullName() + " - " + u.getEmail() + " (" + u.getRole() + ")")
        );
    }
}