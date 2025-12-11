<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*, com.soulsprit.dao.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = categoryDAO.getAllCategories();
    
    String successMsg = (String) session.getAttribute("success");
    String errorMsg = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            background: #f0f2f5;
            font-family: 'Poppins', sans-serif;
        }
        
        .admin-container { 
            display: flex; 
            min-height: 100vh; 
        }
        
        .sidebar {
            width: 280px;
            background: #2d3436;
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
        
        .sidebar-brand { 
            font-size: 1.8rem; 
            font-weight: 700;
            color: white;
        }
        
        .sidebar-menu { 
            padding: 1rem 0; 
        }
        
        .menu-item {
            padding: 1rem 2rem;
            color: rgba(255,255,255,0.7);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s;
            cursor: pointer;
            border-left: 3px solid transparent;
            text-decoration: none;
            font-weight: 400;
        }
        
        .menu-item:hover {
            background: rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.9);
        }
        
        .menu-item.active {
            background: #3d4246;
            color: white;
            border-left-color: transparent;
        }
        
        .menu-item i {
            width: 20px;
            text-align: center;
        }
        
        .main-content { 
            flex: 1; 
            margin-left: 280px; 
        }
        
        .topbar {
            background: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .topbar h2 {
            color: #5B5675;
            font-weight: 600;
            font-size: 1.75rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .topbar h2 i {
            color: #5B5675;
        }
        
        .content-area { 
            padding: 2rem; 
        }
        
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        
        .category-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        
        .category-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        
        .category-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #B4A5D9 0%, #9B8BC4 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }
        
        .category-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2d3436;
            margin-bottom: 0.5rem;
        }
        
        .category-description {
            color: #636e72;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1rem;
        }
        
        .category-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }
        
        .book-count {
            background: #E8E4F3;
            color: #5B5675;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-icon {
            width: 35px;
            height: 35px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }
        
        .btn-edit {
            background: #6EC6E6;
            color: white;
        }
        
        .btn-delete {
            background: #FF9999;
            color: white;
        }
        
        .btn-icon:hover {
            opacity: 0.85;
            transform: scale(1.05);
        }
        
        .add-category-card {
            background: linear-gradient(135deg, #B4A5D9 0%, #9B8BC4 100%);
            border-radius: 12px;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 250px;
            cursor: pointer;
            transition: transform 0.3s;
            text-decoration: none;
            color: white;
            border: 2px dashed rgba(255,255,255,0.5);
        }
        
        .add-category-card:hover {
            transform: scale(1.02);
        }
        
        .add-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .add-text {
            font-size: 1.2rem;
            font-weight: 600;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .page-header h3 {
            color: #2d3436;
            font-weight: 600;
            font-size: 1.25rem;
        }
        
        .btn-primary {
            background: #B4A5D9;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary:hover {
            background: #a294c9;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(180, 165, 217, 0.4);
        }
        
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        
        .sidebar::-webkit-scrollbar-track {
            background: rgba(0,0,0,0.1);
        }
        
        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 3px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(255,255,255,0.3);
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
                <h2><i class="fas fa-tags"></i> Manage Categories</h2>
                <div><strong><%= user.getFullName() %></strong></div>
            </div>
            
            <div class="content-area">
                <% if (successMsg != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= successMsg %>
                    </div>
                <% } %>
                
                <% if (errorMsg != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMsg %>
                    </div>
                <% } %>
                
                <div class="page-header">
                    <h3>All Categories (<%= categories.size() %>)</h3>
                    <a href="add-category.jsp" class="btn-primary">
                        <i class="fas fa-plus"></i> Add New Category
                    </a>
                </div>
                
                <div class="categories-grid">
                    <% for (Category category : categories) { 
                        int bookCount = categoryDAO.getCategoryBookCount(category.getCategoryId());
                    %>
                        <div class="category-card">
                            <div class="category-icon">
                                <i class="fas fa-book-open"></i>
                            </div>
                            <div class="category-title"><%= category.getCategoryName() %></div>
                            <div class="category-description">
                                <%= category.getDescription() != null && !category.getDescription().isEmpty() 
                                    ? category.getDescription() 
                                    : "No description available" %>
                            </div>
                            <div class="category-footer">
                                <span class="book-count">
                                    <i class="fas fa-book"></i> <%= bookCount %> books
                                </span>
                                <div class="action-buttons">
                                    <a href="edit-category.jsp?id=<%= category.getCategoryId() %>" 
                                       class="btn-icon btn-edit" 
                                       title="Edit Category">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteCategory(<%= category.getCategoryId() %>, '<%= category.getCategoryName().replace("'", "\\'") %>', <%= bookCount %>)" 
                                            class="btn-icon btn-delete" 
                                            title="Delete Category">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    
                    <!-- Add New Category Card -->
                    <a href="add-category.jsp" class="add-category-card">
                        <div class="add-icon">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <div class="add-text">Add New Category</div>
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function deleteCategory(id, name, bookCount) {
            if (bookCount > 0) {
                alert('Cannot delete category "' + name + '" because it has ' + bookCount + ' book(s).\n\nPlease reassign or delete the books first.');
                return;
            }
            
            if (confirm('Are you sure you want to delete category "' + name + '"?\n\nThis action cannot be undone.')) {
                window.location.href = 'DeleteCategoryServlet?id=' + id;
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>