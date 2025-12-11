package com.soulsprit.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.soulsprit.dao.QuizDAO;
import com.soulsprit.dao.QuestionDAO;
import com.soulsprit.model.User;

@WebServlet("/DeleteQuizServlet")
public class DeleteQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and has proper role
        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("error", "Invalid quiz ID!");
                response.sendRedirect("manage-quizzes.jsp");
                return;
            }
            
            int quizId = Integer.parseInt(idParam);
            
            // First delete all questions associated with this quiz
            QuestionDAO questionDAO = new QuestionDAO();
            boolean questionsDeleted = questionDAO.deleteQuestionsByQuizId(quizId);
            
            // Then delete the quiz
            QuizDAO quizDAO = new QuizDAO();
            boolean quizDeleted = quizDAO.deleteQuiz(quizId);
            
            if (quizDeleted) {
                session.setAttribute("success", "Quiz and all its questions deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete quiz. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid quiz ID format!");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred while deleting the quiz: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("manage-quizzes.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}