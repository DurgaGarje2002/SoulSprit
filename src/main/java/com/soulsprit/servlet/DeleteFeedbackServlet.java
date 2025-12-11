package com.soulsprit.servlet;

import com.soulsprit.dao.FeedbackDAO;
import com.soulsprit.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteFeedbackServlet")
public class DeleteFeedbackServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is admin or teacher
        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int feedbackId = Integer.parseInt(idParam);
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                
                if (feedbackDAO.deleteFeedback(feedbackId)) {
                    session.setAttribute("message", "Feedback deleted successfully!");
                } else {
                    session.setAttribute("error", "Failed to delete feedback.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid feedback ID.");
            }
        }
        
        response.sendRedirect("manage-feedback.jsp");
    }
}