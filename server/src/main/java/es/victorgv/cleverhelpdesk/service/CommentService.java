package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.DTO.Comment_ListDTO;
import es.victorgv.cleverhelpdesk.model.Comment;
import es.victorgv.cleverhelpdesk.repository.IComment;
import es.victorgv.cleverhelpdesk.repository.ITicket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class CommentService {
    @Autowired IComment comment_rep;
    @Autowired ITicket ticket_rep;

    public IComment getComment_rep() {
        return comment_rep;
    }

    public Comment createComment(Comment newComment) {
        newComment.setTimeStamp(LocalDateTime.now());
        return comment_rep.save(newComment);
    }

    // Método que devuelve una lista de comentarios en un DTO
    public List<Comment_ListDTO> findCommentsFromTicket(Long ticketId) {
        List<Comment> lstComment = comment_rep.findAllByTicket(ticket_rep.getById(ticketId));
        List<Comment_ListDTO> lstCommentDTO = new ArrayList<>();

        // Recorre la lista de comentarios para mapear en los objetos nuevos del DTO más reducidos
        for (Comment comment : lstComment) {
            Comment_ListDTO commentDTO = new Comment_ListDTO();
            commentDTO.setCommentId(comment.getCommentId());
            commentDTO.setTicketId(comment.getTicket().getTicketId());
            commentDTO.setUserName(comment.getUser().getName());
            commentDTO.setTimeStamp(comment.getTimeStamp());
            commentDTO.setText(comment.getText());
            lstCommentDTO.add(commentDTO);
        }

        return lstCommentDTO; // Devuelve el DTO formado
    }

}
