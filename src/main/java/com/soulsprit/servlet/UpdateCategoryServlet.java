package com.soulsprit.servlet;

import com.soulsprit.dao.CategoryDAO;
import com.soulsprit.model.Category;
import com.soulsprit.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateCategoryServlet")
public class UpdateCategoryServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String categoryIdStr = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        
        // Validate input
        if (categoryIdStr == null || categoryName == null || categoryName.trim().isEmpty()) {
            session.setAttribute("error", "Invalid input!");
            response.sendRedirect("manage-categories.jsp");
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Create category object
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(categoryName.trim());
            category.setDescription(description != null ? description.trim() : "");
            
            // Update category in database
            boolean success = categoryDAO.updateCategory(category);
            
            if (success) {
                session.setAttribute("success", "Category updated successfully!");
                response.sendRedirect("manage-categories.jsp");
            } else {
                session.setAttribute("error", "Failed to update category. Please try again.");
                response.sendRedirect("edit-category.jsp?id=" + categoryId);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid category ID!");
            response.sendRedirect("manage-categories.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("manage-categories.jsp");
    }
}