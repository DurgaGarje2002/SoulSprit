package com.soulsprit.dao;

import com.soulsprit.model.*;
import com.soulsprit.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    // ✅ Add a new quiz and return the generated quiz_id
    public int addQuiz(Quiz quiz) {
        String query = "INSERT INTO quizzes (book_id, quiz_title, total_marks, created_by) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, quiz.getBookId());
            ps.setString(2, quiz.getQuizTitle());
            ps.setInt(3, quiz.getTotalMarks());
            ps.setInt(4, quiz.getCreatedBy());

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Return the generated quiz_id
                    }
                }
            }
            return -1; // Return -1 if insertion failed
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ✅ Get all quizzes
    public List<Quiz> getAllQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quizzes ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizId(rs.getInt("quiz_id"));
                quiz.setBookId(rs.getInt("book_id"));
                quiz.setQuizTitle(rs.getString("quiz_title"));
                quiz.setTotalMarks(rs.getInt("total_marks"));
                quiz.setCreatedBy(rs.getInt("created_by"));
                quiz.setCreatedAt(rs.getTimestamp("created_at"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }

    // ✅ Get quiz by ID
    public Quiz getQuizById(int quizId) {
        String query = "SELECT * FROM quizzes WHERE quiz_id = ?";
        Quiz quiz = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setBookId(rs.getInt("book_id"));
                    quiz.setQuizTitle(rs.getString("quiz_title"));
                    quiz.setTotalMarks(rs.getInt("total_marks"));
                    quiz.setCreatedBy(rs.getInt("created_by"));
                    quiz.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quiz;
    }

    // ✅ Update quiz
    public boolean updateQuiz(Quiz quiz) {
        String query = "UPDATE quizzes SET book_id = ?, quiz_title = ?, total_marks = ? WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, quiz.getBookId());
            ps.setString(2, quiz.getQuizTitle());
            ps.setInt(3, quiz.getTotalMarks());
            ps.setInt(4, quiz.getQuizId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Delete quiz
    public boolean deleteQuiz(int quizId) {
        String query = "DELETE FROM quizzes WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, quizId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Get questions of a quiz
    public List<QuizQuestion> getQuizQuestions(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String query = "SELECT * FROM quiz_questions WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = new QuizQuestion();
                    q.setQuestionId(rs.getInt("question_id"));
                    q.setQuizId(rs.getInt("quiz_id"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setOptionA(rs.getString("option_a"));
                    q.setOptionB(rs.getString("option_b"));
                    q.setOptionC(rs.getString("option_c"));
                    q.setOptionD(rs.getString("option_d"));
                    q.setCorrectOption(rs.getString("correct_option"));
                    questions.add(q);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    // ✅ Save quiz result
    public boolean saveQuizResult(int userId, int quizId, int score) {
        String query = "INSERT INTO quiz_results (user_id, quiz_id, score, submitted_at) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ps.setInt(3, score);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ✅ Get quizzes by book ID
    public List<Quiz> getQuizzesByBookId(int bookId) {
        List<Quiz> quizzes = new ArrayList<>();
        String query = "SELECT * FROM quizzes WHERE book_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setQuizId(rs.getInt("quiz_id"));
                    quiz.setBookId(rs.getInt("book_id"));
                    quiz.setQuizTitle(rs.getString("quiz_title"));
                    quiz.setTotalMarks(rs.getInt("total_marks"));
                    quiz.setCreatedBy(rs.getInt("created_by"));
                    quiz.setCreatedAt(rs.getTimestamp("created_at"));
                    quizzes.add(quiz);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }
}