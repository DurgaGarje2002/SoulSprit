package com.soulsprit.dao;

import com.soulsprit.model.Feedback;
import com.soulsprit.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        String query = "SELECT f.feedback_id, f.user_id, f.message, f.submitted_at, " +
                      "u.full_name, u.email " +
                      "FROM feedback f " +
                      "LEFT JOIN users u ON f.user_id = u.user_id " +
                      "ORDER BY f.submitted_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setUserId(rs.getInt("user_id"));
                feedback.setMessage(rs.getString("message"));
                feedback.setSubmittedAt(rs.getTimestamp("submitted_at"));
                feedback.setUserFullName(rs.getString("full_name"));
                feedback.setUserEmail(rs.getString("email"));
                
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbackList;
    }
    
    public boolean deleteFeedback(int feedbackId) {
        String query = "DELETE FROM feedback WHERE feedback_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, feedbackId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}