<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Book" %>
<%@ page import="com.soulsprit.dao.BookDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String bookIdParam = request.getParameter("id");
    if (bookIdParam == null) {
        response.sendRedirect("library.jsp");
        return;
    }
    
    int bookId = Integer.parseInt(bookIdParam);
    BookDAO bookDAO = new BookDAO();
    Book book = bookDAO.getBookById(bookId);
    
    if (book == null) {
        response.sendRedirect("library.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= book.getTitle() %> - SoulSprit</title>
    
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
        
        .navbar-link:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .book-detail-container {
            margin: 3rem 0;
        }
        
        .book-detail-card {
            background: white;
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: 0 10px 40px var(--shadow);
        }
        
        .book-header {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }
        
        .book-cover-large {
            width: 100%;
            height: 450px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 6rem;
            box-shadow: 0 10px 30px var(--shadow);
        }
        
        .book-meta {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .book-category-badge {
            display: inline-block;
            padding: 8px 20px;
            background: var(--bg-secondary);
            color: var(--primary);
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 1rem;
            width: fit-content;
        }
        
        .book-title-large {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }
        
        .book-author-large {
            font-size: 1.3rem;
            color: var(--text-light);
            margin-bottom: 2rem;
        }
        
        .book-stats {
            display: flex;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-light);
        }
        
        .stat-item i {
            color: var(--primary);
        }
        
        .book-actions-large {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .btn-large {
            padding: 15px 40px;
            font-size: 1.1rem;
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 3rem 0 1.5rem;
        }
        
        .book-description-full {
            color: var(--text-light);
            font-size: 1.1rem;
            line-height: 1.8;
            margin-bottom: 2rem;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        
        .feature-item {
            background: var(--bg-primary);
            padding: 1.5rem;
            border-radius: var(--radius-md);
            text-align: center;
        }
        
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .feature-title {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .feature-desc {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .book-header {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .book-cover-large {
                height: 350px;
                font-size: 4rem;
            }
            
            .book-title-large {
                font-size: 2rem;
            }
            
            .book-actions-large {
                flex-direction: column;
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
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Book Detail -->
    <div class="container book-detail-container">
        <div class="book-detail-card">
            <div class="book-header">
                <div class="book-cover-large">
                    <i class="fas fa-book"></i>
                </div>
                
                <div class="book-meta">
                    <div class="book-category-badge">
                        <i class="fas fa-tag"></i> <%= book.getCategoryName() != null ? book.getCategoryName() : "General" %>
                    </div>
                    
                    <h1 class="book-title-large"><%= book.getTitle() %></h1>
                    <div class="book-author-large">
                        <i class="fas fa-user"></i> by <%= book.getAuthor() %>
                    </div>
                    
                    <div class="book-stats">
                        <div class="stat-item">
                            <i class="fas fa-star"></i>
                            <span>4.8 Rating</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-eye"></i>
                            <span>1.2k Reads</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-bookmark"></i>
                            <span>234 Saved</span>
                        </div>
                    </div>
                    
                    <div class="book-actions-large">
                        <a href="reading.jsp?id=<%= book.getBookId() %>" class="btn btn-primary btn-large">
                            <i class="fas fa-book-reader"></i> Start Reading
                        </a>
                        <button class="btn btn-secondary btn-large" onclick="addToBookmarks()">
                            <i class="fas fa-bookmark"></i> Bookmark
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Description -->
            <h2 class="section-title">About This Book</h2>
            <div class="book-description-full">
                <%= book.getDescription() != null ? book.getDescription() : 
                    "This transformative book will guide you on a journey of self-discovery and spiritual growth. Through powerful insights and practical wisdom, you'll learn to unlock your inner potential and find true peace within yourself." %>
			</div>
			
			<!-- Features -->
        <h2 class="section-title">What You'll Learn</h2>
        <div class="features-grid">
            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-brain"></i>
                </div>
                <div class="feature-title">Mindfulness</div>
                <div class="feature-desc">Practice presence and awareness</div>
            </div>
            
            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="feature-title">Inner Peace</div>
                <div class="feature-desc">Find calm in daily life</div>
            </div>
            
            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <div class="feature-title">Wisdom</div>
                <div class="feature-desc">Gain spiritual insights</div>
            </div>
            
            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="feature-title">Growth</div>
                <div class="feature-desc">Personal transformation</div>
            </div>
        </div>
    </div>
</div>

<script>
    function addToBookmarks() {
        alert('Book added to bookmarks! (Feature will be implemented)');
    }
</script>

</body>
</html>

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			