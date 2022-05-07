package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "comment_")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "comment_id_generator")
    @SequenceGenerator(name="comment_id_generator", sequenceName = "comment_seq")
    private Long commentId;

    @Column(nullable = false)
    private LocalDateTime timeStamp;

    @ManyToOne(optional = false)
    @JoinColumn(name = "userId", foreignKey = @ForeignKey(name="comment_user_fk"))
    private User user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "ticket_id", foreignKey = @ForeignKey(name="comment_ticket_fk"))
    private Ticket ticket;

    @Column(length = 500, nullable = false)
    private String text;

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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public Comment() {
    }

    public Comment(Long commentId, LocalDateTime timeStamp, User user, Ticket ticket, String text) {
        this.commentId = commentId;
        this.timeStamp = timeStamp;
        this.user = user;
        this.ticket = ticket;
        this.text = text;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Comment comment = (Comment) o;
        return commentId.equals(comment.commentId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(commentId);
    }
}
