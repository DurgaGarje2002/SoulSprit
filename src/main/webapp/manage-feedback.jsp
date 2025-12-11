<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.soulsprit.model.*"%>
<%@ page import="com.soulsprit.dao.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.soulsprit.dao.FeedbackDAO" %>
<%@ page import="com.soulsprit.model.Feedback" %>
<%@ page import="java.util.List" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
	response.sendRedirect("login.jsp");
	return;
}

FeedbackDAO feedbackDAO = new FeedbackDAO();
List<Feedback> feedbackList = feedbackDAO.getAllFeedback();

String successMsg = request.getParameter("success");
String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Feedback - Admin</title>

<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
	background: rgba(0, 0, 0, 0.2);
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
	color: rgba(255, 255, 255, 0.7);
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
	background: rgba(255, 255, 255, 0.05);
	color: rgba(255, 255, 255, 0.9);
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
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
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
	from {
		transform: translateY(-20px);
		opacity: 0;
	}
	to {
		transform: translateY(0);
		opacity: 1;
	}
}

.alert-success {
	background: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.alert-error {
	background: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 1.5rem;
}

.page-header h3 {
	color: #2d3436;
	font-weight: 600;
	font-size: 1.25rem;
}

.filter-buttons {
	display: flex;
	gap: 0.75rem;
	align-items: center;
}

.filter-btn {
	padding: 0.5rem 1rem;
	border: 1px solid #ddd;
	background: white;
	color: #666;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.3s;
	font-family: 'Poppins', sans-serif;
	font-weight: 500;
	font-size: 0.9rem;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}

.filter-btn:hover {
	background: #f8f9fa;
	border-color: #B4A5D9;
}

.filter-btn.active {
	background: #B4A5D9;
	color: white;
	border-color: #B4A5D9;
}

.feedback-card {
	background: white;
	padding: 1.5rem;
	border-radius: 12px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
	margin-bottom: 1.5rem;
	transition: transform 0.3s, box-shadow 0.3s;
}

.feedback-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.feedback-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 1rem;
	padding-bottom: 1rem;
	border-bottom: 1px solid #f0f0f0;
}

.feedback-user {
	display: flex;
	align-items: center;
	gap: 1rem;
}

.user-avatar {
	width: 50px;
	height: 50px;
	border-radius: 50%;
	background: #B4A5D9;
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-weight: 700;
	font-size: 1.2rem;
}

.user-info h4 {
	margin: 0;
	color: #2d3436;
	font-weight: 600;
	font-size: 1rem;
}

.user-info p {
	margin: 0.25rem 0 0 0;
	color: #666;
	font-size: 0.85rem;
}

.feedback-date {
	color: #666;
	font-size: 0.85rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.feedback-message {
	color: #2d3436;
	line-height: 1.6;
	margin-bottom: 1rem;
	font-size: 0.95rem;
}

.feedback-actions {
	display: flex;
	gap: 0.5rem;
	justify-content: flex-end;
}

.btn-icon {
	padding: 0.5rem 0.75rem;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	color: white;
	text-decoration: none;
	font-size: 0.9rem;
	transition: all 0.3s;
	display: inline-flex;
	align-items: center;
	gap: 0.35rem;
	font-family: 'Poppins', sans-serif;
	font-weight: 500;
}

.btn-reply {
	background: #6EC6E6;
}

.btn-delete {
	background: #FF9999;
}

.btn-icon:hover {
	opacity: 0.85;
	transform: scale(1.05);
}

.empty-state {
	text-align: center;
	padding: 3rem;
	color: #999;
	background: white;
	border-radius: 12px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}

.empty-state i {
	font-size: 4rem;
	margin-bottom: 1rem;
	opacity: 0.3;
	color: #B4A5D9;
}

.empty-state p {
	font-size: 1.1rem;
}

.sidebar::-webkit-scrollbar {
	width: 6px;
}

.sidebar::-webkit-scrollbar-track {
	background: rgba(0, 0, 0, 0.1);
}

.sidebar::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.2);
	border-radius: 3px;
}

.sidebar::-webkit-scrollbar-thumb:hover {
	background: rgba(255, 255, 255, 0.3);
}

/* Reply Modal Styles */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	align-items: center;
	justify-content: center;
}

.modal-overlay.active {
	display: flex;
}

.modal-content {
	background: white;
	border-radius: 12px;
	width: 90%;
	max-width: 600px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
	animation: modalSlideIn 0.3s ease;
}

@keyframes modalSlideIn {
	from {
		transform: translateY(-50px);
		opacity: 0;
	}
	to {
		transform: translateY(0);
		opacity: 1;
	}
}

.modal-header {
	padding: 1.5rem;
	border-bottom: 1px solid #f0f0f0;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.modal-header h3 {
	margin: 0;
	color: #2d3436;
	font-weight: 600;
	font-size: 1.25rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.modal-close {
	background: none;
	border: none;
	font-size: 1.5rem;
	color: #999;
	cursor: pointer;
	padding: 0;
	width: 30px;
	height: 30px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	transition: all 0.3s;
}

.modal-close:hover {
	background: #f0f0f0;
	color: #333;
}

.modal-body {
	padding: 1.5rem;
}

.feedback-preview {
	background: #f8f9fa;
	padding: 1rem;
	border-radius: 8px;
	margin-bottom: 1.5rem;
	border-left: 3px solid #B4A5D9;
}

.feedback-preview-label {
	font-size: 0.85rem;
	color: #666;
	margin-bottom: 0.5rem;
	font-weight: 500;
}

.feedback-preview-text {
	color: #2d3436;
	font-style: italic;
	line-height: 1.5;
}

.form-group {
	margin-bottom: 1.5rem;
}

.form-group label {
	display: block;
	margin-bottom: 0.5rem;
	color: #2d3436;
	font-weight: 500;
	font-size: 0.95rem;
}

.form-group textarea {
	width: 100%;
	padding: 0.75rem;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-family: 'Poppins', sans-serif;
	font-size: 0.95rem;
	resize: vertical;
	min-height: 150px;
	transition: border-color 0.3s;
}

.form-group textarea:focus {
	outline: none;
	border-color: #B4A5D9;
}

.modal-footer {
	padding: 1.5rem;
	border-top: 1px solid #f0f0f0;
	display: flex;
	justify-content: flex-end;
	gap: 0.75rem;
}

.btn-modal {
	padding: 0.65rem 1.5rem;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-family: 'Poppins', sans-serif;
	font-weight: 500;
	font-size: 0.95rem;
	transition: all 0.3s;
}

.btn-cancel {
	background: #f0f0f0;
	color: #666;
}

.btn-cancel:hover {
	background: #e0e0e0;
}

.btn-send {
	background: #B4A5D9;
	color: white;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.btn-send:hover {
	background: #a294c9;
	transform: translateY(-1px);
	box-shadow: 0 4px 12px rgba(180, 165, 217, 0.4);
}

.user-email-display {
	color: #666;
	font-size: 0.9rem;
	margin-bottom: 0.5rem;
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
				<a href="manage-quizzes.jsp" class="menu-item">
					<i class="fas fa-question-circle"></i>
					<span>Quizzes</span>
				</a>
				<a href="manage-users.jsp" class="menu-item">
					<i class="fas fa-users"></i>
					<span>Users</span>
				</a>
				<a href="manage-feedback.jsp" class="menu-item active">
					<i class="fas fa-comments"></i>
					<span>Feedback</span>
				</a>
				<hr style="border-color: rgba(255, 255, 255, 0.2); margin: 1rem 0;">
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
				<h2>
					<i class="fas fa-comments"></i> Manage Feedback
				</h2>
				<div>
					<strong><%=user.getFullName()%></strong>
				</div>
			</div>

			<div class="content-area">
				<%
				if (successMsg != null) {
				%>
				<div class="alert alert-success">
					<i class="fas fa-check-circle"></i>
					<%=successMsg%>
				</div>
				<%
				}
				%>

				<%
				if (errorMsg != null) {
				%>
				<div class="alert alert-error">
					<i class="fas fa-exclamation-circle"></i>
					<%=errorMsg%>
				</div>
				<%
				}
				%>

				<div class="page-header">
					<h3>All Feedback (<%=feedbackList.size()%>)</h3>
					<div class="filter-buttons">
						<button class="filter-btn active"
							onclick="filterFeedback('all', this)">
							<i class="fas fa-list"></i> All
						</button>
						<button class="filter-btn"
							onclick="filterFeedback('recent', this)">
							<i class="fas fa-clock"></i> Recent
						</button>
					</div>
				</div>

				<div id="feedbackContainer">
					<%
					if (feedbackList != null && !feedbackList.isEmpty()) {
						for (Feedback feedback : feedbackList) {
							String fullName = feedback.getUserFullName();
							String email = feedback.getUserEmail();
							String message = feedback.getMessage();
							String avatar = (fullName != null && !fullName.isEmpty()) ? fullName.substring(0, 1).toUpperCase() : "?";
							
							// Escape strings for JavaScript
							String jsEmail = (email != null) ? email.replace("'", "\\'").replace("\"", "&quot;") : "";
							String jsMessage = (message != null) ? message.replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ").replace("\r", " ") : "";
					%>
					<div class="feedback-card">
						<div class="feedback-header">
							<div class="feedback-user">
								<div class="user-avatar"><%=avatar%></div>
								<div class="user-info">
									<h4><%=(fullName != null ? fullName : "Unknown User")%></h4>
									<p><%=(email != null ? email : "No email available")%></p>
								</div>
							</div>
							<div class="feedback-date">
								<i class="far fa-clock"></i>
								<%=feedback.getSubmittedAt()%>
							</div>
						</div>

						<div class="feedback-message"><%=message%></div>

						<div class="feedback-actions">
							<button class="btn-icon btn-reply"
								onclick="replyFeedback(<%=feedback.getFeedbackId()%>, '<%=jsEmail%>', '<%=jsMessage%>')">
								<i class="fas fa-reply"></i> Reply
							</button>
							<button class="btn-icon btn-delete"
								onclick="deleteFeedback(<%=feedback.getFeedbackId()%>)">
								<i class="fas fa-trash"></i> Delete
							</button>
						</div>
					</div>
					<%
					}
					} else {
					%>
					<div class="empty-state">
						<i class="fas fa-comments"></i>
						<p>No feedback received yet.</p>
					</div>
					<%
					}
					%>
				</div>
			</div>
		</div>
	</div>

	<!-- Reply Modal -->
	<div class="modal-overlay" id="replyModal">
		<div class="modal-content">
			<div class="modal-header">
				<h3>
					<i class="fas fa-reply"></i> Reply to Feedback
				</h3>
				<button class="modal-close" onclick="closeReplyModal()">
					<i class="fas fa-times"></i>
				</button>
			</div>
			<form id="replyForm" action="SendFeedbackReplyServlet" method="post">
				<div class="modal-body">
					<div class="feedback-preview">
						<div class="feedback-preview-label">Original Feedback:</div>
						<div class="feedback-preview-text" id="originalFeedback"></div>
					</div>

					<input type="hidden" name="feedbackId" id="feedbackIdInput">
					<input type="hidden" name="userEmail" id="userEmailInput">

					<div class="user-email-display">
						Sending reply to: <strong id="userEmailDisplay"></strong>
					</div>

					<div class="form-group">
						<label for="replyMessage">Your Reply:</label>
						<textarea name="replyMessage" id="replyMessage"
							placeholder="Type your reply here..." required></textarea>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn-modal btn-cancel"
						onclick="closeReplyModal()">Cancel</button>
					<button type="submit" class="btn-modal btn-send">
						<i class="fas fa-paper-plane"></i> Send Reply
					</button>
				</div>
			</form>
		</div>
	</div>

	<script>
        function filterFeedback(filter, button) {
            // Update active button
            const buttons = document.querySelectorAll('.filter-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Filter logic can be implemented here
            if (filter === 'recent') {
                alert('Showing recent feedback (last 7 days)');
            }
        }
        
        function replyFeedback(feedbackId, userEmail, feedbackMessage) {
            // Set the feedback ID and user email
            document.getElementById('feedbackIdInput').value = feedbackId;
            document.getElementById('userEmailInput').value = userEmail;
            document.getElementById('userEmailDisplay').textContent = userEmail;
            
            // Set the original feedback message
            document.getElementById('originalFeedback').textContent = feedbackMessage;
            
            // Clear the reply textarea
            document.getElementById('replyMessage').value = '';
            
            // Show the modal
            document.getElementById('replyModal').classList.add('active');
        }
        
        function closeReplyModal() {
            document.getElementById('replyModal').classList.remove('active');
        }
        
        // Close modal when clicking outside
        document.getElementById('replyModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeReplyModal();
            }
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeReplyModal();
            }
        });
        
        function deleteFeedback(feedbackId) {
            if (confirm('Are you sure you want to delete this feedback?')) {
                window.location.href = 'DeleteFeedbackServlet?id=' + feedbackId;
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>