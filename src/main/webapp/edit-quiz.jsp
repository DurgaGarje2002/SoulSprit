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
    
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("manage-quizzes.jsp");
        return;
    }
    
    int quizId = Integer.parseInt(idParam);
    QuizDAO quizDAO = new QuizDAO();
    Quiz quiz = quizDAO.getQuizById(quizId);
    
    if (quiz == null) {
        session.setAttribute("error", "Quiz not found!");
        response.sendRedirect("manage-quizzes.jsp");
        return;
    }
    
    BookDAO bookDAO = new BookDAO();
    List<Book> books = bookDAO.getAllBooks();
    
    QuestionDAO questionDAO = new QuestionDAO();
    List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
    
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Quiz - Admin</title>
    
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
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .form-container {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            max-width: 900px;
            margin: 0 auto;
        }
        
        .info-box {
            background: #E8E4F3;
            border-left: 4px solid #B4A5D9;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
            color: #5B5675;
        }
        
        .info-box i {
            color: #B4A5D9;
        }
        
        .info-box strong {
            color: #2d3436;
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
        .form-group select,
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
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #B4A5D9;
        }
        
        .question-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            border-left: 4px solid #B4A5D9;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .question-header h4 {
            color: #2d3436;
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
        
        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.875rem;
        }
        
        .btn-danger {
            background: #FF9999;
            color: white;
        }
        
        .btn-danger:hover {
            background: #ff8080;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .add-question-btn {
            width: 100%;
            padding: 1rem;
            border: 2px dashed #B4A5D9;
            background: white;
            color: #B4A5D9;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .add-question-btn:hover {
            background: #B4A5D9;
            color: white;
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
                <h2><i class="fas fa-edit"></i> Edit Quiz</h2>
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
                        Editing Quiz: <strong><%= quiz.getQuizTitle() %></strong> (ID: <%= quiz.getQuizId() %>) | 
                        Questions: <strong><%= questions.size() %></strong>
                    </div>
                    
                    <form action="UpdateQuizServlet" method="post">
                        <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>">
                        
                        <div class="form-group">
                            <label for="quizTitle">Quiz Title <span class="required">*</span></label>
                            <input type="text" id="quizTitle" name="quizTitle" 
                                   value="<%= quiz.getQuizTitle() %>" 
                                   placeholder="e.g., Chapter 1 - Understanding Mindfulness" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="bookId">Related Book <span class="required">*</span></label>
                            <select id="bookId" name="bookId" required>
                                <option value="">Select Book</option>
                                <% for (Book book : books) { %>
                                    <option value="<%= book.getBookId() %>" 
                                            <%= book.getBookId() == quiz.getBookId() ? "selected" : "" %>>
                                        <%= book.getTitle() %> by <%= book.getAuthor() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="totalMarks">Total Marks <span class="required">*</span></label>
                            <input type="number" id="totalMarks" name="totalMarks" 
                                   value="<%= quiz.getTotalMarks() %>" 
                                   placeholder="10" min="1" required>
                        </div>
                        
                        <hr style="margin: 2rem 0;">
                        
                        <h3 style="margin-bottom: 1.5rem;">Quiz Questions</h3>
                        
                        <div id="questionsContainer">
                            <% 
                            int qNum = 1;
                            for (Question q : questions) { 
                            %>
                                <div class="question-card">
                                    <div class="question-header">
                                        <h4>Question <%= qNum++ %></h4>
                                        <button type="button" class="btn btn-sm btn-danger" 
                                                onclick="deleteQuestion(<%= q.getQuestionId() %>)">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                    
                                    <input type="hidden" name="questionId[]" value="<%= q.getQuestionId() %>">
                                    
                                    <div class="form-group">
                                        <label>Question Text <span class="required">*</span></label>
                                        <textarea name="questionText[]" placeholder="Enter your question..." required><%= q.getQuestionText() %></textarea>
                                    </div>
                                    
                                    <div class="option-group">
                                        <div class="form-group">
                                            <label>Option A <span class="required">*</span></label>
                                            <input type="text" name="optionA[]" value="<%= q.getOptionA() %>" placeholder="Option A" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Option B <span class="required">*</span></label>
                                            <input type="text" name="optionB[]" value="<%= q.getOptionB() %>" placeholder="Option B" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Option C <span class="required">*</span></label>
                                            <input type="text" name="optionC[]" value="<%= q.getOptionC() %>" placeholder="Option C" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Option D <span class="required">*</span></label>
                                            <input type="text" name="optionD[]" value="<%= q.getOptionD() %>" placeholder="Option D" required>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>Correct Answer <span class="required">*</span></label>
                                        <select name="correctOption[]" required>
                                            <option value="">Select Correct Answer</option>
                                            <option value="A" <%= "A".equals(q.getCorrectOption()) ? "selected" : "" %>>A</option>
                                            <option value="B" <%= "B".equals(q.getCorrectOption()) ? "selected" : "" %>>B</option>
                                            <option value="C" <%= "C".equals(q.getCorrectOption()) ? "selected" : "" %>>C</option>
                                            <option value="D" <%= "D".equals(q.getCorrectOption()) ? "selected" : "" %>>D</option>
                                        </select>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                        
                        <button type="button" class="add-question-btn" onclick="addQuestion()">
                            <i class="fas fa-plus"></i> Add Another Question
                        </button>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Quiz
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
        let questionCount = <%= questions.size() %>;
        
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
                
                <input type="hidden" name="questionId[]" value="0">
                
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
        
        function deleteQuestion(questionId) {
            if (confirm('Are you sure you want to delete this question? This action cannot be undone.')) {
                window.location.href = 'DeleteQuestionServlet?questionId=' + questionId + '&quizId=<%= quiz.getQuizId() %>';
            }
        }
        
        function updateQuestionNumbers() {
            const questions = document.querySelectorAll('.question-card');
            questions.forEach((q, index) => {
                q.querySelector('h4').textContent = `Question ${index + 1}`;
            });
            questionCount = questions.length;
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