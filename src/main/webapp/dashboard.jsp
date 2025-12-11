<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SoulSprit</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary: #B4A7D6;
            --secondary: #D4A5F6;
            --accent: #A8E6CF;
            --info: #93D9E8;
            --success: #7FD89E;
            --warning: #FFD6A5;
            --bg-light: #FFF9F0;
            --bg-secondary: #F5F0FF;
            --text-dark: #2C3E50;
            --text-light: #6C757D;
            --text-muted: #9CA3AF;
            --shadow: rgba(180, 167, 214, 0.2);
            --shadow-hover: rgba(180, 167, 214, 0.35);
            --transition: all 0.3s ease;
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 24px;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }
        
        /* Animated Background Elements */
        .bg-decoration {
            position: fixed;
            border-radius: 50%;
            opacity: 0.05;
            pointer-events: none;
            z-index: 0;
        }
        
        .bg-decoration-1 {
            width: 400px;
            height: 400px;
            background: var(--primary);
            top: -100px;
            right: -100px;
            animation: float 8s ease-in-out infinite;
        }
        
        .bg-decoration-2 {
            width: 300px;
            height: 300px;
            background: var(--accent);
            bottom: -100px;
            left: -100px;
            animation: float 10s ease-in-out infinite reverse;
        }
        
        .bg-decoration-3 {
            width: 200px;
            height: 200px;
            background: var(--info);
            top: 40%;
            right: 10%;
            animation: float 12s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0) scale(1);
            }
            50% {
                transform: translateY(-30px) scale(1.1);
            }
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }
        
        /* Navbar */
        .navbar {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(180, 167, 214, 0.3);
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }
        
        .navbar-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar-brand {
            color: white !important;
            font-size: 1.8rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: var(--transition);
        }
        
        .navbar-brand:hover {
            transform: scale(1.05);
        }
        
        .navbar-menu {
            display: flex;
            gap: 1.5rem;
            list-style: none;
            align-items: center;
        }
        
        .navbar-link {
            color: white;
            font-weight: 500;
            transition: var(--transition);
            padding: 10px 18px;
            border-radius: var(--radius-sm);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .navbar-link:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateY(-2px);
        }
        
        .navbar-link.active {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-lg);
            transition: var(--transition);
            cursor: pointer;
        }
        
        .user-profile:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }
        
        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: white;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        /* Hero Quote Section */
        .quote-section {
            background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);
            padding: 80px 40px;
            margin: 40px 0;
            border-radius: var(--radius-xl);
            text-align: center;
            box-shadow: 0 15px 50px rgba(168, 230, 207, 0.4);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }
        
        .quote-section::before {
            content: '"';
            position: absolute;
            top: -50px;
            left: 40px;
            font-size: 250px;
            opacity: 0.08;
            font-family: Georgia, serif;
            color: white;
        }
        
        .quote-text {
            font-size: clamp(1.5rem, 3vw, 2.8rem);
            font-weight: 500;
            font-style: italic;
            color: white;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .quote-author {
            font-size: 1.3rem;
            color: white;
            opacity: 0.95;
            font-weight: 600;
        }
        
        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }
        
        .stat-card {
            background: white;
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            box-shadow: 0 10px 35px var(--shadow);
            text-align: center;
            transition: var(--transition);
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out backwards;
        }
        
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, var(--primary) 0%, transparent 70%);
            opacity: 0;
            transition: var(--transition);
        }
        
        .stat-card:hover {
            transform: translateY(-10px) scale(1.03);
            border-color: var(--primary);
            box-shadow: 0 20px 50px var(--shadow-hover);
        }
        
        .stat-card:hover::before {
            opacity: 0.05;
            animation: rotate 20s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .stat-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            color: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            transition: var(--transition);
        }
        
        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
        }
        
        .stat-icon.purple {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        }
        
        .stat-icon.green {
            background: linear-gradient(135deg, var(--accent) 0%, var(--success) 100%);
        }
        
        .stat-icon.blue {
            background: linear-gradient(135deg, var(--info) 0%, var(--primary) 100%);
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }
        
        .stat-label {
            color: var(--text-light);
            font-size: 1.1rem;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }
        
        /* Section Heading */
        .section-heading {
            font-size: 2.2rem;
            color: var(--text-dark);
            margin: 4rem 0 2rem;
            position: relative;
            padding-bottom: 1rem;
            font-weight: 700;
            animation: fadeIn 0.6s ease-out;
        }
        
        .section-heading::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100px;
            height: 5px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border-radius: 10px;
        }
        
        /* Categories */
        .categories {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin: 2rem 0 3rem;
            animation: fadeIn 0.8s ease-out;
        }
        
        .category-btn {
            padding: 14px 28px;
            background: white;
            border: 2px solid var(--bg-secondary);
            border-radius: var(--radius-lg);
            color: var(--text-dark);
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        
        .category-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(180, 167, 214, 0.3);
        }
        
        .category-btn.active {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 8px 25px rgba(180, 167, 214, 0.4);
        }
        
        /* Book Grid */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2.5rem;
            margin-bottom: 4rem;
        }
        
        .book-card {
            background: white;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: 0 10px 35px var(--shadow);
            transition: var(--transition);
            cursor: pointer;
            animation: fadeInUp 0.6s ease-out backwards;
        }
        
        .book-card:nth-child(1) { animation-delay: 0.1s; }
        .book-card:nth-child(2) { animation-delay: 0.2s; }
        .book-card:nth-child(3) { animation-delay: 0.3s; }
        
        .book-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 60px var(--shadow-hover);
        }
        
        .book-cover {
            width: 100%;
            height: 350px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
            position: relative;
            overflow: hidden;
        }
        
        .book-cover::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, transparent 0%, rgba(0,0,0,0.2) 100%);
            opacity: 0;
            transition: var(--transition);
        }
        
        .book-card:hover .book-cover::before {
            opacity: 1;
        }
        
        .book-card:hover .book-cover i {
            transform: scale(1.1) rotate(5deg);
        }
        
        .book-cover i {
            transition: var(--transition);
            position: relative;
            z-index: 1;
        }
        
        .book-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.95);
            padding: 8px 18px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--primary);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 2;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .book-info {
            padding: 2rem;
        }
        
        .book-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.8rem;
            line-height: 1.4;
        }
        
        .book-author {
            color: var(--text-light);
            font-size: 1rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .book-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            color: var(--text-muted);
            font-weight: 500;
        }
        
        .book-meta i {
            color: var(--warning);
        }
        
        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(180, 167, 214, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(180, 167, 214, 0.5);
        }
        
        .btn-read {
            width: 100%;
        }
        
        .mobile-menu-toggle {
            display: none;
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
        }
        
        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .navbar-menu {
                position: fixed;
                top: 70px;
                left: -100%;
                width: 100%;
                background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
                flex-direction: column;
                padding: 2rem;
                transition: var(--transition);
                box-shadow: 0 8px 30px var(--shadow);
            }
            
            .navbar-menu.active {
                left: 0;
            }
            
            .mobile-menu-toggle {
                display: block;
            }
            
            .book-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .quote-section {
                padding: 60px 30px;
            }
        }
    </style>
</head>
<body>
    <!-- Background Decorations -->
    <div class="bg-decoration bg-decoration-1"></div>
    <div class="bg-decoration bg-decoration-2"></div>
    <div class="bg-decoration bg-decoration-3"></div>
    
    <!-- Navigation -->
    <nav class="navbar">
        <div class="container navbar-container">
            <a href="dashboard.jsp" class="navbar-brand">
                <i class="fas fa-om"></i> SoulSprit
            </a>
            
            <button class="mobile-menu-toggle" id="menuToggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <ul class="navbar-menu" id="navbarMenu">
                <li><a href="dashboard.jsp" class="navbar-link active"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="library.jsp" class="navbar-link"><i class="fas fa-book"></i> Library</a></li>
                <li><a href="bookmarks.jsp" class="navbar-link"><i class="fas fa-bookmark"></i> Bookmarks</a></li>
                <li><a href="quizzes.jsp" class="navbar-link"><i class="fas fa-question-circle"></i> Quizzes</a></li>
                <li><a href="reflections.jsp" class="navbar-link"><i class="fas fa-pen"></i> Reflections</a></li>
                <li>
                    <div class="user-profile">
                        <div class="user-avatar">
                            <%= user.getFullName().substring(0, 1).toUpperCase() %>
                        </div>
                        <span><%= user.getFullName() %></span>
                    </div>
                </li>
                <li><a href="logout" class="navbar-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Quote of the Day -->
        <div class="quote-section">
            <div class="quote-text">
                "The mind is everything. What you think you become."
            </div>
            <div class="quote-author">
                — Buddha
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="fas fa-fire"></i>
                </div>
                <div class="stat-number">7</div>
                <div class="stat-label">Day Streak 🔥</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="fas fa-book-open"></i>
                </div>
                <div class="stat-number">12</div>
                <div class="stat-label">Books Read</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="stat-number">8</div>
                <div class="stat-label">Quizzes Completed</div>
            </div>
        </div>
        
        <!-- Categories -->
        <h2 class="section-heading">Browse by Category</h2>
        <div class="categories">
            <button class="category-btn active">
                <i class="fas fa-star"></i> All Books
            </button>
            <button class="category-btn">
                <i class="fas fa-om"></i> Spiritual
            </button>
            <button class="category-btn">
                <i class="fas fa-fire"></i> Motivation
            </button>
            <button class="category-btn">
                <i class="fas fa-brain"></i> Mindfulness
            </button>
            <button class="category-btn">
                <i class="fas fa-heart"></i> Self-Help
            </button>
            <button class="category-btn">
                <i class="fas fa-book-reader"></i> Philosophy
            </button>
        </div>
        
        <!-- Continue Reading -->
        <h2 class="section-heading">Continue Reading</h2>
        <div class="book-grid">
            <!-- Book Card 1 -->
            <div class="book-card">
                <div class="book-cover">
                    <i class="fas fa-book"></i>
                    <div class="book-badge">NEW</div>
                </div>
                <div class="book-info">
                    <div class="book-title">The Power of Now</div>
                    <div class="book-author">by Eckhart Tolle</div>
                    <div class="book-meta">
                        <span><i class="fas fa-star"></i> 4.8</span>
                        <span><i class="fas fa-eye"></i> 1.2k views</span>
                    </div>
                    <button class="btn btn-primary btn-read">
                        <i class="fas fa-book-reader"></i> Continue Reading
                    </button>
                </div>
            </div>
            
            <!-- Book Card 2 -->
            <div class="book-card">
                <div class="book-cover" style="background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);">
                    <i class="fas fa-book"></i>
                </div>
                <div class="book-info">
                    <div class="book-title">Think and Grow Rich</div>
                    <div class="book-author">by Napoleon Hill</div>
                    <div class="book-meta">
                        <span><i class="fas fa-star"></i> 4.9</span>
                        <span><i class="fas fa-eye"></i> 2.5k views</span>
                    </div>
                    <button class="btn btn-primary btn-read">
                        <i class="fas fa-book-reader"></i> Continue Reading
                    </button>
                </div>
            </div>
            
            <!-- Book Card 3 -->
            <div class="book-card">
                <div class="book-cover" style="background: linear-gradient(135deg, var(--warning) 0%, var(--secondary) 100%);">
                    <i class="fas fa-book"></i>
                    <div class="book-badge">POPULAR</div>
                </div>
                <div class="book-info">
                    <div class="book-title">The 7 Habits of Highly Effective People</div>
                    <div class="book-author">by Stephen Covey</div>
                    <div class="book-meta">
                        <span><i class="fas fa-star"></i> 4.7</span>
                        <span><i class="fas fa-eye"></i> 3.1k views</span>
                    </div>
                    <button class="btn btn-primary btn-read">
                        <i class="fas fa-book-reader"></i> Continue Reading
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Mobile Menu Toggle
        const menuToggle = document.getElementById('menuToggle');
        const navbarMenu = document.getElementById('navbarMenu');
        
        menuToggle.addEventListener('click', function() {
            navbarMenu.classList.toggle('active');
            const icon = this.querySelector('i');
            icon.classList.toggle('fa-bars');
            icon.classList.toggle('fa-times');
        });
        
        // Category Filter
        const categoryBtns = document.querySelectorAll('.category-btn');
        categoryBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                categoryBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>