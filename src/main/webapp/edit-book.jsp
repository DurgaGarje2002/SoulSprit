<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*" %>
<%@ page import="com.soulsprit.dao.*" %>
<%@ page import="java.util.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int bookId = Integer.parseInt(request.getParameter("id"));
    BookDAO bookDAO = new BookDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    Book book = bookDAO.getBookById(bookId);
    List<Category> categories = categoryDAO.getAllCategories();

    if (book == null) {
        request.setAttribute("error", "Book not found!");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Book - SoulSprit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { background: linear-gradient(135deg, #f7f8fc 0%, #edf1f7 100%); }
        .edit-container {
            max-width: 800px;
            margin: 3rem auto;
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .edit-container h1 { text-align: center; margin-bottom: 2rem; color: #333; }
        .form-group { margin-bottom: 1.5rem; }
        .form-label { font-weight: 600; display: block; margin-bottom: 0.5rem; }
        .form-control {
            width: 100%; padding: 0.8rem; border: 1px solid #ccc; border-radius: 8px;
        }
        button {
            background: var(--primary);
            border: none; color: white;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover { background: var(--secondary); }
        .back-link {
            display: inline-flex; align-items: center; color: var(--primary);
            text-decoration: none; margin-bottom: 1rem;
        }
        .back-link:hover { color: var(--secondary); }
    </style>
</head>
<body>
    <div class="edit-container">
        <a href="manage-books.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Manage Books
        </a>

        <h1><i class="fas fa-edit"></i> Edit Book</h1>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <% if (book != null) { %>
        <!-- ✅ FIXED FORM ACTION -->
        <form action="${pageContext.request.contextPath}/EditBookServlet" method="post">
            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">

            <div class="form-group">
                <label class="form-label">Title</label>
                <input type="text" name="title" class="form-control" value="<%= book.getTitle() %>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Author</label>
                <input type="text" name="author" class="form-control" value="<%= book.getAuthor() %>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Category</label>
                <select name="categoryId" class="form-control" required>
                    <% for (Category c : categories) { %>
                        <option value="<%= c.getCategoryId() %>" 
                            <%= c.getCategoryId() == book.getCategoryId() ? "selected" : "" %>>
                            <%= c.getCategoryName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" rows="5" class="form-control" required><%= book.getDescription() %></textarea>
            </div>

            <div class="form-group" style="text-align:center;">
                <button type="submit"><i class="fas fa-save"></i> Update Book</button>
            </div>
        </form>
        <% } %>
    </div>
</body>
</html>
