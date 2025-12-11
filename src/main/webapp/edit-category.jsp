<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*, com.soulsprit.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("manage-categories.jsp");
        return;
    }
    
    int categoryId = Integer.parseInt(idParam);
    CategoryDAO categoryDAO = new CategoryDAO();
    Category category = categoryDAO.getCategoryById(categoryId);
    
    if (category == null) {
        session.setAttribute("error", "Category not found!");
        response.sendRedirect("manage-categories.jsp");
        return;
    }
    
    String errorMsg = (String) session.getAttribute("error");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category - Admin</title>
    
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
            border-left-color: #9b59b6;
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
        
        .alert-error {
            padding: 1rem 1.5rem;
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .form-container {
            background: white;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2d3436;
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #9b59b6;
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }
        
        .info-box i {
            color: #2196f3;
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
                <a href="manage-categories.jsp" class="menu-item active">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
                <a href="manage-quotes.jsp" class="menu-item">
                    <i class="fas fa-quote-right"></i>
                    <span>Manage Quotes</span>
                </a>
                <a href="manage-quizzes.jsp" class="menu-item">
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
                <h2><i class="fas fa-edit"></i> Edit Category</h2>
                <div><strong><%= user.getFullName() %></strong></div>
            </div>
            
            <div class="content-area">
                <% if (errorMsg != null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMsg %>
                    </div>
                <% } %>
                
                <div class="form-container">
                    <div class="info-box">
                        <i class="fas fa-info-circle"></i>
                        Editing: <strong><%= category.getCategoryName() %></strong> (ID: <%= category.getCategoryId() %>)
                    </div>
                    
                    <form action="UpdateCategoryServlet" method="post">
                        <input type="hidden" name="categoryId" value="<%= category.getCategoryId() %>">
                        
                        <div class="form-group">
                            <label for="categoryName">Category Name <span class="required">*</span></label>
                            <input type="text" 
                                   id="categoryName" 
                                   name="categoryName" 
                                   value="<%= category.getCategoryName() %>" 
                                   placeholder="e.g., Spiritual Growth"
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" 
                                      name="description" 
                                      placeholder="Enter category description..."><%= category.getDescription() != null ? category.getDescription() : "" %></textarea>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Category
                            </button>
                            <a href="manage-categories.jsp" class="btn btn-outline">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>