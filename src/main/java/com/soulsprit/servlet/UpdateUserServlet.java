package com.soulsprit.servlet;

import com.soulsprit.dao.UserDAO;
import com.soulsprit.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // FIXED PARAMETER NAME
            String idStr = request.getParameter("userId");

            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("manage-users.jsp?error=missingId");
                return;
            }

            int userId = Integer.parseInt(idStr);

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String role = request.getParameter("role");

            UserDAO dao = new UserDAO();

            boolean updated = dao.updateUserDetails(userId, fullName, email, role);

            if (updated) {
                response.sendRedirect("manage-users.jsp?success=updated");
            } else {
                response.sendRedirect("edit-user.jsp?id=" + userId + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users.jsp?error=exception");
        }
    }
}
