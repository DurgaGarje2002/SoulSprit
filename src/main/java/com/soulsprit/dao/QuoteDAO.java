package com.soulsprit.dao;

import com.soulsprit.model.Quote;
import com.soulsprit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuoteDAO {

    // Add Quote
    public boolean addQuote(Quote quote) {
        String sql = "INSERT INTO quotes (quote_text, author, created_by) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quote.getQuoteText());
            ps.setString(2, quote.getAuthor());

            if (quote.getCreatedBy() > 0) {
                ps.setInt(3, quote.getCreatedBy());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all quotes
    public List<Quote> getAllQuotes() {
        List<Quote> quotes = new ArrayList<>();
        String sql = "SELECT quote_id, quote_text, author, created_by, created_at FROM quotes ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Quote q = new Quote();
                q.setQuoteId(rs.getInt("quote_id"));
                q.setQuoteText(rs.getString("quote_text"));
                q.setAuthor(rs.getString("author"));

                int createdBy = rs.getInt("created_by");
                if (!rs.wasNull()) q.setCreatedBy(createdBy);

                Timestamp t = rs.getTimestamp("created_at");
                if (t != null) q.setCreatedAt(t);

                quotes.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quotes;
    }

    // Get single quote by id
    public Quote getQuoteById(int quoteId) {
        String sql = "SELECT quote_id, quote_text, author, created_by, created_at FROM quotes WHERE quote_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quoteId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Quote q = new Quote();
                    q.setQuoteId(rs.getInt("quote_id"));
                    q.setQuoteText(rs.getString("quote_text"));
                    q.setAuthor(rs.getString("author"));

                    int createdBy = rs.getInt("created_by");
                    if (!rs.wasNull()) q.setCreatedBy(createdBy);

                    Timestamp t = rs.getTimestamp("created_at");
                    if (t != null) q.setCreatedAt(t);

                    return q;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update quote
    public boolean updateQuote(Quote quote) {
        String sql = "UPDATE quotes SET quote_text = ?, author = ? WHERE quote_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, quote.getQuoteText());
            ps.setString(2, quote.getAuthor());
            ps.setInt(3, quote.getQuoteId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete quote
    public boolean deleteQuote(int quoteId) {
        String sql = "DELETE FROM quotes WHERE quote_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quoteId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count
    public int getTotalQuoteCount() {
        String sql = "SELECT COUNT(*) FROM quotes";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
