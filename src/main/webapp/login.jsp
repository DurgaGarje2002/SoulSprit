<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SoulSprit</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    
    
    <style>
        .login-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: linear-gradient(135deg, #FFF9F0 0%, #F5F0FF 50%, #FFE4E9 100%);
            position: relative;
            overflow: hidden;
        }
        
        /* Floating Background Elements */
        .bg-decoration {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            animation: float 8s ease-in-out infinite;
        }
        
        .bg-decoration-1 {
            width: 300px;
            height: 300px;
            background: var(--primary);
            top: -100px;
            left: -100px;
            animation-delay: 0s;
        }
        
        .bg-decoration-2 {
            width: 200px;
            height: 200px;
            background: var(--secondary);
            bottom: -50px;
            right: -50px;
            animation-delay: 2s;
        }
        
        .bg-decoration-3 {
            width: 150px;
            height: 150px;
            background: var(--accent);
            top: 50%;
            right: 10%;
            animation-delay: 4s;
        }
        
        .login-container {
            width: 100%;
            max-width: 1000px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-xl);
            box-shadow: 0 20px 60px rgba(180, 167, 214, 0.2);
            overflow: hidden;
            display: flex;
            position: relative;
            z-index: 1;
            animation: fadeIn 0.6s ease-out;
        }
        
        .login-left {
            flex: 1;
            padding: 60px 50px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
        }
        
        .login-left::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.3;
        }
        
        .login-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
        }
        
        .login-left h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: white;
        }
        
        .login-left p {
            font-size: 1.1rem;
            opacity: 0.95;
            color: white;
        }
        
        .login-right {
            flex: 1;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-header {
            margin-bottom: 2rem;
        }
        
        .login-header h2 {
            font-size: 2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .login-header p {
            color: var(--text-light);
        }
        
        .form-control {
            background: var(--bg-primary);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: var(--text-muted);
            transition: var(--transition);
        }
        
        .password-toggle:hover {
            color: var(--primary);
        }
        
        .password-wrapper {
            position: relative;
        }
        
        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--primary);
        }
        
        .forgot-link {
            color: var(--primary);
            font-size: 0.9rem;
        }
        
        .forgot-link:hover {
            color: var(--secondary);
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: var(--text-muted);
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--bg-secondary);
        }
        
        .divider span {
            padding: 0 1rem;
            font-size: 0.9rem;
        }
        
        .social-login {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .social-btn {
            flex: 1;
            padding: 12px;
            border: 2px solid var(--bg-secondary);
            border-radius: var(--radius-md);
            background: white;
            color: var(--text-dark);
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .social-btn:hover {
            border-color: var(--primary);
            background: var(--bg-primary);
        }
        
        .signup-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-light);
        }
        
        .signup-link a {
            color: var(--primary);
            font-weight: 600;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }
            
            .login-left {
                padding: 40px 30px;
            }
            
            .login-left h1 {
                font-size: 2rem;
            }
            
            .login-icon {
                font-size: 4rem;
            }
            
            .login-right {
                padding: 40px 30px;
            }
            
            .login-header h2 {
                font-size: 1.75rem;
            }
            
            .social-login {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .login-page {
                padding: 10px;
            }
            
            .login-left,
            .login-right {
                padding: 30px 20px;
            }
            
            .form-footer {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="login-page">
        <!-- Background Decorations -->
        <div class="bg-decoration bg-decoration-1"></div>
        <div class="bg-decoration bg-decoration-2"></div>
        <div class="bg-decoration bg-decoration-3"></div>
        
        <div class="login-container">
            <!-- Left Side - Welcome Message -->
            <div class="login-left">
                <div class="login-icon">
                    <i class="fas fa-om"></i>
                </div>
                <h1>Welcome Back!</h1>
                <p>Continue your spiritual journey and discover inner peace through reading</p>
                <div style="margin-top: 2rem;">
                    <i class="fas fa-book-reader" style="font-size: 3rem; opacity: 0.8;"></i>
                </div>
            </div>
            
            <!-- Right Side - Login Form -->
            <div class="login-right">
                <div class="login-header">
                    <h2>Login to SoulSprit</h2>
                    <p>Enter your credentials to access your account</p>
                </div>
                
                <!-- Error/Success Messages -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>
                
                <!-- Login Form -->
                <form action="login" method="post" id="loginForm">
                    <div class="form-group">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope"></i> Email Address
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-user"></i>
                            </span>
                            <input type="email" 
                                   class="form-control" 
                                   id="email" 
                                   name="email" 
                                   placeholder="Enter your email"
                                   required
                                   autocomplete="email">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock"></i> Password
                        </label>
                        <div class="password-wrapper">
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-key"></i>
                                </span>
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Enter your password"
                                       required
                                       autocomplete="current-password">
                            </div>
                            <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                        </div>
                    </div>
                    
                    <div class="form-footer">
                        <div class="remember-me">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Remember me</label>
                        </div>
                        <a href="#" class="forgot-link">Forgot Password?</a>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </button>
                </form>
                
                <div class="divider">
                    <span>Or continue with</span>
                </div>
                
                <div class="social-login">
    <div id="googleButton"></div>
</div>

<script>
window.onload = function () {
  google.accounts.id.initialize({
    client_id: "375716756986-k1h39dtgis0e5dq8etk62qg42cj14rn2.apps.googleusercontent.com",
    callback: handleGoogleLogin
  });

  google.accounts.id.renderButton(
    document.getElementById("googleButton"),
    { theme: "outline", size: "large", text: "continue_with" }
  );
};

function handleGoogleLogin(response) {
	  fetch("google-login", {
	    method: "POST",
	    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	    body: "credential=" + response.credential
	  })
	  .then(() => {
	      window.location.href = "dashboard.jsp";   // ✅ FORCE REDIRECT
	  })
	  .catch(err => console.error("Login Error:", err));
	}



</script>

                
                <div class="signup-link">
                    Don't have an account? <a href="register.jsp">Sign up here</a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Password Toggle
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
        
        // Form Validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            if (!email || !password) {
                e.preventDefault();
                alert('Please fill in all fields');
            }
        });
        
        // Remove alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.animation = 'fadeOut 0.5s ease-out';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    </script>
</body>
</html>