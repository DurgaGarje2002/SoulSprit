package com.soulsprit.servlet;

import com.soulsprit.dao.BookDAO;
import com.soulsprit.model.Book;
import com.soulsprit.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/EditBookServlet")
public class EditBookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            // ✅ Use setters instead of constructor
            Book book = new Book();
            book.setBookId(bookId);
            book.setTitle(title);
            book.setAuthor(author);
            book.setDescription(description);
            book.setCategoryId(categoryId);

            boolean success = bookDAO.updateBook(book);

            if (success) {
                request.setAttribute("success", "Book updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update book. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("manage-books.jsp").forward(request, response);
    }
}
