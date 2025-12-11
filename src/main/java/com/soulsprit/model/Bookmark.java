package com.soulsprit.model;

import java.sql.Timestamp;

public class Bookmark {
    private int bookmarkId;
    private int userId;
    private int bookId;
    private int pageNumber;
    private Timestamp bookmarkedAt;
    
    public Bookmark() {}
    
    // Getters and Setters
    public int getBookmarkId() { return bookmarkId; }
    public void setBookmarkId(int bookmarkId) { this.bookmarkId = bookmarkId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public int getPageNumber() { return pageNumber; }
    public void setPageNumber(int pageNumber) { this.pageNumber = pageNumber; }
    
    public Timestamp getBookmarkedAt() { return bookmarkedAt; }
    public void setBookmarkedAt(Timestamp bookmarkedAt) { this.bookmarkedAt = bookmarkedAt; }
}