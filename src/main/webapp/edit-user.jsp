<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*" %>
<%@ page import="com.soulsprit.dao.*" %>

<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Read user ID
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("manage-users.jsp");
        return;
    }

    int userId = Integer.parseInt(idParam);

    UserDAO userDAO = new UserDAO();
    User editUser = userDAO.getUserById(userId);

    if (editUser == null) {
        response.sendRedirect("manage-users.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - Admin</title>

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

        .menu-item {
            padding: 1rem 2rem;
            color: rgba(255,255,255,0.8);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s;
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

        .content-area {
            padding: 2rem;
        }

        .form-container {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            max-width: 550px;
            margin: auto;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .form-container h3 {
            margin-bottom: 1.5rem;
            color: var(--primary);
            font-weight: 600;
        }

        .form-group { margin-bottom: 1.2rem; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 0.4rem; }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 0.8rem 1.2rem;
            border: none;
            width: 100%;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1rem;
            margin-top: 1rem;
        }

        .btn-primary:hover { opacity: 0.9; }

        .back-btn {
            margin-top: 1rem;
            display: block;
            text-align: center;
            text-decoration: none;
            color: var(--primary);
            font-weight: 500;
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
            <a href="admin-dashboard.jsp" class="menu-item"><i class="fas fa-tachometer-alt"></i>Dashboard</a>
            <a href="manage-books.jsp" class="menu-item"><i class="fas fa-book"></i>Manage Books</a>
            <a href="manage-categories.jsp" class="menu-item"><i class="fas fa-tags"></i>Categories</a>
            <a href="manage-quotes.jsp" class="menu-item"><i class="fas fa-quote-right"></i>Manage Quotes</a>
            <a href="manage-quizzes.jsp" class="menu-item"><i class="fas fa-question-circle"></i>Quizzes</a>
            <a href="manage-users.jsp" class="menu-item active"><i class="fas fa-users"></i>Users</a>
            <a href="manage-feedback.jsp" class="menu-item"><i class="fas fa-comments"></i>Feedback</a>

            <hr style="border-color: rgba(255,255,255,0.2); margin: 1rem 0;">

            <a href="dashboard.jsp" class="menu-item"><i class="fas fa-eye"></i>View as User</a>
            <a href="logout" class="menu-item"><i class="fas fa-sign-out-alt"></i>Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">

        <div class="topbar">
            <h2><i class="fas fa-edit"></i> Edit User</h2>
            <div><strong><%= adminUser.getFullName() %></strong></div>
        </div>

        <div class="content-area">

            <div class="form-container">
                <h3>Edit User Details</h3>

                <form action="UpdateUserServlet" method="post">

                    <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">

                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="<%= editUser.getFullName() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= editUser.getEmail() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Role</label>
                        <select name="role" required>
                            <option value="student" <%= editUser.getRole().equals("student") ? "selected" : "" %>>Student</option>
                            <option value="teacher" <%= editUser.getRole().equals("teacher") ? "selected" : "" %>>Teacher</option>
                            <option value="admin" <%= editUser.getRole().equals("admin") ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-primary">Update User</button>

                </form>

                <a class="back-btn" href="manage-users.jsp"><i class="fas fa-arrow-left"></i> Back to Users</a>
            </div>

        </div>

    </div>
</div>

</body>
</html>
