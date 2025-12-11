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
    <title>Reading: <%= book.getTitle() %></title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary: #B4A7D6;
            --secondary: #FFD4E5;
            --text-dark: #4A4063;
            --text-light: #8B7E99;
            --bg-light: #FFF9F0;
        }
        
        body {
            font-family: 'Georgia', 'Times New Roman', serif;
            background: var(--bg-light);
            color: var(--text-dark);
            overflow-x: hidden;
        }
        
        /* Top Bar */
        .reading-header {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .back-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(180, 167, 214, 0.4);
        }
        
        .book-title-header {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        
        .header-controls {
            display: flex;
            gap: 1rem;
        }
        
        .control-btn {
            background: white;
            border: 2px solid var(--primary);
            color: var(--primary);
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .control-btn:hover {
            background: var(--primary);
            color: white;
        }
        
        .control-btn.active {
            background: var(--primary);
            color: white;
        }
        
        /* Reading Area */
        .reading-container {
            max-width: 900px;
            margin: 3rem auto;
            padding: 0 2rem;
        }
        
        .reading-content {
            background: white;
            padding: 4rem;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            min-height: 600px;
            line-height: 1.8;
            font-size: 1.2rem;
        }
        
        .reading-content.dark-mode {
            background: #2d3436;
            color: #dfe6e9;
        }
        
        .reading-content.sepia-mode {
            background: #f4ecd8;
            color: #5c4a3a;
        }
        
        .chapter-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            color: var(--primary);
        }
        
        .reading-content p {
            margin-bottom: 1.5rem;
            text-align: justify;
        }
        
        /* Bottom Navigation */
        .reading-footer {
            background: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .progress-bar {
            flex: 1;
            margin: 0 2rem;
            height: 8px;
            background: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary) 0%, var(--secondary) 100%);
            width: 35%;
            transition: width 0.3s;
        }
        
        .nav-btn {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .nav-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(180, 167, 214, 0.4);
        }
        
        .nav-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Settings Panel */
        .settings-panel {
            position: fixed;
            right: -350px;
            top: 0;
            width: 350px;
            height: 100vh;
            background: white;
            box-shadow: -4px 0 20px rgba(0,0,0,0.1);
            padding: 2rem;
            transition: right 0.3s;
            z-index: 1000;
        }
        
        .settings-panel.active {
            right: 0;
        }
        
        .settings-header {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 2rem;
            color: var(--text-dark);
        }
        
        .setting-group {
            margin-bottom: 2rem;
        }
        
        .setting-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }
        
        .theme-options {
            display: flex;
            gap: 1rem;
        }
        
        .theme-btn {
            flex: 1;
            padding: 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s;
        }
        
        .theme-btn:hover,
        .theme-btn.active {
            border-color: var(--primary);
            background: var(--bg-light);
        }
        
        .font-size-control {
            width: 100%;
            accent-color: var(--primary);
        }
        
        .font-size-display {
            text-align: center;
            margin-top: 0.5rem;
            color: var(--text-light);
        }
        
        @media (max-width: 768px) {
            .reading-header {
                flex-direction: column;
                gap: 1rem;
            }
            
            .reading-content {
                padding: 2rem;
                font-size: 1.1rem;
            }
            
            .reading-footer {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .progress-bar {
                width: 100%;
                margin: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Reading Header -->
    <div class="reading-header">
        <div class="header-left">
            <button class="back-btn" onclick="window.location.href='book-detail.jsp?id=<%= book.getBookId() %>'">
                <i class="fas fa-arrow-left"></i> Back
            </button>
            <div class="book-title-header">
                <%= book.getTitle() %> - Chapter 1
            </div>
        </div>
        
        <div class="header-controls">
            <button class="control-btn" onclick="toggleSettings()">
                <i class="fas fa-cog"></i> Settings
            </button>
            <button class="control-btn" onclick="addBookmark()">
                <i class="fas fa-bookmark"></i>
            </button>
            <button class="control-btn" onclick="toggleFullscreen()">
                <i class="fas fa-expand"></i>
            </button>
        </div>
    </div>
    
    <!-- Reading Content -->
    <div class="reading-container">
        <div class="reading-content" id="readingContent">
            <h1 class="chapter-title">Chapter 1: The Beginning</h1>
            
            <p>In the journey of self-discovery, we often find ourselves standing at the crossroads of what we know and what we seek to understand. This book is your companion on that sacred journey, guiding you through the landscapes of your inner world.</p>
            
            <p>Every great transformation begins with a single moment of awareness. It is in that moment when we pause, breathe, and truly see ourselves that the door to enlightenment begins to open. The ancient wisdom teaches us that the path to understanding the universe begins with understanding ourselves.</p>
            
            <p>As you read these words, know that you are not alone on this journey. Countless seekers before you have walked this path, each leaving their own footprints in the sands of time. Their experiences, their wisdom, and their insights are woven into the fabric of this teaching.</p>
            
            <p>The practice of mindfulness is not about perfection; it is about presence. It is about being fully alive in each moment, embracing both the light and the shadow, the joy and the sorrow. In this embrace, we find our true nature.</p>
            
            <p>Consider for a moment the stillness of a mountain lake at dawn. The water reflects the sky with perfect clarity, undisturbed by wind or wave. This is the quality of mind we cultivate through practice – clear, calm, and reflective. When the mind is still, we can see our true reflection.</p>
            
            <p>The journey inward is not always easy. There will be moments of doubt, times when the path seems unclear. But remember, even the longest journey is taken one step at a time. Each breath, each moment of awareness, is a step on the path to awakening.</p>
            
            <p>In the pages that follow, we will explore various practices and teachings that have been passed down through generations. Each one is a tool, a method for cultivating wisdom and compassion. Use them as they serve you, and trust your own inner guidance.</p>
            
            <p>This is your journey. These are your teachings. May they serve you well on the path to inner peace and enlightenment.</p>
        </div>
    </div>
    
    <!-- Settings Panel -->
    <div class="settings-panel" id="settingsPanel">
        <div class="settings-header">
            <i class="fas fa-cog"></i> Reading Settings
        </div>
        
        <div class="setting-group">
            <label class="setting-label">Reading Mode</label>
            <div class="theme-options">
                <div class="theme-btn active" data-theme="light">
                    <i class="fas fa-sun"></i><br>Light
                </div>
                <div class="theme-btn" data-theme="dark">
                    <i class="fas fa-moon"></i><br>Dark
                </div>
                <div class="theme-btn" data-theme="sepia">
                    <i class="fas fa-book"></i><br>Sepia
                </div>
            </div>
        </div>
        
        <div class="setting-group">
            <label class="setting-label">Font Size</label>
            <input type="range" class="font-size-control" min="14" max="24" value="19" id="fontSizeSlider">
            <div class="font-size-display" id="fontSizeDisplay">19px</div>
        </div>
        
        <div class="setting-group">
            <button class="control-btn" style="width: 100%;" onclick="addReflection()">
                <i class="fas fa-pen"></i> Add Reflection
            </button>
        </div>
    </div>
    
    <!-- Reading Footer -->
    <div class="reading-footer">
        <button class="nav-btn" disabled>
            <i class="fas fa-chevron-left"></i> Previous
        </button>
        
        <div class="progress-bar">
            <div class="progress-fill" id="progressFill"></div>
        </div>
        
        <button class="nav-btn">
            Next <i class="fas fa-chevron-right"></i>
        </button>
    </div>
    
    <script>
        // Settings Panel Toggle
        function toggleSettings() {
            document.getElementById('settingsPanel').classList.toggle('active');
        }
        
        // Theme Switching
        const themeBtns = document.querySelectorAll('.theme-btn');
        const readingContent = document.getElementById('readingContent');
        
        themeBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const theme = this.getAttribute('data-theme');
                
                themeBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                readingContent.className = 'reading-content';
                if (theme !== 'light') {
                    readingContent.classList.add(theme + '-mode');
                }
            });
        });
        
        // Font Size Control
        const fontSizeSlider = document.getElementById('fontSizeSlider');
        const fontSizeDisplay = document.getElementById('fontSizeDisplay');
        
        fontSizeSlider.addEventListener('input', function() {
            const size = this.value + 'px';
            readingContent.style.fontSize = size;
            fontSizeDisplay.textContent = size;
        });
        
        // Bookmark
        function addBookmark() {
            alert('Bookmark saved for Chapter 1!');
        }
        
        // Fullscreen
        function toggleFullscreen() {
            if (!document.fullscreenElement) {
                document.documentElement.requestFullscreen();
            } else {
                document.exitFullscreen();
            }
        }
        
        // Add Reflection
        function addReflection() {
            const reflection = prompt('Add your reflection for this chapter:');
            if (reflection) {
                alert('Reflection saved successfully!');
            }
        }
        
        // Auto-save reading progress
        setInterval(() => {
            console.log('Auto-saving progress...');
        }, 30000); // Every 30 seconds
    </script>
</body>
</html>