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
    
    String quizIdParam = request.getParameter("quizId");
    if (quizIdParam == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    int quizId = Integer.parseInt(quizIdParam);
    QuizDAO quizDAO = new QuizDAO();
    Quiz quiz = quizDAO.getQuizById(quizId);
    List<QuizQuestion> questions = quizDAO.getQuizQuestions(quizId);
    
    if (quiz == null || questions == null || questions.isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz: <%= quiz.getQuizTitle() %></title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 100%);
        }
        
        .quiz-container {
            max-width: 900px;
            margin: 3rem auto;
            padding: 0 2rem;
        }
        
        .quiz-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 3rem 2rem;
            border-radius: var(--radius-xl);
            text-align: center;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px var(--shadow);
        }
        
        .quiz-header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            color: white;
        }
        
        .quiz-info {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 1.5rem;
            color: white;
        }
        
        .quiz-info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .quiz-card {
            background: white;
            padding: 2.5rem;
            border-radius: var(--radius-md);
            box-shadow: 0 8px 30px var(--shadow);
            margin-bottom: 2rem;
        }
        
        .question-number {
            display: inline-block;
            padding: 8px 16px;
            background: var(--primary);
            color: white;
            border-radius: 20px;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .question-text {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .options {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .option {
            padding: 1.5rem;
            background: var(--bg-light);
            border: 2px solid transparent;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .option:hover {
            border-color: var(--primary);
            background: white;
        }
        
        .option input[type="radio"] {
            width: 20px;
            height: 20px;
            accent-color: var(--primary);
            cursor: pointer;
        }
        
        .option label {
            flex: 1;
            cursor: pointer;
            color: var(--text-dark);
            font-size: 1.1rem;
        }
        
        .submit-section {
            text-align: center;
            padding: 2rem;
        }
        
        .timer {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 1rem 2rem;
            border-radius: var(--radius-md);
            box-shadow: 0 4px 20px var(--shadow);
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary);
        }
        
        @media (max-width: 768px) {
            .quiz-info {
                flex-direction: column;
                gap: 1rem;
            }
            
            .timer {
                position: static;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="quiz-container">
        <div class="quiz-header">
            <h1><i class="fas fa-clipboard-question"></i> <%= quiz.getQuizTitle() %></h1>
            <div class="quiz-info">
                <div class="quiz-info-item">
                    <i class="fas fa-question-circle"></i>
                    <span><%= questions.size() %> Questions</span>
                </div>
                <div class="quiz-info-item">
                    <i class="fas fa-star"></i>
                    <span><%= quiz.getTotalMarks() %> Points</span>
                </div>
                <div class="quiz-info-item">
                    <i class="fas fa-clock"></i>
                    <span>30 Minutes</span>
                </div>
            </div>
        </div>
        
        <div class="timer" id="timer">
            <i class="fas fa-hourglass-half"></i> <span id="timeLeft">30:00</span>
        </div>
        
        <form action="SubmitQuizServlet" method="post" id="quizForm">
            <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>">
            
            <% 
            int questionNumber = 1;
            for (QuizQuestion question : questions) { 
            %>
                <div class="quiz-card">
                    <div class="question-number">
                        Question <%= questionNumber %>
                    </div>
                    <div class="question-text">
                        <%= question.getQuestionText() %>
                    </div>
                    
                    <div class="options">
                        <div class="option">
                            <input type="radio" 
                                   id="q<%= question.getQuestionId() %>_a" 
                                   name="question_<%= question.getQuestionId() %>" 
                                   value="A" 
                                   required>
                            <label for="q<%= question.getQuestionId() %>_a">
                                A. <%= question.getOptionA() %>
                            </label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" 
                                   id="q<%= question.getQuestionId() %>_b" 
                                   name="question_<%= question.getQuestionId() %>" 
                                   value="B">
                            <label for="q<%= question.getQuestionId() %>_b">
                                B. <%= question.getOptionB() %>
                            </label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" 
                                   id="q<%= question.getQuestionId() %>_c" 
                                   name="question_<%= question.getQuestionId() %>" 
                                   value="C">
                            <label for="q<%= question.getQuestionId() %>_c">
                                C. <%= question.getOptionC() %>
                            </label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" 
                                   id="q<%= question.getQuestionId() %>_d" 
                                   name="question_<%= question.getQuestionId() %>" 
                                   value="D">
                            <label for="q<%= question.getQuestionId() %>_d">
                                D. <%= question.getOptionD() %>
                            </label>
                        </div>
                    </div>
                </div>
            <% 
                questionNumber++;
            } 
            %>
            
            <div class="submit-section">
                <button type="submit" class="btn btn-primary btn-large">
                    <i class="fas fa-check-circle"></i> Submit Quiz
                </button>
            </div>
        </form>
    </div>
    
    <script>
        // Timer functionality
        let timeLeft = 30 * 60; // 30 minutes in seconds
        const timerDisplay = document.getElementById('timeLeft');
        
        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft <= 0) {
                alert('Time is up! Submitting quiz...');
                document.getElementById('quizForm').submit();
            } else if (timeLeft <= 300) { // Last 5 minutes
                timerDisplay.style.color = 'var(--danger)';
            }
            
            timeLeft--;
        }
        
        setInterval(updateTimer, 1000);
        
        // Confirmation before leaving
        window.addEventListener('beforeunload', function (e) {
            e.preventDefault();
            e.returnValue = 'Are you sure you want to leave? Your progress will be lost.';
        });
        
        // Remove warning on submit
        document.getElementById('quizForm').addEventListener('submit', function() {
            window.removeEventListener('beforeunload', null);
        });
    </script>
</body>
</html>