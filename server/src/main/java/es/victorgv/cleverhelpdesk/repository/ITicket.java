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
    //@Query(value = "select * from Ticket t " +
    //               "where t.opened >= :fromDate and t.opened <= :toDate" +
    //               "  and (user_opened_id=:userId_my or userId_my is null)", nativeQuery = true)
    @Query("select t from Ticket t " +
           "where t.opened >= :fromDate and t.opened <= :toDate" +
            "  and (t.userOpenedId.userId=:userId_my or :userId_my is null)" +
            "  and (t.masterStatus.statusId=:statusId_param or :statusId_param = -1)" +
            "  and (t.masterType.typeId=:typeId_param or :typeId_param = -1)" +
            "  and (t.relatedProjectId.projectId=:projectId_param or :projectId_param = -1)" +
            "  and (t.userOpenedId.userId=:userOpenedId_param or :userOpenedId_param = -1)" +
            "  and (t.userAssignedId.userId=:userAssignedId_param or :userAssignedId_param = -1)" +
            "")
    public List<Ticket> findByFilters(@Param("fromDate") LocalDate from_,
                                      @Param("toDate") LocalDate to_,
                                      @Param("userId_my") Long userId_my,
                                      @Param("statusId_param") Long statusId_param,
                                      @Param("typeId_param") Long typeId_param,
                                      @Param("projectId_param") Long projectId_param,
                                      @Param("userOpenedId_param") Long userOpenedId_param,
                                      @Param("userAssignedId_param") Long userAssignedId_param);




}
