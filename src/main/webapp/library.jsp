<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%@ page import="com.soulsprit.model.Book" %>
<%@ page import="com.soulsprit.model.Category" %>
<%@ page import="com.soulsprit.dao.BookDAO" %>
<%@ page import="com.soulsprit.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    BookDAO bookDAO = new BookDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    
    List<Book> books = bookDAO.getAllBooks();
    List<Category> categories = categoryDAO.getAllCategories();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library - SoulSprit</title>
    
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
            transition: var(--transition);
            padding: 8px 16px;
            border-radius: var(--radius-sm);
        }
        
        .navbar-link:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);
            padding: 60px 20px;
            text-align: center;
            margin: 40px 0;
            border-radius: var(--radius-xl);
            color: white;
        }
        
        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: white;
        }
        
        .search-box {
            max-width: 600px;
            margin: 2rem auto;
            position: relative;
        }
        
        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border-radius: var(--radius-lg);
            border: none;
            font-size: 1rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .search-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border: none;
            padding: 10px 20px;
            border-radius: var(--radius-md);
            color: white;
            cursor: pointer;
        }
        
        .filter-section {
            background: white;
            padding: 2rem;
            border-radius: var(--radius-md);
            box-shadow: 0 4px 20px var(--shadow);
            margin-bottom: 3rem;
        }
        
        .filter-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        
        .filter-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .filter-chip {
            padding: 10px 20px;
            border: 2px solid var(--bg-secondary);
            border-radius: var(--radius-lg);
            background: white;
            cursor: pointer;
            transition: var(--transition);
            font-weight: 500;
        }
        
        .filter-chip:hover,
        .filter-chip.active {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border-color: transparent;
        }
        
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .book-card {
            background: white;
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: 0 8px 30px var(--shadow);
            transition: var(--transition);
            cursor: pointer;
        }
        
        .book-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 45px var(--shadow-hover);
        }
        
        .book-cover {
            width: 100%;
            height: 320px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
            position: relative;
        }
        
        .book-cover:nth-child(2n) {
            background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);
        }
        
        .book-cover:nth-child(3n) {
            background: linear-gradient(135deg, var(--warning) 0%, var(--secondary) 100%);
        }
        
        .book-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.95);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .book-info {
            padding: 1.5rem;
        }
        
        .book-category {
            display: inline-block;
            padding: 4px 12px;
            background: var(--bg-secondary);
            color: var(--primary);
            border-radius: 15px;
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }
        
        .book-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            min-height: 60px;
        }
        
        .book-author {
            color: var(--text-light);
            font-size: 0.95rem;
            margin-bottom: 1rem;
        }
        
        .book-description {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-read {
            flex: 1;
        }
        
        .btn-bookmark {
            background: var(--bg-secondary);
            color: var(--primary);
            padding: 10px 15px;
            border-radius: var(--radius-md);
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .btn-bookmark:hover {
            background: var(--primary);
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-light);
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
        
        @media (max-width: 768px) {
            .book-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
            
            .page-header h1 {
                font-size: 2rem;
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
                <li><a href="library.jsp" class="navbar-link active"><i class="fas fa-book"></i> Library</a></li>
                <li><a href="bookmarks.jsp" class="navbar-link"><i class="fas fa-bookmark"></i> Bookmarks</a></li>
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Page Header -->
    <div class="container">
        <div class="page-header">
            <h1><i class="fas fa-book-open"></i> Book Library</h1>
            <p>Explore our collection of spiritual and motivational books</p>
            
            <div class="search-box">
                <input type="text" 
                       class="search-input" 
                       id="searchInput"
                       placeholder="Search books by title or author...">
                <button class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-title">
                <i class="fas fa-filter"></i> Filter by Category
            </div>
            <div class="filter-chips">
                <button class="filter-chip active" data-category="all">
                    <i class="fas fa-star"></i> All Books
                </button>
                <% for (Category category : categories) { %>
                    <button class="filter-chip" data-category="<%= category.getCategoryId() %>">
                        <i class="fas fa-book"></i> <%= category.getCategoryName() %>
                    </button>
                <% } %>
            </div>
        </div>
        
        <!-- Book Grid -->
        <div class="book-grid" id="bookGrid">
            <% 
            if (books != null && !books.isEmpty()) {
                int colorIndex = 0;
                for (Book book : books) { 
                    colorIndex++;
            %>
                <div class="book-card" data-category="<%= book.getCategoryId() %>" 
                     data-title="<%= book.getTitle().toLowerCase() %>" 
                     data-author="<%= book.getAuthor().toLowerCase() %>">
                    <div class="book-cover book-cover-<%= colorIndex %>">
                        <i class="fas fa-book"></i>
                        <% if (colorIndex % 3 == 0) { %>
                            <div class="book-badge" style="color: var(--primary);">Popular</div>
                        <% } %>
                    </div>
                    <div class="book-info">
                        <div class="book-category">
                            <%= book.getCategoryName() != null ? book.getCategoryName() : "General" %>
                        </div>
                        <div class="book-title"><%= book.getTitle() %></div>
                        <div class="book-author">by <%= book.getAuthor() %></div>
                        <div class="book-description">
                            <%= book.getDescription() != null ? book.getDescription() : "A wonderful book to enhance your spiritual journey." %>
                        </div>
                        <div class="book-actions">
                            <a href="book-detail.jsp?id=<%= book.getBookId() %>" class="btn btn-primary btn-read">
                                <i class="fas fa-book-reader"></i> Read Now
                            </a>
                            <button class="btn-bookmark" onclick="addBookmark(<%= book.getBookId() %>)">
                                <i class="fas fa-bookmark"></i>
                            </button>
                        </div>
                    </div>
                </div>
            <% 
                }
            } else { 
            %>
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h3>No Books Available</h3>
                    <p>Check back later for new additions to our library</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        // Category Filter
        const filterChips = document.querySelectorAll('.filter-chip');
        const bookCards = document.querySelectorAll('.book-card');
        
        filterChips.forEach(chip => {
            chip.addEventListener('click', function() {
                const category = this.getAttribute('data-category');
                
                // Update active state
                filterChips.forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                
                // Filter books
                bookCards.forEach(card => {
                    if (category === 'all' || card.getAttribute('data-category') === category) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
        
        // Search Functionality
        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            
            bookCards.forEach(card => {
                const title = card.getAttribute('data-title');
                const author = card.getAttribute('data-author');
                
                if (title.includes(searchTerm) || author.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
        
        // Add Bookmark
        function addBookmark(bookId) {
            alert('Book bookmarked! (Feature will be implemented)');
        }
    </script>
</body>
</html>