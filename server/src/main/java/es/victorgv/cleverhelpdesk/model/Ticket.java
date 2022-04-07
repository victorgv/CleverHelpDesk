package es.victorgv.cleverhelpdesk.model;

import javax.persistence.*;

@Entity
public class Ticket {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator= "ticket_id_generator")
    @SequenceGenerator(name="ticket_id_generator", sequenceName = "ticket_seq")
    private Long ticketId;

    private java.time.LocalDate opened; // DATE cuando se crea
    private java.time.LocalDate assigned; // DATE cuando se asigna
    private java.time.LocalDate closed; // DATE cuando se cierra

    @Column(length = 500, nullable = false)
    private String subject;

    @Column(length = 32000, nullable = false)
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
}
