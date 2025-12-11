package com.soulsprit.dao;

import com.soulsprit.model.Reflection;
import com.soulsprit.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReflectionDAO {
    
    public List<Reflection> getUserReflections(int userId) {
        List<Reflection> reflections = new ArrayList<>();
        String query = "SELECT * FROM reflections WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reflection reflection = new Reflection();
                reflection.setReflectionId(rs.getInt("reflection_id"));
                reflection.setUserId(rs.getInt("user_id"));
                reflection.setBookId(rs.getInt("book_id"));
                reflection.setReflectionText(rs.getString("reflection_text"));
                reflection.setCreatedAt(rs.getTimestamp("created_at"));
                reflections.add(reflection);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reflections;
    }
    
    public List<Reflection> getBookReflections(int userId, int bookId) {
        List<Reflection> reflections = new ArrayList<>();
        String query = "SELECT * FROM reflections WHERE user_id = ? AND book_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reflection reflection = new Reflection();
                reflection.setReflectionId(rs.getInt("reflection_id"));
                reflection.setUserId(rs.getInt("user_id"));
                reflection.setBookId(rs.getInt("book_id"));
                reflection.setReflectionText(rs.getString("reflection_text"));
                reflection.setCreatedAt(rs.getTimestamp("created_at"));
                reflections.add(reflection);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reflections;
    }
    
    public boolean addReflection(Reflection reflection) {
        String query = "INSERT INTO reflections (user_id, book_id, reflection_text) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, reflection.getUserId());
            stmt.setInt(2, reflection.getBookId());
            stmt.setString(3, reflection.getReflectionText());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteReflection(int reflectionId) {
        String query = "DELETE FROM reflections WHERE reflection_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, reflectionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}