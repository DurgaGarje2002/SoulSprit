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

@WebServlet("/AddQuizServlet")
public class AddQuizServlet extends HttpServlet {
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
            // Get quiz details from form
            String quizTitle = request.getParameter("quizTitle");
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
            int createdBy = user.getUserId();
            
            // Validate quiz data
            if (quizTitle == null || quizTitle.trim().isEmpty()) {
                session.setAttribute("error", "Quiz title is required!");
                response.sendRedirect("add-quiz.jsp");
                return;
            }
            
            // Create Quiz object
            Quiz quiz = new Quiz();
            quiz.setQuizTitle(quizTitle.trim());
            quiz.setBookId(bookId);
            quiz.setTotalMarks(totalMarks);
            quiz.setCreatedBy(createdBy);
            
            // Save quiz to database
            QuizDAO quizDAO = new QuizDAO();
            int quizId = quizDAO.addQuiz(quiz);
            
            if (quizId > 0) {
                // Get question data from arrays
                String[] questionTexts = request.getParameterValues("questionText[]");
                String[] optionAs = request.getParameterValues("optionA[]");
                String[] optionBs = request.getParameterValues("optionB[]");
                String[] optionCs = request.getParameterValues("optionC[]");
                String[] optionDs = request.getParameterValues("optionD[]");
                String[] correctOptions = request.getParameterValues("correctOption[]");
                
                // Validate that we have questions
                if (questionTexts == null || questionTexts.length == 0) {
                    session.setAttribute("error", "At least one question is required!");
                    response.sendRedirect("add-quiz.jsp");
                    return;
                }
                
                // Save each question
                QuestionDAO questionDAO = new QuestionDAO();
                boolean allQuestionsAdded = true;
                
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
                    
                    // Save question to database
                    boolean added = questionDAO.addQuestion(question);
                    if (!added) {
                        allQuestionsAdded = false;
                    }
                }
                
                if (allQuestionsAdded) {
                    session.setAttribute("success", "Quiz created successfully with all questions!");
                } else {
                    session.setAttribute("success", "Quiz created, but some questions failed to add.");
                }
                response.sendRedirect("manage-quizzes.jsp");
            } else {
                session.setAttribute("error", "Failed to create quiz. Please try again.");
                response.sendRedirect("add-quiz.jsp");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid input format. Please check your entries.");
            response.sendRedirect("add-quiz.jsp");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect("add-quiz.jsp");
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to add quiz page
        response.sendRedirect("add-quiz.jsp");
    }
}