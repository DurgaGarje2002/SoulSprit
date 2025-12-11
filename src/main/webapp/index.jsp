<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to login if not logged in
    if (session.getAttribute("user") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SoulSprit - Your Spiritual Reading Journey</title>
    
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
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
        }
        
        /* Hero Section */
        .hero {
            min-height: 100vh;
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 50%, #FFE4E9 100%);
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(180,167,214,0.2) 0%, transparent 70%);
            border-radius: 50%;
            top: -200px;
            right: -200px;
            animation: float 8s ease-in-out infinite;
        }
        
        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
            position: relative;
            z-index: 1;
        }
        
        .hero-left h1 {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 700;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1.2;
        }
        
        .hero-left p {
            font-size: 1.3rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .hero-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn-hero {
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-hero.primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            box-shadow: 0 10px 30px rgba(180, 167, 214, 0.3);
        }
        
        .btn-hero.primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(180, 167, 214, 0.4);
        }
        
        .btn-hero.secondary {
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
        }
        
        .btn-hero.secondary:hover {
            background: var(--primary);
            color: white;
        }
        
        .hero-right {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .hero-illustration {
            width: 100%;
            max-width: 500px;
            animation: float 6s ease-in-out infinite;
        }
        
        .floating-icon {
            font-size: 15rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            opacity: 0.8;
        }
        
        /* Features Section */
        .features {
            padding: 5rem 2rem;
            background: white;
        }
        
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        
        .section-subtitle {
            text-align: center;
            font-size: 1.2rem;
            color: var(--text-light);
            margin-bottom: 4rem;
        }
        
        .features-grid {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 3rem;
        }
        
        .feature-card {
            text-align: center;
            padding: 2rem;
            border-radius: var(--radius-md);
            transition: all 0.3s;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
        }
        
        .feature-icon.icon-1 {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        }
        
        .feature-icon.icon-2 {
            background: linear-gradient(135deg, var(--accent) 0%, var(--info) 100%);
        }
        
        .feature-icon.icon-3 {
            background: linear-gradient(135deg, var(--warning) 0%, var(--secondary) 100%);
        }
        
        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        
        .feature-desc {
            color: var(--text-light);
            line-height: 1.6;
        }
        
        /* CTA Section */
        .cta {
            padding: 5rem 2rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            text-align: center;
        }
        
        .cta h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: white;
        }
        
        .cta p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.95;
        }
        
        .cta .btn-hero {
            background: white;
            color: var(--primary);
        }
        
        /* Footer */
        .footer {
            background: #2d3436;
            color: white;
            padding: 3rem 2rem;
            text-align: center;
        }
        
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .footer-links {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .footer-links a {
            color: white;
            text-decoration: none;
            opacity: 0.8;
            transition: opacity 0.3s;
        }
        
        .footer-links a:hover {
            opacity: 1;
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
        
        @media (max-width: 768px) {
            .hero-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .hero-buttons {
                flex-direction: column;
            }
            
            .floating-icon {
                font-size: 10rem;
            }
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-left">
                <h1>Begin Your Spiritual Journey Today</h1>
                <p>Discover thousands of motivational and spiritual books to enlighten your soul and transform your life.</p>
                <div class="hero-buttons">
                    <a href="register.jsp" class="btn-hero primary">
                        <i class="fas fa-rocket"></i> Get Started Free
                    </a>
                    <a href="login.jsp" class="btn-hero secondary">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </div>
            </div>
            <div class="hero-right">
                <div class="floating-icon">
                    <i class="fas fa-om"></i>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features">
        <h2 class="section-title">Why Choose SoulSprit?</h2>
        <p class="section-subtitle">Everything you need for your spiritual growth in one place</p>
        
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon icon-1">
                    <i class="fas fa-book-reader"></i>
                </div>
                <h3 class="feature-title">Vast Library</h3>
                <p class="feature-desc">Access hundreds of spiritual and motivational books curated by experts</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon icon-2">
                    <i class="fas fa-fire"></i>
                </div>
                <h3 class="feature-title">Reading Streaks</h3>
                <p class="feature-desc">Track your reading habits and maintain your spiritual practice daily</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon icon-3">
                    <i class="fas fa-question-circle"></i>
                </div>
                <h3 class="feature-title">Interactive Quizzes</h3>
                <p class="feature-desc">Test your knowledge with chapter-based quizzes and track your progress</p>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="cta">
        <h2>Ready to Transform Your Life?</h2>
        <p>Join thousands of readers on their path to spiritual enlightenment</p>
        <a href="register.jsp" class="btn-hero">
            <i class="fas fa-user-plus"></i> Create Free Account
        </a>
    </section>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <h3><i class="fas fa-om"></i> SoulSprit</h3>
            <p>Your companion on the journey to spiritual growth</p>
            <div class="footer-links">
                <a href="#">About</a>
                <a href="#">Contact</a>
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
            </div>
            <p>&copy; 2024 SoulSprit. All rights reserved. Made with <i class="fas fa-heart" style="color: #FFD4E5;"></i></p>
        </div>
    </footer>
</body>
</html>