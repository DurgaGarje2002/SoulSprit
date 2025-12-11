<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Quote - Admin</title>
    
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
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .form-container {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .quote-preview {
            background: linear-gradient(135deg, #B4A5D9 0%, #9B8BC4 100%);
            padding: 2.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            color: white;
            text-align: center;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .quote-preview-text {
            font-size: 1.3rem;
            line-height: 1.6;
            font-style: italic;
            margin-bottom: 1rem;
        }
        
        .quote-preview-author {
            font-size: 1.1rem;
            font-weight: 600;
            opacity: 0.9;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2d3436;
            font-size: 0.95rem;
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
            border-color: #B4A5D9;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .char-count {
            text-align: right;
            font-size: 0.875rem;
            color: #666;
            margin-top: 0.25rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn {
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
        
        .btn-primary {
            background: #B4A5D9;
            color: white;
        }
        
        .btn-primary:hover {
            background: #a294c9;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(180, 165, 217, 0.4);
        }
        
        .btn-outline {
            background: transparent;
            color: #6c757d;
            border: 1px solid #ddd;
        }
        
        .btn-outline:hover {
            background: #f8f9fa;
            border-color: #adb5bd;
        }
        
        .required {
            color: #e74c3c;
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
                <a href="manage-categories.jsp" class="menu-item">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
                <a href="manage-quotes.jsp" class="menu-item active">
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
                <h2><i class="fas fa-plus-circle"></i> Add New Quote</h2>
                <div><strong><%= user.getFullName() %></strong></div>
            </div>
            
            <div class="content-area">
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>

                <div class="form-container">
                    <div class="quote-preview">
                        <div class="quote-preview-text" id="previewText">"<em>Your inspiring quote will appear here...</em>"</div>
                        <div class="quote-preview-author" id="previewAuthor">— Author Name</div>
                    </div>

                    <form action="<%= request.getContextPath() %>/AddQuoteServlet" method="post" onsubmit="return validateForm()">
                        <div class="form-group">
                            <label for="quoteText">Quote Text <span class="required">*</span></label>
                            <textarea id="quoteText" name="quoteText" placeholder="Enter an inspiring quote..." required></textarea>
                            <div class="char-count"><span id="charCount">0</span> / 500 characters</div>
                        </div>

                        <div class="form-group">
                            <label for="author">Author <span class="required">*</span></label>
                            <input type="text" id="author" name="author" placeholder="e.g., Buddha, Mahatma Gandhi" required>
                        </div>

                        <input type="hidden" name="createdBy" value="<%= user.getUserId() %>">

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Add Quote
                            </button>
                            <a href="<%= request.getContextPath() %>/manage-quotes.jsp" class="btn btn-outline">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        const quoteTextarea = document.getElementById('quoteText');
        const authorInput = document.getElementById('author');
        const previewText = document.getElementById('previewText');
        const previewAuthor = document.getElementById('previewAuthor');
        const charCount = document.getElementById('charCount');

        if (quoteTextarea) {
            quoteTextarea.addEventListener('input', function() {
                const text = this.value.trim();
                const count = text.length;
                if (text) previewText.innerHTML = '"<em>' + escapeHtml(text) + '</em>"';
                else previewText.innerHTML = '"<em>Your inspiring quote will appear here...</em>"';
                charCount.textContent = count;
                if (count > 500) { 
                    this.value = this.value.substring(0, 500); 
                    charCount.textContent = '500'; 
                }
                if (count > 450) charCount.style.color = '#e74c3c';
                else if (count > 400) charCount.style.color = '#f39c12';
                else charCount.style.color = '#666';
            });
        }
        
        if (authorInput) {
            authorInput.addEventListener('input', function() {
                previewAuthor.textContent = this.value.trim() ? '— ' + this.value.trim() : '— Author Name';
            });
        }
        
        function validateForm() {
            const quoteText = quoteTextarea.value.trim();
            const author = authorInput.value.trim();
            if (!quoteText || !author) { 
                alert('Please fill in all required fields!'); 
                return false; 
            }
            if (quoteText.length < 10) { 
                alert('Quote text should be at least 10 characters long!'); 
                return false; 
            }
            return true;
        }
        
        function escapeHtml(text) { 
            const div = document.createElement('div'); 
            div.textContent = text; 
            return div.innerHTML; 
        }
        
        // Auto-hide error alert after 5 seconds
        setTimeout(function() {
            const alert = document.querySelector('.alert-error');
            if (alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            }
        }, 5000);
    </script>
</body>
</html>