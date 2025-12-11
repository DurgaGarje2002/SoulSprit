package com.soulsprit.dao;

import com.soulsprit.model.Bookmark;
import com.soulsprit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {

    public List<Bookmark> getUserBookmarks(int userId) {
        List<Bookmark> bookmarks = new ArrayList<>();

        // ✅ Correct column: 'bookmarked_at' instead of 'updated_at'
        String sql = "SELECT * FROM bookmarks WHERE user_id = ? ORDER BY bookmarked_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Bookmark bm = new Bookmark();
                bm.setBookmarkId(rs.getInt("bookmark_id"));
                bm.setUserId(rs.getInt("user_id"));
                bm.setBookId(rs.getInt("book_id"));
                bm.setPageNumber(rs.getInt("page_number"));
                bm.setBookmarkedAt(rs.getTimestamp("bookmarked_at"));
                bookmarks.add(bm);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookmarks;
    }
}
