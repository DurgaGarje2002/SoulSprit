<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*" %>
<%@ page import="com.soulsprit.dao.*" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    QuizDAO quizDAO = new QuizDAO();
    List<Quiz> quizzes = quizDAO.getAllQuizzes();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Quizzes - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body { background: #f5f7fa; }
        .admin-container { display: flex; min-height: 100vh; }
        
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #2d3436 0%, #4A4063 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding: 2rem;
            text-align: center;
            background: rgba(0,0,0,0.2);
        }
        
        .sidebar-brand { font-size: 1.8rem; font-weight: 700; }
        .sidebar-menu { padding: 1rem 0; }
        
        .menu-item {
            padding: 1rem 2rem;
            color: rgba(255,255,255,0.8);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s;
            cursor: pointer;
            border-left: 3px solid transparent;
            text-decoration: none;
        }
        
        .menu-item:hover,
        .menu-item.active {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left-color: var(--secondary);
        }
        
        .main-content { flex: 1; margin-left: 280px; }
        
        .topbar {
            background: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .content-area { padding: 2rem; }
        
        .quiz-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary);
        }
        
        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .quiz-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        
        .quiz-meta {
            display: flex;
            gap: 2rem;
            color: var(--text-light);
            margin-bottom: 1rem;
        }
        
        .quiz-meta span {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .quiz-actions {
            margin-top: 1rem;
            display: flex;
            gap: 0.5rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .stat-label {
            color: var(--text-light);
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-brand">
                    <i class="fas fa-om"></i> SoulSprit Admin
                </div>
            </div>
            
            <div class="sidebar-menu">
                <a href="admin-dashboard.jsp" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
                <a href="manage-books.jsp" class="menu-item">
                    <i class="fas fa-book"></i>
                    <span>Manage Books</span>
                </a>
                <a href="manage-categories.jsp" class="menu-item">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
                <a href="manage-quotes.jsp" class="menu-item">
                    <i class="fas fa-quote-right"></i>
                    <span>Manage Quotes</span>
                </a>
                <a href="manage-quizzes.jsp" class="menu-item active">
                    <i class="fas fa-question-circle"></i>
                    <span>Quizzes</span>
                </a>
                <a href="manage-users.jsp" class="menu-item">
                    <i class="fas fa-users"></i>
                    <span>Users</span>
                </a>
                <a href="manage-feedback.jsp" class="menu-item">
                    <i class="fas fa-comments"></i>
                    <span>Feedback</span>
                </a>
                <hr style="border-color: rgba(255,255,255,0.2); margin: 1rem 0;">
                <a href="dashboard.jsp" class="menu-item">
                    <i class="fas fa-eye"></i>
                    <span>View as User</span>
                </a>
                <a href="logout" class="menu-item">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="topbar">
                <h2><i class="fas fa-question-circle"></i> Manage Quizzes</h2>
                <div><strong><%= user.getFullName() %></strong></div>
            </div>
            
            <div class="content-area">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value"><%= quizzes.size() %></div>
                        <div class="stat-label">Total Quizzes</div>
                    </div>
                </div>
                
                <div style="margin-bottom: 2rem;">
                    <a href="add-quiz.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create New Quiz
                    </a>
                </div>
                
                <% for (Quiz quiz : quizzes) { %>
                    <div class="quiz-card">
                        <div class="quiz-header">
                            <div>
                                <div class="quiz-title"><%= quiz.getQuizTitle() %></div>
                            </div>
                        </div>
                        
                        <div class="quiz-meta">
                            <span>
                                <i class="fas fa-book"></i>
                                Book ID: <%= quiz.getBookId() %>
                            </span>
                            <span>
                                <i class="fas fa-star"></i>
                                Total Marks: <%= quiz.getTotalMarks() %>
                            </span>
                            <span>
                                <i class="fas fa-calendar"></i>
                                <%= quiz.getCreatedAt() %>
                            </span>
                        </div>
                        
                        <div class="quiz-actions">
                            <button class="btn btn-sm btn-outline" onclick="window.location.href='view-quiz.jsp?id=<%= quiz.getQuizId() %>'">
                                <i class="fas fa-eye"></i> View Questions
                            </button>
                            <button class="btn btn-sm btn-outline" onclick="window.location.href='edit-quiz.jsp?id=<%= quiz.getQuizId() %>'">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-outline" onclick="deleteQuiz(<%= quiz.getQuizId() %>)">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                <% } %>
                
                <% if (quizzes.isEmpty()) { %>
                    <div style="text-align: center; padding: 3rem; color: var(--text-light);">
                        <i class="fas fa-question-circle" style="font-size: 4rem; margin-bottom: 1rem;"></i>
                        <p>No quizzes available. Create your first quiz!</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function deleteQuiz(quizId) {
            if (confirm('Are you sure you want to delete this quiz? This will also delete all associated questions and results.')) {
                window.location.href = 'DeleteQuizServlet?id=' + quizId;
            }
        }
    </script>
</body>
</html>