package com.soulsprit.model;

import java.sql.Timestamp;

public class FeedbackReply {
    private int replyId;
    private int feedbackId;
    private int adminUserId;
    private String replyMessage;
    private Timestamp repliedAt;
    private String adminName;

    public FeedbackReply() {
    }

    public FeedbackReply(int feedbackId, int adminUserId, String replyMessage, String adminName) {
        this.feedbackId = feedbackId;
        this.adminUserId = adminUserId;
        this.replyMessage = replyMessage;
        this.adminName = adminName;
    }

    // Getters and Setters
    public int getReplyId() {
        return replyId;
    }

    public void setReplyId(int replyId) {
        this.replyId = replyId;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getAdminUserId() {
        return adminUserId;
    }

    public void setAdminUserId(int adminUserId) {
        this.adminUserId = adminUserId;
    }

    public String getReplyMessage() {
        return replyMessage;
    }

    public void setReplyMessage(String replyMessage) {
        this.replyMessage = replyMessage;
    }

    public Timestamp getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Timestamp repliedAt) {
        this.repliedAt = repliedAt;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
}

