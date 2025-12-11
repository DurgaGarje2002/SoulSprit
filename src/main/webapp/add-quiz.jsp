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
    
    BookDAO bookDAO = new BookDAO();
    List<Book> books = bookDAO.getAllBooks();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Quiz - Admin</title>
    
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
        
        .form-container {
            background: white;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            max-width: 900px;
            margin: 0 auto;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
        }
        
        .question-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--primary);
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .option-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .add-question-btn {
            width: 100%;
            padding: 1rem;
            border: 2px dashed var(--primary);
            background: white;
            color: var(--primary);
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .add-question-btn:hover {
            background: var(--primary);
            color: white;
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
                <h2><i class="fas fa-plus-circle"></i> Create New Quiz</h2>
                <div><strong><%= user.getFullName() %></strong></div>
            </div>
            
            <div class="content-area">
                <div class="form-container">
                    <form action="AddQuizServlet" method="post">
                        <div class="form-group">
                            <label for="quizTitle">Quiz Title <span class="required">*</span></label>
                            <input type="text" id="quizTitle" name="quizTitle" placeholder="e.g., Chapter 1 - Understanding Mindfulness" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="bookId">Related Book <span class="required">*</span></label>
                            <select id="bookId" name="bookId" required>
                                <option value="">Select Book</option>
                                <% for (Book book : books) { %>
                                    <option value="<%= book.getBookId() %>">
                                        <%= book.getTitle() %> by <%= book.getAuthor() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="totalMarks">Total Marks <span class="required">*</span></label>
                            <input type="number" id="totalMarks" name="totalMarks" placeholder="10" min="1" required>
                        </div>
                        
                        <hr style="margin: 2rem 0;">
                        
                        <h3 style="margin-bottom: 1.5rem;">Quiz Questions</h3>
                        
                        <div id="questionsContainer">
                            <!-- Question 1 -->
                            <div class="question-card">
                                <div class="question-header">
                                    <h4>Question 1</h4>
                                    <button type="button" class="btn btn-sm btn-outline" onclick="removeQuestion(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                
                                <div class="form-group">
                                    <label>Question Text <span class="required">*</span></label>
                                    <textarea name="questionText[]" placeholder="Enter your question..." required></textarea>
                                </div>
                                
                                <div class="option-group">
                                    <div class="form-group">
                                        <label>Option A <span class="required">*</span></label>
                                        <input type="text" name="optionA[]" placeholder="Option A" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Option B <span class="required">*</span></label>
                                        <input type="text" name="optionB[]" placeholder="Option B" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Option C <span class="required">*</span></label>
                                        <input type="text" name="optionC[]" placeholder="Option C" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Option D <span class="required">*</span></label>
                                        <input type="text" name="optionD[]" placeholder="Option D" required>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label>Correct Answer <span class="required">*</span></label>
                                    <select name="correctOption[]" required>
                                        <option value="">Select Correct Answer</option>
                                        <option value="A">A</option>
                                        <option value="B">B</option>
                                        <option value="C">C</option>
                                        <option value="D">D</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <button type="button" class="add-question-btn" onclick="addQuestion()">
                            <i class="fas fa-plus"></i> Add Another Question
                        </button>
                        
                        <input type="hidden" name="createdBy" value="<%= user.getUserId() %>">
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Create Quiz
                            </button>
                            <a href="manage-quizzes.jsp" class="btn btn-outline">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let questionCount = 1;
        
        function addQuestion() {
            questionCount++;
            const container = document.getElementById('questionsContainer');
            const questionCard = document.createElement('div');
            questionCard.className = 'question-card';
            questionCard.innerHTML = `
                <div class="question-header">
                    <h4>Question ${questionCount}</h4>
                    <button type="button" class="btn btn-sm btn-outline" onclick="removeQuestion(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
                
                <div class="form-group">
                    <label>Question Text <span class="required">*</span></label>
                    <textarea name="questionText[]" placeholder="Enter your question..." required></textarea>
                </div>
                
                <div class="option-group">
                    <div class="form-group">
                        <label>Option A <span class="required">*</span></label>
                        <input type="text" name="optionA[]" placeholder="Option A" required>
                    </div>
                    <div class="form-group">
                        <label>Option B <span class="required">*</span></label>
                        <input type="text" name="optionB[]" placeholder="Option B" required>
                    </div>
                    <div class="form-group">
                        <label>Option C <span class="required">*</span></label>
                        <input type="text" name="optionC[]" placeholder="Option C" required>
                    </div>
                    <div class="form-group">
                        <label>Option D <span class="required">*</span></label>
                        <input type="text" name="optionD[]" placeholder="Option D" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Correct Answer <span class="required">*</span></label>
                    <select name="correctOption[]" required>
                        <option value="">Select Correct Answer</option>
                        <option value="A">A</option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                        <option value="D">D</option>
                    </select>
                </div>
            `;
            container.appendChild(questionCard);
        }
        
        function removeQuestion(button) {
            const questionsContainer = document.getElementById('questionsContainer');
            if (questionsContainer.children.length > 1) {
                button.closest('.question-card').remove();
                updateQuestionNumbers();
            } else {
                alert('At least one question is required!');
            }
        }
        
        function updateQuestionNumbers() {
            const questions = document.querySelectorAll('.question-card');
            questions.forEach((q, index) => {
                q.querySelector('h4').textContent = `Question ${index + 1}`;
            });
            questionCount = questions.length;
        }
    </script>
</body>
</html>