package com.soulsprit.servlet;

import com.soulsprit.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("manage-users.jsp?error=missingId");
                return;
            }

            int userId = Integer.parseInt(idParam);

            UserDAO dao = new UserDAO();
            boolean deleted = dao.deleteUser(userId);

            if (deleted) {
                response.sendRedirect("manage-users.jsp?success=deleted");
            } else {
                response.sendRedirect("manage-users.jsp?error=deleteFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users.jsp?error=exception");
        }
    }
}
