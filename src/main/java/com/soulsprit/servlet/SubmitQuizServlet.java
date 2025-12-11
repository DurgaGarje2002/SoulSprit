package com.soulsprit.servlet;

import com.soulsprit.dao.QuizDAO;
import com.soulsprit.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/SubmitQuizServlet")
public class SubmitQuizServlet extends HttpServlet {
    private QuizDAO quizDAO = new QuizDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            
            // Get quiz and questions
            Quiz quiz = quizDAO.getQuizById(quizId);
            List<QuizQuestion> questions = quizDAO.getQuizQuestions(quizId);
            
            int score = 0;
            int totalQuestions = questions.size();
            
            // Calculate score
            for (QuizQuestion question : questions) {
                String userAnswer = request.getParameter("question_" + question.getQuestionId());
                if (userAnswer != null && userAnswer.equals(question.getCorrectOption())) {
                    score++;
                }
            }
            
            // Save result
            quizDAO.saveQuizResult(user.getUserId(), quizId, score);
            
            // Calculate percentage
            double percentage = (score * 100.0) / totalQuestions;
            
            // Set attributes for result page
            request.setAttribute("score", score);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("percentage", percentage);
            request.setAttribute("quizTitle", quiz.getQuizTitle());
            request.setAttribute("passed", percentage >= 70);
            
            request.getRequestDispatcher("quiz-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}