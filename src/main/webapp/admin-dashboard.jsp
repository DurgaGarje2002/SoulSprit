<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get statistics
    UserDAO userDAO = new UserDAO();
    BookDAO bookDAO = new BookDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    int totalUsers = userDAO.getAllUsers().size();
    int totalBooks = bookDAO.getAllBooks().size();
    int totalCategories = categoryDAO.getAllCategories().size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SoulSprit</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">

    <style>
        body { background: #f5f7fa; }
        .admin-container { display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #2d3436 0%, #4A4063 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }
        .sidebar-header { padding: 2rem; text-align: center; background: rgba(0,0,0,0.2); }
        .sidebar-brand { font-size: 1.8rem; font-weight: 700; }
        .sidebar-menu { padding: 1rem 0; }
        .menu-item {
            padding: 1rem 2rem;
            color: rgba(255,255,255,0.8);
            display: flex; align-items: center; gap: 1rem;
            transition: 0.3s; cursor: pointer; border-left: 3px solid transparent;
        }
        .menu-item:hover, .menu-item.active {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left-color: var(--secondary);
        }
        .menu-item i { width: 20px; }

        /* Main */
        .main-content { flex: 1; margin-left: 280px; }
        .topbar {
            background: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex; justify-content: space-between; align-items: center;
        }
        .topbar-title { font-size: 1.8rem; font-weight: 600; }
        .admin-avatar {
            width: 45px; height: 45px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white; font-weight: 700; display: flex; align-items: center; justify-content: center;
        }
        .content-area { padding: 2rem; }

        /* Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem; margin-bottom: 3rem;
        }
        .stat-card {
            background: white; padding: 2rem; border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-left: 4px solid; transition: 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card.primary { border-left-color: var(--primary); }
        .stat-card.success { border-left-color: var(--accent); }
        .stat-card.warning { border-left-color: var(--warning); }
        .stat-card.info { border-left-color: var(--info); }

        .stat-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .stat-icon {
            width: 50px; height: 50px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; color: white;
        }

        .quick-actions {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }
        .section-title { font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem; }
        .action-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }
        .action-btn {
            padding: 1.5rem; background: var(--bg-light);
            border-radius: 10px; text-align: center;
            cursor: pointer; transition: 0.3s;
        }
        .action-btn:hover { background: white; border-color: var(--primary); transform: translateY(-3px); }

        @media (max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>
<div class="admin-container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-brand"><i class="fas fa-om"></i> SoulSprit Admin</div>
        </div>
        <div class="sidebar-menu">
            <div class="menu-item active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></div>
            <div class="menu-item" onclick="window.location.href='manage-books.jsp'"><i class="fas fa-book"></i><span>Manage Books</span></div>
            <div class="menu-item" onclick="window.location.href='manage-categories.jsp'"><i class="fas fa-tags"></i><span>Categories</span></div>
            <div class="menu-item" onclick="window.location.href='manage-quotes.jsp'"><i class="fas fa-quote-right"></i><span>Manage Quotes</span></div>
            <div class="menu-item" onclick="window.location.href='manage-quizzes.jsp'"><i class="fas fa-question-circle"></i><span>Quizzes</span></div>
            <div class="menu-item" onclick="window.location.href='manage-users.jsp'"><i class="fas fa-users"></i><span>Users</span></div>
            <div class="menu-item" onclick="window.location.href='manage-feedback.jsp'"><i class="fas fa-comments"></i><span>Feedback</span></div>
            <hr style="border-color: rgba(255,255,255,0.2); margin: 1rem 0;">
            <div class="menu-item" onclick="window.location.href='dashboard.jsp'"><i class="fas fa-eye"></i><span>View as User</span></div>
            <div class="menu-item" onclick="window.location.href='logout'"><i class="fas fa-sign-out-alt"></i><span>Logout</span></div>
        </div>
    </div>

    <!-- Main -->
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title"><i class="fas fa-chart-line"></i> Dashboard Overview</div>
            <div class="admin-profile">
                <div>
                    <strong><%= user.getFullName() %></strong>
                    <br><small style="color: var(--text-light);">Administrator</small>
                </div>
                <div class="admin-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><%= totalUsers %></div>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-icon primary"><i class="fas fa-users"></i></div>
                    </div>
                </div>

                <div class="stat-card success">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><%= totalBooks %></div>
                            <div class="stat-label">Books Available</div>
                        </div>
                        <div class="stat-icon success"><i class="fas fa-book"></i></div>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><%= totalCategories %></div>
                            <div class="stat-label">Categories</div>
                        </div>
                        <div class="stat-icon warning"><i class="fas fa-tags"></i></div>
                    </div>
                </div>

                <div class="stat-card info">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number">156</div>
                            <div class="stat-label">Total Reads</div>
                        </div>
                        <div class="stat-icon info"><i class="fas fa-book-reader"></i></div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <div class="section-title"><i class="fas fa-bolt"></i> Quick Actions</div>
                <div class="action-grid">
                    <div class="action-btn" onclick="window.location.href='add-book.jsp'"><i class="fas fa-plus-circle"></i><div class="action-title">Add New Book</div></div>
                    <div class="action-btn" onclick="window.location.href='add-quote.jsp'"><i class="fas fa-quote-left"></i><div class="action-title">Add Quote</div></div>
                    <div class="action-btn" onclick="window.location.href='add-quiz.jsp'"><i class="fas fa-clipboard-question"></i><div class="action-title">Create Quiz</div></div>
                    <div class="action-btn" onclick="window.location.href='manage-users.jsp'"><i class="fas fa-user-plus"></i><div class="action-title">Manage Users</div></div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="quick-actions">
                <div class="section-title"><i class="fas fa-history"></i> Recent Activity</div>
                <table style="width:100%;">
                    <thead>
                        <tr style="background: var(--bg-light);">
                            <th style="padding:1rem;text-align:left;">User</th>
                            <th style="padding:1rem;text-align:left;">Action</th>
                            <th style="padding:1rem;text-align:left;">Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td style="padding:1rem;">John Doe</td><td style="padding:1rem;">Started reading "The Power of Now"</td><td style="padding:1rem;color:var(--text-light);">2 hours ago</td></tr>
                        <tr><td style="padding:1rem;">Jane Smith</td><td style="padding:1rem;">Completed quiz on Chapter 3</td><td style="padding:1rem;color:var(--text-light);">5 hours ago</td></tr>
                        <tr><td style="padding:1rem;">Mike Johnson</td><td style="padding:1rem;">Added a reflection</td><td style="padding:1rem;color:var(--text-light);">1 day ago</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
