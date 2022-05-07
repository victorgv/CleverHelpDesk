package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
public class Ticket {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "ticket_id_generator")
    @SequenceGenerator(name="ticket_id_generator", sequenceName = "ticket_seq")
    private Long ticketId;

    private LocalDate opened; // DATE cuando se crea
    private LocalDate assigned; // DATE cuando se asigna
    private LocalDate closed; // DATE cuando se cierra
    private LocalDateTime updated; // Cuando fue la última vez que se modificó


    @Column(length = 500, nullable = false)
    private String subject;

    @Column(length = 4000, nullable = false)
    private String description;

    @Column(length = 1)
    private Long priority;

    @ManyToOne
    @JoinColumn(name = "type_id", foreignKey = @ForeignKey(name="ticket_type_fk"))
    private MasterType masterType;

    @ManyToOne
    @JoinColumn(name = "status_id", foreignKey = @ForeignKey(name="ticket_status_fk"))
    private MasterStatus masterStatus;

    @ManyToOne
    @JoinColumn(name = "userOpened_id", foreignKey = @ForeignKey(name="ticket_user_open_fk"))
    private User userOpenedId;

    @ManyToOne
    @JoinColumn(name = "userAssigned_id", foreignKey = @ForeignKey(name="ticket_user_assign_fk"))
    private User userAssignedId;

    @ManyToOne
    @JoinColumn(name = "relatedProject_id", foreignKey = @ForeignKey(name="ticket_project_fk"))
    private Project relatedProjectId;

    public Long getTicketId() {
        return ticketId;
    }

    public void setTicketId(Long ticketId) {
        this.ticketId = ticketId;
    }

    public LocalDate getOpened() {
        return opened;
    }

    public void setOpened(LocalDate opened) {
        this.opened = opened;
    }

    public LocalDate getAssigned() {
        return assigned;
    }

    public void setAssigned(LocalDate assigned) {
        this.assigned = assigned;
    }

    public LocalDate getClosed() {
        return closed;
    }

    public void setClosed(LocalDate closed) {
        this.closed = closed;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getPriority() {
        return priority;
    }

    public void setPriority(Long priority) {
        this.priority = priority;
    }

    public MasterType getMasterType() {
        return masterType;
    }

    public void setMasterType(MasterType masterType) {
        this.masterType = masterType;
    }

    public MasterStatus getMasterStatus() {
        return masterStatus;
    }

    public void setMasterStatus(MasterStatus masterStatus) {
        this.masterStatus = masterStatus;
    }

    public User getUserOpenedId() {
        return userOpenedId;
    }

    public void setUserOpenedId(User userOpenedId) {
        this.userOpenedId = userOpenedId;
    }

    public User getUserAssignedId() {
        return userAssignedId;
    }

    public void setUserAssignedId(User userAssignedId) {
        this.userAssignedId = userAssignedId;
    }

    public Project getRelatedProjectId() {
        return relatedProjectId;
    }

    public void setRelatedProjectId(Project relatedProjectId) {
        this.relatedProjectId = relatedProjectId;
    }

    public LocalDateTime getUpdated() {return updated;}

    public void setUpdated(LocalDateTime updated) {
        this.updated = updated;
    }

    public Ticket() {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Ticket ticket = (Ticket) o;
        return ticketId.equals(ticket.ticketId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ticketId);
    }
}
