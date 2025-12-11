<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Book" %>
<%@ page import="com.soulsprit.model.Bookmark" %>
<%@ page import="com.soulsprit.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Book" %>
<%@ page import="com.soulsprit.model.Bookmark" %>
<%@ page import="com.soulsprit.dao.BookmarkDAO" %>
<%@ page import="com.soulsprit.dao.BookDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    BookmarkDAO bookmarkDAO = new BookmarkDAO();
    List<Bookmark> bookmarks = bookmarkDAO.getUserBookmarks(user.getUserId());
    BookDAO bookDAO = new BookDAO();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookmarks - SoulSprit</title>
    
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
            background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);
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
        .bookmark-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        .bookmark-card {
            background: white;
            border-radius: var(--radius-md);
            padding: 2rem;
            box-shadow: 0 8px 30px var(--shadow);
            transition: var(--transition);
            position: relative;
        }
        .bookmark-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px var(--shadow-hover);
        }
        .bookmark-icon {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 1.5rem;
            color: var(--primary);
        }
        .bookmark-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        .bookmark-info {
            color: var(--text-light);
            margin-bottom: 1rem;
        }
        .bookmark-progress {
            background: var(--bg-secondary);
            height: 8px;
            border-radius: 10px;
            overflow: hidden;
            margin: 1rem 0;
        }
        .bookmark-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--primary) 0%, var(--secondary) 100%);
            transition: width 0.3s;
        }
        .bookmark-actions {
            display: flex;
            gap: 0.5rem;
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
        @media (max-width: 768px) {
            .bookmark-grid {
                grid-template-columns: 1fr;
            }
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
                <li><a href="bookmarks.jsp" class="navbar-link active"><i class="fas fa-bookmark"></i> Bookmarks</a></li>
                <li><a href="reflections.jsp" class="navbar-link"><i class="fas fa-pen"></i> Reflections</a></li>
                <li><a href="quizzes.jsp" class="navbar-link"><i class="fas fa-question-circle"></i> Quizzes</a></li>
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-bookmark"></i> My Bookmarks</h1>
            <p>Continue reading from where you left off</p>
        </div>

        <% if (bookmarks != null && !bookmarks.isEmpty()) { %>
        <div class="bookmark-grid">
            <% 
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                for (Bookmark bookmark : bookmarks) {
                    Book book = bookDAO.getBookById(bookmark.getBookId());
                    if (book != null) {
            %>
                <div class="bookmark-card">
                    <i class="fas fa-bookmark bookmark-icon"></i>
                    <div class="bookmark-title"><%= book.getTitle() %></div>
                    <div class="bookmark-info">
                        <i class="fas fa-user"></i> <%= book.getAuthor() %>
                    </div>
                    <div class="bookmark-info">
                        <i class="fas fa-clock"></i> Last read: <%= sdf.format(bookmark.getBookmarkedAt()) %>
                    </div>

                    <div class="bookmark-progress">
                        <div class="bookmark-progress-bar" style="width: <%= bookmark.getPageNumber() %>%"></div>
                    </div>
                    <small class="text-muted">Page <%= bookmark.getPageNumber() %></small>

                    <div class="bookmark-actions" style="margin-top: 1rem;">
                        <a href="reading.jsp?id=<%= book.getBookId() %>" class="btn btn-primary" style="flex: 1;">
                            <i class="fas fa-book-reader"></i> Continue Reading
                        </a>
                        <button class="btn btn-outline" onclick="removeBookmark(<%= bookmark.getBookmarkId() %>)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            <%      }
                }
            %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-bookmark"></i>
            <h3>No Bookmarks Yet</h3>
            <p style="color: var(--text-light); margin-bottom: 2rem;">
                Start reading books and bookmark them to continue later
            </p>
            <a href="library.jsp" class="btn btn-primary btn-large">
                <i class="fas fa-book"></i> Browse Library
            </a>
        </div>
        <% } %>
    </div>

    <script>
        function removeBookmark(bookmarkId) {
            if (confirm('Remove this bookmark?')) {
                // TODO: Implement delete functionality
                alert('Bookmark removed! (Feature will be implemented)');
            }
        }
    </script>
</body>
</html>
