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
import com.soulsprit.model.Quiz;
import com.soulsprit.model.Question;
import com.soulsprit.model.User;

@WebServlet("/UpdateQuizServlet")
public class UpdateQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and has proper role
        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get quiz ID
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            
            // Get quiz details from form
            String quizTitle = request.getParameter("quizTitle");
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
            
            // Validate quiz data
            if (quizTitle == null || quizTitle.trim().isEmpty()) {
                response.sendRedirect("edit-quiz.jsp?id=" + quizId + "&error=Quiz title is required!");
                return;
            }
            
            // Update Quiz
            Quiz quiz = new Quiz();
            quiz.setQuizId(quizId);
            quiz.setQuizTitle(quizTitle.trim());
            quiz.setBookId(bookId);
            quiz.setTotalMarks(totalMarks);
            
            QuizDAO quizDAO = new QuizDAO();
            boolean quizUpdated = quizDAO.updateQuiz(quiz);
            
            if (!quizUpdated) {
                response.sendRedirect("edit-quiz.jsp?id=" + quizId + "&error=Failed to update quiz!");
                return;
            }
            
            // Get question data from arrays
            String[] questionIds = request.getParameterValues("questionId[]");
            String[] questionTexts = request.getParameterValues("questionText[]");
            String[] optionAs = request.getParameterValues("optionA[]");
            String[] optionBs = request.getParameterValues("optionB[]");
            String[] optionCs = request.getParameterValues("optionC[]");
            String[] optionDs = request.getParameterValues("optionD[]");
            String[] correctOptions = request.getParameterValues("correctOption[]");
            
            // Validate that we have questions
            if (questionTexts == null || questionTexts.length == 0) {
                response.sendRedirect("edit-quiz.jsp?id=" + quizId + "&error=At least one question is required!");
                return;
            }
            
            // Update/Add each question
            QuestionDAO questionDAO = new QuestionDAO();
            int updatedCount = 0;
            int addedCount = 0;
            
            for (int i = 0; i < questionTexts.length; i++) {
                // Validate question data
                if (questionTexts[i] == null || questionTexts[i].trim().isEmpty() ||
                    optionAs[i] == null || optionAs[i].trim().isEmpty() ||
                    optionBs[i] == null || optionBs[i].trim().isEmpty() ||
                    optionCs[i] == null || optionCs[i].trim().isEmpty() ||
                    optionDs[i] == null || optionDs[i].trim().isEmpty() ||
                    correctOptions[i] == null || correctOptions[i].trim().isEmpty()) {
                    continue; // Skip invalid questions
                }
                
                // Create Question object
                Question question = new Question();
                question.setQuizId(quizId);
                question.setQuestionText(questionTexts[i].trim());
                question.setOptionA(optionAs[i].trim());
                question.setOptionB(optionBs[i].trim());
                question.setOptionC(optionCs[i].trim());
                question.setOptionD(optionDs[i].trim());
                question.setCorrectOption(correctOptions[i].trim());
                
                // Check if this is an existing question (questionId > 0) or new question (questionId = 0)
                int questionId = Integer.parseInt(questionIds[i]);
                
                if (questionId > 0) {
                    // Update existing question
                    question.setQuestionId(questionId);
                    boolean updated = questionDAO.updateQuestion(question);
                    if (updated) {
                        updatedCount++;
                    }
                } else {
                    // Add new question
                    boolean added = questionDAO.addQuestion(question);
                    if (added) {
                        addedCount++;
                    }
                }
            }
            
            // Success message
            String successMessage = "Quiz updated successfully!";
            if (addedCount > 0) {
                successMessage += " Added " + addedCount + " new question(s).";
            }
            if (updatedCount > 0) {
                successMessage += " Updated " + updatedCount + " question(s).";
            }
            
            session.setAttribute("success", successMessage);
            response.sendRedirect("manage-quizzes.jsp");
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid input format. Please check your entries.");
            response.sendRedirect("manage-quizzes.jsp");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect("manage-quizzes.jsp");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to manage quizzes page
        response.sendRedirect("manage-quizzes.jsp");
    }
}