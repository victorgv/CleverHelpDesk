package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Comment;
import es.victorgv.cleverhelpdesk.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IComment extends JpaRepository<Comment, Long> {
    List<Comment> findAllByTicket(Ticket ticket);
}
