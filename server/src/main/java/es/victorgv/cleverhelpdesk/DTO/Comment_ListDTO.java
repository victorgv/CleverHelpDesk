package es.victorgv.cleverhelpdesk.DTO;

import java.time.LocalDateTime;

// Clase para transferencia de datos de la lista de comentarios de un ticket emitiendo la información mínima necesaria
public class Comment_ListDTO {
    private Long commentId;
    private LocalDateTime timeStamp;
    private String userName;
    private Long ticketId;
    private String text;

    public Comment_ListDTO() {
    }

    public Long getCommentId() {
        return commentId;
    }

    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }

    public LocalDateTime getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(LocalDateTime timeStamp) {
        this.timeStamp = timeStamp;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Long getTicketId() {
        return ticketId;
    }

    public void setTicketId(Long ticketId) {
        this.ticketId = ticketId;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}
