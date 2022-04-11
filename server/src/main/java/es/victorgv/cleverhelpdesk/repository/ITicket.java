package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ITicket extends JpaRepository<Ticket, Long> {
}
