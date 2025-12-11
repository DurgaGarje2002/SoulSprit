package com.soulsprit.servlet;

import com.soulsprit.dao.BookDAO;
import com.soulsprit.model.Book;
import com.soulsprit.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/AddBookServlet")
@MultipartConfig(
    maxFileSize = 10485760,      // 10 MB
    maxRequestSize = 10485760,   // 10 MB
    fileSizeThreshold = 1048576  // 1 MB
)
public class AddBookServlet extends HttpServlet {
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
            // Get form parameters
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            
            // Handle file upload
            Part filePart = request.getPart("pdfFile");
            String pdfPath = null;
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "books";
                
                // Create directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Save file
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                File file = new File(uploadPath + File.separator + uniqueFileName);
                
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                pdfPath = "uploads/books/" + uniqueFileName;
            }
            
            // Create book object
            Book book = new Book();
            book.setTitle(title);
            book.setAuthor(author);
            book.setDescription(description);
            book.setCategoryId(categoryId);
            book.setPdfPath(pdfPath);
            book.setUploadedBy(user.getUserId());
            
            // Save to database
            boolean success = bookDAO.addBook(book);
            
            if (success) {
                request.setAttribute("success", "Book added successfully!");
            } else {
                request.setAttribute("error", "Failed to add book. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("add-book.jsp").forward(request, response);
    }
}