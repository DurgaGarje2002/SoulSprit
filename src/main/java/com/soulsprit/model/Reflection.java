package com.soulsprit.model;

import java.sql.Timestamp;

public class Reflection {
    private int reflectionId;
    private int userId;
    private int bookId;
    private String reflectionText;
    private int chapterNumber;
    private int pageNumber;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public Reflection() {}
    
    // Getters and Setters
    public int getReflectionId() { return reflectionId; }
    public void setReflectionId(int reflectionId) { this.reflectionId = reflectionId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public String getReflectionText() { return reflectionText; }
    public void setReflectionText(String reflectionText) { this.reflectionText = reflectionText; }
    
    public int getChapterNumber() { return chapterNumber; }
    public void setChapterNumber(int chapterNumber) { this.chapterNumber = chapterNumber; }
    
    public int getPageNumber() { return pageNumber; }
    public void setPageNumber(int pageNumber) { this.pageNumber = pageNumber; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}