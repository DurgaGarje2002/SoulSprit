package com.soulsprit.servlet;

import com.soulsprit.dao.QuoteDAO;
import com.soulsprit.model.Quote;
import com.soulsprit.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/UpdateQuoteServlet")
public class UpdateQuoteServlet extends HttpServlet {
    private QuoteDAO quoteDAO = new QuoteDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            String quoteText = request.getParameter("quoteText");
            String author = request.getParameter("author");

            if (quoteText == null || quoteText.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/edit-quote.jsp?id=" + quoteId + "&error=" +
                        URLEncoder.encode("Quote text is required!", "UTF-8"));
                return;
            }
            if (author == null || author.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/edit-quote.jsp?id=" + quoteId + "&error=" +
                        URLEncoder.encode("Author is required!", "UTF-8"));
                return;
            }

            Quote q = new Quote();
            q.setQuoteId(quoteId);
            q.setQuoteText(quoteText.trim());
            q.setAuthor(author.trim());

            boolean updated = quoteDAO.updateQuote(q);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?success=" +
                        URLEncoder.encode("Quote updated successfully!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/edit-quote.jsp?id=" + quoteId + "&error=" +
                        URLEncoder.encode("Failed to update quote!", "UTF-8"));
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/manage-quotes.jsp");
    }
}
