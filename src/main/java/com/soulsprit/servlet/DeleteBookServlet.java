package com.soulsprit.servlet;

import com.soulsprit.dao.BookDAO;
import com.soulsprit.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = bookDAO.deleteBook(id);

            if (success) {
                request.setAttribute("success", "Book deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete book. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("manage-books.jsp");
        dispatcher.forward(request, response);
    }
}
