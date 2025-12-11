package com.soulsprit.servlet;

import java.io.IOException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.soulsprit.model.User;

@WebServlet("/SendFeedbackReplyServlet")
public class SendFeedbackReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is admin or teacher
        if (user == null || (!"admin".equals(user.getRole()) && !"teacher".equals(user.getRole()))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String feedbackId = request.getParameter("feedbackId");
        String userEmail = request.getParameter("userEmail");
        String replyMessage = request.getParameter("replyMessage");

        if (userEmail == null || userEmail.isEmpty() || replyMessage == null || replyMessage.isEmpty()) {
            response.sendRedirect("manage-feedback.jsp?error=Invalid reply data");
            return;
        }

        try {
            // Send email reply
            sendEmailReply(userEmail, replyMessage, user.getFullName());
            
            // Redirect with success message
            response.sendRedirect("manage-feedback.jsp?success=Reply sent successfully to " + userEmail);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-feedback.jsp?error=Failed to send reply: " + e.getMessage());
        }
    }

    private void sendEmailReply(String toEmail, String replyMessage, String adminName) throws MessagingException {
        // Email configuration - UPDATE THESE WITH YOUR SMTP DETAILS
        final String fromEmail = "durgagarje14@gmail.com"; // Your email
        final String password = "uxqp wqqv cdux gvki"; // REPLACE WITH YOUR APP PASSWORD (NOT your Gmail password)
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Create session with authenticator
        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // Create message
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Re: Your Feedback - SoulSprit");

            // Create email body
            String emailBody = "Dear User,\n\n"
                    + "Thank you for your valuable feedback. Here is our response:\n\n"
                    + replyMessage + "\n\n"
                    + "Best regards,\n"
                    + adminName + "\n"
                    + "SoulSprit Team";

            message.setText(emailBody);

            // Send message
            Transport.send(message);

        } catch (MessagingException e) {
            throw new MessagingException("Failed to send email: " + e.getMessage());
        }
    }
}