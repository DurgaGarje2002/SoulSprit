<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer score = (Integer) request.getAttribute("score");
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    Double percentage = (Double) request.getAttribute("percentage");
    String quizTitle = (String) request.getAttribute("quizTitle");
    Boolean passed = (Boolean) request.getAttribute("passed");
    
    if (score == null || totalQuestions == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Results - SoulSprit</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        .result-container {
            max-width: 600px;
            width: 100%;
        }
        
        .result-card {
            background: white;
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: 0 15px 50px var(--shadow);
            text-align: center;
            animation: fadeIn 0.6s ease-out;
        }
        
        .result-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            animation: scaleIn 0.5s ease-out;
        }
        
        .result-icon.passed {
            background: linear-gradient(135deg, var(--success) 0%, var(--accent) 100%);
            color: white;
        }
        
        .result-icon.failed {
            background: linear-gradient(135deg, var(--danger) 0%, #FFB74D 100%);
            color: white;
        }
        
        .result-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        
        .result-subtitle {
            color: var(--text-light);
            margin-bottom: 2rem;
            font-size: 1.1rem;
        }
        
        .score-display {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin: 2rem 0;
        }
        
        .score-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 8px solid var(--bg-secondary);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .score-circle.passed {
            border-color: var(--success);
        }
        
        .score-circle.failed {
            border-color: var(--danger);
        }
        
        .score-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        
        .score-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .stat-item {
            padding: 1rem;
            background: var(--bg-light);
            border-radius: var(--radius-md);
        }
        
        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn-large {
            padding: 15px 30px;
            font-size: 1.1rem;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }
        
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="result-card">
            <% if (passed) { %>
                <div class="result-icon passed">
                    <i class="fas fa-trophy"></i>
                </div>
                <h1 class="result-title">Congratulations! 🎉</h1>
                <p class="result-subtitle">You passed the quiz with flying colors!</p>
            <% } else { %>
                <div class="result-icon failed">
                    <i class="fas fa-redo"></i>
                </div>
                <h1 class="result-title">Keep Practicing!</h1>
                <p class="result-subtitle">Don't give up! Review the material and try again.</p>
            <% } %>
            
            <div class="score-display">
                <div class="score-circle <%= passed ? "passed" : "failed" %>">
                    <div class="score-number"><%= String.format("%.0f", percentage) %>%</div>
                    <div class="score-label">Score</div>
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-value"><%= score %></div>
                    <div class="stat-label">Correct</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= totalQuestions - score %></div>
                    <div class="stat-label">Incorrect</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><%= totalQuestions %></div>
                    <div class="stat-label">Total</div>
                </div>
            </div>
            
            <div class="actions">
                <a href="dashboard.jsp" class="btn btn-primary btn-large" style="flex: 1;">
                    <i class="fas fa-home"></i> Back to Dashboard
                </a>
                <a href="library.jsp" class="btn btn-secondary btn-large" style="flex: 1;">
                    <i class="fas fa-book"></i> Continue Reading
                </a>
            </div>
        </div>
    </div>
    
    <script>
        // Confetti effect for passed quiz
        <% if (passed) { %>
            console.log('🎉 Quiz passed!');
        <% } %>
    </script>
</body>
</html>