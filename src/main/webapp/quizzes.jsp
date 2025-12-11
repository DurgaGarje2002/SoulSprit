<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quizzes - SoulSprit</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 100%);
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(180, 167, 214, 0.3);
        }
        
        .navbar-brand {
            color: white !important;
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .navbar-menu {
            display: flex;
            gap: 2rem;
            list-style: none;
            align-items: center;
        }
        
        .navbar-link {
            color: white;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: var(--radius-sm);
            transition: var(--transition);
        }
        
        .navbar-link:hover,
        .navbar-link.active {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--info) 0%, var(--primary) 100%);
            padding: 60px 20px;
            text-align: center;
            margin: 40px 0;
            border-radius: var(--radius-xl);
            color: white;
        }
        
        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: white;
        }
        
        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .quiz-card {
            background: white;
            border-radius: var(--radius-md);
            padding: 2rem;
            box-shadow: 0 8px 30px var(--shadow);
            transition: var(--transition);
        }
        
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px var(--shadow-hover);
        }
        
        .quiz-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            background: linear-gradient(135deg, var(--info) 0%, var(--primary) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin-bottom: 1rem;
        }
        
        .quiz-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .quiz-info {
            color: var(--text-light);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .quiz-stats {
            display: flex;
            gap: 1rem;
            margin: 1rem 0;
            font-size: 0.9rem;
        }
        
        .stat-badge {
            padding: 5px 12px;
            background: var(--bg-secondary);
            border-radius: 15px;
            color: var(--primary);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--radius-xl);
            box-shadow: 0 8px 30px var(--shadow);
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1rem;
            opacity: 0.3;
            color: var(--info);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="container navbar-container">
            <a href="dashboard.jsp" class="navbar-brand">
                <i class="fas fa-om"></i> SoulSprit
            </a>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp" class="navbar-link"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="library.jsp" class="navbar-link"><i class="fas fa-book"></i> Library</a></li>
                <li><a href="bookmarks.jsp" class="navbar-link"><i class="fas fa-bookmark"></i> Bookmarks</a></li>
                <li><a href="reflections.jsp" class="navbar-link"><i class="fas fa-pen"></i> Reflections</a></li>
                <li><a href="quizzes.jsp" class="navbar-link active"><i class="fas fa-question-circle"></i> Quizzes</a></li>
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Page Header -->
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-clipboard-question"></i> Available Quizzes</h1>
            <p>Test your knowledge and track your progress</p>
        </div>
        
        <!-- Sample Quizzes -->
        <div class="quiz-grid">
            <div class="quiz-card">
                <div class="quiz-icon">
                    <i class="fas fa-brain"></i>
                </div>
                <div class="quiz-title">The Power of Now - Chapter 1</div>
                <div class="quiz-info">Test your understanding of living in the present moment</div>
                <div class="quiz-stats">
                    <span class="stat-badge"><i class="fas fa-question"></i> 10 Questions</span>
                    <span class="stat-badge"><i class="fas fa-clock"></i> 15 min</span>
                </div>
                <a href="take-quiz.jsp?quizId=1" class="btn btn-primary btn-block">
                    <i class="fas fa-play"></i> Start Quiz
                </a>
            </div>
            
            <div class="quiz-card">
                <div class="quiz-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <div class="quiz-title">Think and Grow Rich - Fundamentals</div>
                <div class="quiz-info">Understanding the principles of success</div>
                <div class="quiz-stats">
                    <span class="stat-badge"><i class="fas fa-question"></i> 12 Questions</span>
                    <span class="stat-badge"><i class="fas fa-clock"></i> 20 min</span>
                </div>
                <a href="take-quiz.jsp?quizId=2" class="btn btn-primary btn-block">
                    <i class="fas fa-play"></i> Start Quiz
                </a>
            </div>
            
            <div class="quiz-card">
                <div class="quiz-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="quiz-title">7 Habits - Proactivity Quiz</div>
                <div class="quiz-info">Test your knowledge on being proactive</div>
                <div class="quiz-stats">
                    <span class="stat-badge"><i class="fas fa-question"></i> 8 Questions</span>
                    <span class="stat-badge"><i class="fas fa-clock"></i> 10 min</span>
                </div>
                <a href="take-quiz.jsp?quizId=3" class="btn btn-primary btn-block">
                    <i class="fas fa-play"></i> Start Quiz
                </a>
            </div>
        </div>
        
        <!-- Quiz History -->
        <div style="background: white; padding: 2rem; border-radius: var(--radius-xl); box-shadow: 0 8px 30px var(--shadow); margin-top: 3rem;">
            <h3 style="margin-bottom: 1.5rem;"><i class="fas fa-history"></i> Your Quiz History</h3>
            <table style="width: 100%;">
                <thead>
                    <tr style="background: var(--bg-light);">
                        <th style="padding: 1rem; text-align: left;">Quiz</th>
                        <th style="padding: 1rem; text-align: center;">Score</th>
                        <th style="padding: 1rem; text-align: center;">Date</th>
                        <th style="padding: 1rem; text-align: center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="4" style="padding: 2rem; text-align: center; color: var(--text-light);">
                            No quiz attempts yet. Start taking quizzes to see your history!
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>