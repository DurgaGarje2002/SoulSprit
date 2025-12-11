<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Category" %>
<%@ page import="com.soulsprit.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = categoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Book - SoulSprit Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 100%);
        }
        
        .page-container {
            max-width: 800px;
            margin: 3rem auto;
            padding: 0 2rem;
        }
        
        .form-card {
            background: white;
            padding: 3rem;
            border-radius: var(--radius-xl);
            box-shadow: 0 10px 40px var(--shadow);
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .form-header h1 {
            font-size: 2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary);
            margin-bottom: 2rem;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-link:hover {
            color: var(--secondary);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="page-container">
        <a href="admin-dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        
        <div class="form-card">
            <div class="form-header">
                <h1><i class="fas fa-book"></i> Add New Book</h1>
                <p style="color: var(--text-light);">Fill in the details to add a new book to the library</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form action="AddBookServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title" class="form-label">
                        <i class="fas fa-heading"></i> Book Title *
                    </label>
                    <input type="text" 
                           class="form-control" 
                           id="title" 
                           name="title" 
                           placeholder="Enter book title"
                           required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="author" class="form-label">
                            <i class="fas fa-user-edit"></i> Author *
                        </label>
                        <input type="text" 
                               class="form-control" 
                               id="author" 
                               name="author" 
                               placeholder="Author name"
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label for="category" class="form-label">
                            <i class="fas fa-tag"></i> Category *
                        </label>
                        <select class="form-control" id="category" name="categoryId" required>
                            <option value="">Select category</option>
                            <% for (Category category : categories) { %>
                                <option value="<%= category.getCategoryId() %>">
                                    <%= category.getCategoryName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">
                        <i class="fas fa-align-left"></i> Description *
                    </label>
                    <textarea class="form-control" 
                              id="description" 
                              name="description" 
                              rows="5" 
                              placeholder="Enter book description"
                              required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="pdfFile" class="form-label">
                        <i class="fas fa-file-pdf"></i> Upload PDF (Optional)
                    </label>
                    <input type="file" 
                           class="form-control" 
                           id="pdfFile" 
                           name="pdfFile" 
                           accept=".pdf">
                    <small class="text-muted">Maximum file size: 10MB</small>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-block btn-large">
                        <i class="fas fa-plus-circle"></i> Add Book
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>