<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*" %>
<%@ page import="com.soulsprit.dao.*" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String quizIdParam = request.getParameter("id");
    if (quizIdParam == null) {
        response.sendRedirect("manage-quizzes.jsp");
        return;
    }
    
    int quizId = Integer.parseInt(quizIdParam);
    QuizDAO quizDAO = new QuizDAO();
    Quiz quiz = quizDAO.getQuizById(quizId);
    List<QuizQuestion> questions = quizDAO.getQuizQuestions(quizId);
    
    if (quiz == null) {
        response.sendRedirect("manage-quizzes.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= quiz.getQuizTitle() %> - SoulSprit</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body { background: #f5f7fa; }
        
        .quiz-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .quiz-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .quiz-title {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        
        .quiz-meta {
            display: flex;
            justify-content: center;
            gap: 2rem;
            opacity: 0.9;
        }
        
        .question-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }
        
        .question-number {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .question-text {
            font-size: 1.2rem;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
        }
        
        .option {
            padding: 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .option:hover {
            border-color: var(--primary);
            background: #f8f9fa;
        }
        
        .option.selected {
            border-color: var(--primary);
            background: linear-gradient(135deg, rgba(103, 58, 183, 0.1), rgba(156, 39, 176, 0.1));
        }
        
        .option-label {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .submit-section {
            text-align: center;
            margin-top: 2rem;
        }
        
        .result-section {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .score-display {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary);
            margin: 1rem 0;
        }
    </style>
</head>
<body>
    <div class="quiz-container">
        <div class="quiz-header">
            <h1 class="quiz-title"><%= quiz.getQuizTitle() %></h1>
            <div class="quiz-meta">
                <span><i class="fas fa-question-circle"></i> <%= questions.size() %> Questions</span>
                <span><i class="fas fa-star"></i> <%= quiz.getTotalMarks() %> Marks</span>
            </div>
        </div>
        
        <form id="quizForm" action="SubmitQuizServlet" method="post">
            <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>">
            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
            
            <% for (int i = 0; i < questions.size(); i++) {
                QuizQuestion question = questions.get(i);
            %>
                <div class="question-card">
                    <div class="question-number">Question <%= (i + 1) %></div>
                    <div class="question-text"><%= question.getQuestionText() %></div>
                    
                    <div class="option" onclick="selectOption(this, '<%= question.getQuestionId() %>', 'A')">
                        <div class="option-label">A</div>
                        <div><%= question.getOptionA() %></div>
                        <input type="radio" name="answer_<%= question.getQuestionId() %>" value="A" style="display: none;">
                    </div>
                    
                    <div class="option" onclick="selectOption(this, '<%= question.getQuestionId() %>', 'B')">
                        <div class="option-label">B</div>
                        <div><%= question.getOptionB() %></div>
                        <input type="radio" name="answer_<%= question.getQuestionId() %>" value="B" style="display: none;">
                    </div>
                    
                    <div class="option" onclick="selectOption(this, '<%= question.getQuestionId() %>', 'C')">
                        <div class="option-label">C</div>
                        <div><%= question.getOptionC() %></div>
                        <input type="radio" name="answer_<%= question.getQuestionId() %>" value="C" style="display: none;">
                    </div>
                    
                    <div class="option" onclick="selectOption(this, '<%= question.getQuestionId() %>', 'D')">
                        <div class="option-label">D</div>
                        <div><%= question.getOptionD() %></div>
                        <input type="radio" name="answer_<%= question.getQuestionId() %>" value="D" style="display: none;">
                    </div>
                </div>
            <% } %>
            
            <div class="submit-section">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="fas fa-check"></i> Submit Quiz
                </button>
                <a href="dashboard.jsp" class="btn btn-outline btn-lg">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>
    
    <script>
        function selectOption(element, questionId, option) {
            // Remove selected class from all options in this question
            const allOptions = element.parentElement.querySelectorAll('.option');
            allOptions.forEach(opt => opt.classList.remove('selected'));
            
            // Add selected class to clicked option
            element.classList.add('selected');
            
            // Check the radio button
            const radio = element.querySelector('input[type="radio"]');
            radio.checked = true;
        }
        
        document.getElementById('quizForm').addEventListener('submit', function(e) {
            const totalQuestions = <%= questions.size() %>;
            const answeredQuestions = document.querySelectorAll('input[type="radio"]:checked').length;
            
            if (answeredQuestions < totalQuestions) {
                e.preventDefault();
                if (!confirm(`You have answered ${answeredQuestions} out of ${totalQuestions} questions. Submit anyway?`)) {
                    return false;
                }
            }
            
            return true;
        });
    </script>
</body>
</html>