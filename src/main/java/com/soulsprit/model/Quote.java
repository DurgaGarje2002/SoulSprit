package com.soulsprit.model;

import java.sql.Timestamp;

public class Quote {
    private int quoteId;
    private String quoteText;
    private String author;
    private int createdBy;
    private Timestamp createdAt;

    public Quote() {}

    public int getQuoteId() { return quoteId; }
    public void setQuoteId(int quoteId) { this.quoteId = quoteId; }

    public String getQuoteText() { return quoteText; }
    public void setQuoteText(String quoteText) { this.quoteText = quoteText; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
