package com.soulsprit.servlet;

import com.soulsprit.dao.QuoteDAO;
import com.soulsprit.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/DeleteQuoteServlet")
public class DeleteQuoteServlet extends HttpServlet {
    private QuoteDAO quoteDAO = new QuoteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int quoteId = Integer.parseInt(request.getParameter("quoteId"));
            boolean deleted = quoteDAO.deleteQuote(quoteId);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?success=" +
                        URLEncoder.encode("Quote deleted successfully!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?error=" +
                        URLEncoder.encode("Failed to delete quote!", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?error=" +
                    URLEncoder.encode("Invalid quote id!", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?error=" +
                    URLEncoder.encode("An error occurred!", "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
