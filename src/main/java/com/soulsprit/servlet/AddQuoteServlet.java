package com.soulsprit.servlet;

import com.soulsprit.dao.QuoteDAO;
import com.soulsprit.model.Quote;
import com.soulsprit.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/AddQuoteServlet")
public class AddQuoteServlet extends HttpServlet {
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
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String quoteText = request.getParameter("quoteText");
        String author = request.getParameter("author");

        if (quoteText == null || quoteText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/add-quote.jsp?error=" +
                    URLEncoder.encode("Quote text is required!", "UTF-8"));
            return;
        }
        if (author == null || author.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/add-quote.jsp?error=" +
                    URLEncoder.encode("Author is required!", "UTF-8"));
            return;
        }

        Quote q = new Quote();
        q.setQuoteText(quoteText.trim());
        q.setAuthor(author.trim());
        q.setCreatedBy(user.getUserId());

        boolean added = quoteDAO.addQuote(q);
        if (added) {
            response.sendRedirect(request.getContextPath() + "/manage-quotes.jsp?success=" +
                    URLEncoder.encode("Quote added successfully!", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/add-quote.jsp?error=" +
                    URLEncoder.encode("Failed to add quote!", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/add-quote.jsp");
    }
}
