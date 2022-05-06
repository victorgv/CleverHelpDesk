package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ITicket extends JpaRepository<Ticket, Long> {
    @Query("select t from Ticket t where t.opened >= :fromDate and t.opened <= :toDate")
    public List<Ticket> findByFilters(@Param("fromDate") LocalDate from_,
                                      @Param("toDate") LocalDate to_);




}
