package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.Comment;
import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.repository.IComment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@Transactional
public class CommentService {
    @Autowired IComment comment_rep;

    public IComment getComment_rep() {
        return comment_rep;
    }

    public Comment createComment(Comment newComment) {
        newComment.setTimeStamp(LocalDateTime.now());
        return comment_rep.save(newComment);
    }
}
