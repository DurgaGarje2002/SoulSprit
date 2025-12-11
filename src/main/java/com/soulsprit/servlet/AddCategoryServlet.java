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

@WebServlet("/AddCategoryServlet")
public class AddCategoryServlet extends HttpServlet {
    
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
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        
        // Validate input
        if (categoryName == null || categoryName.trim().isEmpty()) {
            session.setAttribute("error", "Category name is required!");
            response.sendRedirect("add-category.jsp");
            return;
        }
        
        // Check if category already exists
        if (categoryDAO.categoryExists(categoryName.trim())) {
            session.setAttribute("error", "Category with this name already exists!");
            response.sendRedirect("add-category.jsp");
            return;
        }
        
        // Create category object
        Category category = new Category();
        category.setCategoryName(categoryName.trim());
        category.setDescription(description != null ? description.trim() : "");
        
        // Add category to database
        boolean success = categoryDAO.addCategory(category);
        
        if (success) {
            session.setAttribute("success", "Category added successfully!");
            response.sendRedirect("manage-categories.jsp");
        } else {
            session.setAttribute("error", "Failed to add category. Please try again.");
            response.sendRedirect("add-category.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("add-category.jsp");
    }
}