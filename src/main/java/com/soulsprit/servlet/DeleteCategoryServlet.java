package com.soulsprit.servlet;

import com.soulsprit.dao.CategoryDAO;
import com.soulsprit.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteCategoryServlet")
public class DeleteCategoryServlet extends HttpServlet {
    
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
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
        
        // Get category ID
        String idParam = request.getParameter("id");
        if (idParam == null) {
            session.setAttribute("error", "Invalid category ID!");
            response.sendRedirect("manage-categories.jsp");
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(idParam);
            
            // Check if category has books
            int bookCount = categoryDAO.getCategoryBookCount(categoryId);
            if (bookCount > 0) {
                session.setAttribute("error", "Cannot delete category with " + bookCount + " book(s). Please reassign or delete the books first.");
                response.sendRedirect("manage-categories.jsp");
                return;
            }
            
            // Delete category
            boolean success = categoryDAO.deleteCategory(categoryId);
            
            if (success) {
                session.setAttribute("success", "Category deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete category. Please try again.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid category ID format!");
        }
        
        response.sendRedirect("manage-categories.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}