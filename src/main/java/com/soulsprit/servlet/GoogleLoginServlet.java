package com.soulsprit.servlet;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.soulsprit.model.User;
import com.soulsprit.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID =
      "375716756986-k1h39dtgis0e5dq8etk62qg42cj14rn2.apps.googleusercontent.com";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("credential");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(),
                new GsonFactory()
        )
        .setAudience(Collections.singletonList(CLIENT_ID))
        .build();

        try {
            GoogleIdToken idToken = verifier.verify(token);

            if (idToken == null) {
                System.out.println("❌ Invalid Google Token");
                resp.sendRedirect("login.jsp");
                return;
            }

            GoogleIdToken.Payload payload = idToken.getPayload();

            String email = payload.getEmail();
            String name  = (String) payload.get("name");

            UserDAO dao = new UserDAO();

            // CHECK IF USER EXISTS
            User user = dao.getUserByEmail(email);

            // IF NEW GOOGLE USER
            if (user == null) {
                user = new User();
                user.setFullName(name);
                user.setEmail(email);
                user.setRole("student");

                dao.insertGoogleUser(user);

                // Reload user from DB to get ID
                user = dao.getUserByEmail(email);
            }

            // STORE USER IN SESSION
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            // REDIRECT
            resp.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login.jsp");
        }
    }
}
