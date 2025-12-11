<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Reflection" %>
<%@ page import="com.soulsprit.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Reflection" %>
<%@ page import="com.soulsprit.model.Book" %>
<%@ page import="com.soulsprit.dao.ReflectionDAO" %>
<%@ page import="com.soulsprit.dao.BookDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ReflectionDAO reflectionDAO = new ReflectionDAO();
    List<Reflection> reflections = reflectionDAO.getUserReflections(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reflections - SoulSprit</title>
    
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
            background: linear-gradient(135deg, var(--warning) 0%, var(--secondary) 100%);
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
        
        .reflection-card {
            background: white;
            border-radius: var(--radius-md);
            padding: 2rem;
            box-shadow: 0 8px 30px var(--shadow);
            margin-bottom: 2rem;
            transition: var(--transition);
            border-left: 4px solid var(--primary);
        }
        
        .reflection-card:hover {
            transform: translateX(5px);
            box-shadow: 0 12px 40px var(--shadow-hover);
        }
        
        .reflection-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .reflection-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        
        .reflection-date {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .reflection-text {
            color: var(--text-light);
            line-height: 1.8;
            margin: 1rem 0;
            font-style: italic;
        }
        
        .reflection-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        
        .add-reflection-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(180, 167, 214, 0.4);
            transition: all 0.3s;
        }
        
        .add-reflection-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 12px 35px rgba(180, 167, 214, 0.5);
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
            color: var(--primary);
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
                <li><a href="reflections.jsp" class="navbar-link active"><i class="fas fa-pen"></i> Reflections</a></li>
                <li><a href="quizzes.jsp" class="navbar-link"><i class="fas fa-question-circle"></i> Quizzes</a></li>
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Page Header -->
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-pen-fancy"></i> My Reflections</h1>
            <p>Your thoughts and insights from your readings</p>
        </div>
        
        <!-- Reflections List -->
        <% if (reflections != null && !reflections.isEmpty()) {
            BookDAO bookDAO = new BookDAO();
            for (Reflection reflection : reflections) {
                Book book = bookDAO.getBookById(reflection.getBookId());
        %>
            <div class="reflection-card">
                <div class="reflection-header">
                    <div>
                        <div class="reflection-title">
                            <i class="fas fa-book"></i> <%= book != null ? book.getTitle() : "Unknown Book" %>
                        </div>
                    </div>
                    <div class="reflection-date">
                        <i class="fas fa-calendar"></i> <%= reflection.getCreatedAt() %>
                    </div>
                </div>
                
                <div class="reflection-text">
                    "<%= reflection.getReflectionText() %>"
                </div>
                
                <div class="reflection-meta">
    				<span><i class="fas fa-calendar"></i> Added on <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(reflection.getCreatedAt()) %></span>
				</div>
        <% 
            }
        } else { 
        %>
            <div class="empty-state">
                <i class="fas fa-pen"></i>
                <h3>No Reflections Yet</h3>
                <p style="color: var(--text-light); margin-bottom: 2rem;">
                    Start adding your thoughts and insights while reading
                </p>
                <a href="library.jsp" class="btn btn-primary btn-large">
                    <i class="fas fa-book"></i> Start Reading
                </a>
            </div>
        <% } %>
    </div>
    
    <!-- Add Reflection Button -->
    <button class="add-reflection-btn" onclick="addNewReflection()">
        <i class="fas fa-plus"></i>
    </button>
    
    <script>
        function addNewReflection() {
            window.location.href = 'library.jsp';
        }
    </script>
</body>
</html>