package com.soulsprit.dao;

import com.soulsprit.model.Book;
import com.soulsprit.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    // Get all books
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String query = "SELECT b.*, c.category_name FROM books b " +
                      "LEFT JOIN categories c ON b.category_id = c.category_id " +
                      "ORDER BY b.upload_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    // Get books by category
    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String query = "SELECT b.*, c.category_name FROM books b " +
                      "LEFT JOIN categories c ON b.category_id = c.category_id " +
                      "WHERE b.category_id = ? ORDER BY b.title";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    // Get book by ID
    public Book getBookById(int bookId) {
        String query = "SELECT b.*, c.category_name FROM books b " +
                      "LEFT JOIN categories c ON b.category_id = c.category_id " +
                      "WHERE b.book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Add new book
    public boolean addBook(Book book) {
        String query = "INSERT INTO books (category_id, title, author, description, pdf_path, uploaded_by) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, book.getCategoryId());
            stmt.setString(2, book.getTitle());
            stmt.setString(3, book.getAuthor());
            stmt.setString(4, book.getDescription());
            stmt.setString(5, book.getPdfPath());
            stmt.setInt(6, book.getUploadedBy());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update book
    public boolean updateBook(Book book) {
        String query = "UPDATE books SET category_id = ?, title = ?, author = ?, " +
                      "description = ? WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, book.getCategoryId());
            stmt.setString(2, book.getTitle());
            stmt.setString(3, book.getAuthor());
            stmt.setString(4, book.getDescription());
            stmt.setInt(5, book.getBookId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete book
    public boolean deleteBook(int bookId) {
        String query = "DELETE FROM books WHERE book_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Helper method
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setDescription(rs.getString("description"));
        book.setPdfPath(rs.getString("pdf_path"));
        book.setUploadedBy(rs.getInt("uploaded_by"));
        book.setUploadDate(rs.getTimestamp("upload_date"));
        book.setCategoryName(rs.getString("category_name"));
        return book;
    }
}