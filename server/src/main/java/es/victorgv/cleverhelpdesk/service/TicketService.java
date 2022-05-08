package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.DTO.Ticket_ModifyDTO;
import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IMasterStatus;
import es.victorgv.cleverhelpdesk.repository.IMasterType;
import es.victorgv.cleverhelpdesk.repository.IProject;
import es.victorgv.cleverhelpdesk.repository.ITicket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;


// Clase con la lógica de negocio del Ticket
@Service
public class TicketService {
    @Autowired private ITicket ticket_rep;
    @Autowired private IMasterStatus masterStatus_rep;
    @Autowired private IMasterType masterType_rep;
    @Autowired private IProject project_rep;
    @Autowired private UserService userService;
    @Autowired private EmailSender_ envioEmail;

    public ITicket getTicket_rep() {return ticket_rep;}

    // Método que creará el ticket, emitirá un email al creador del mismo con el número de ticket
    public Ticket createTicket(Ticket newTicket) {
        // Inicializaciones
        if (newTicket.getDescription() == null || newTicket.getDescription() == "") {
            System.out.println("****************Desc NULO??? " + newTicket.getUserOpenedId().getUserId());
            newTicket.setDescription("NIL"); }
        newTicket.setUpdated(LocalDateTime.now());
        if (newTicket.getMasterStatus().getStatusId() == 5 || newTicket.getMasterStatus().getStatusId() == 6) {
            newTicket.setClosed(LocalDate.now());
        }
        if (newTicket.getOpened() == null) {
            newTicket.setOpened(LocalDate.now());
        }

        // Graba el ticket
        Ticket ticketCreado = ticket_rep.save(newTicket);

        // Obtiene el email del creador
        User usuarioCreador = userService.getUser_rep().findById(newTicket.getUserOpenedId().getUserId()).orElse(null);

        // Envía email informando que se ha creado el ticket
        if (usuarioCreador != null) {
            envioEmail.sendEmail(ticketCreado.getTicketId(),
                                 TypeOfEmail.CREATED_TICKET,
                                 usuarioCreador.getEmail(),
                                 StaticUtils.NVL(newTicket.getSubject(), "NIL"),
                                 StaticUtils.NVL( newTicket.getDescription(), "NIL"));
        }
        return ticketCreado;
    }

    // Método que creará el ticket, emitirá un email al creador del mismo con el número de ticket
    public Ticket updateTicket(Ticket_ModifyDTO updatedTicket) {
        Ticket ticket = ticket_rep.findById(updatedTicket.getTicketId()).orElse(null);
        ticket.setSubject(updatedTicket.getSubject());
        ticket.setDescription(updatedTicket.getDescription());
        ticket.setPriority(updatedTicket.getPriority());
        ticket.setUserOpenedId(userService.getUser_rep().findByUserId(updatedTicket.getUserOpenedId_userId()));
        ticket.setUserAssignedId(userService.getUser_rep().findByUserId(updatedTicket.getUserAssignedId_userId()));
        ticket.setMasterType(masterType_rep.findById(updatedTicket.getMasterType_typeId()).orElse(null));
        ticket.setMasterStatus(masterStatus_rep.findById(updatedTicket.getMasterStatus_statusId()).orElse(null));
        if (updatedTicket.getRelatedProjectId() != null)
          ticket.setRelatedProjectId(project_rep.findById(updatedTicket.getRelatedProjectId()).orElse(null));
        ticket.setUpdated(LocalDateTime.now());
        // Si el status es TERMINADO o CANCELADO
        if (ticket.getMasterStatus().getStatusId() == 5 || ticket.getMasterStatus().getStatusId() == 6) {
            ticket.setClosed(LocalDate.now()); // Apuntamos la fecha fin
            envioEmail.sendEmail(ticket.getTicketId(), // Notificamos el cierre por email
                    TypeOfEmail.CLOSED_TICKET,
                    ticket.getUserOpenedId().getEmail(),
                    StaticUtils.NVL(ticket.getSubject(), "NIL"),
                    StaticUtils.NVL( ticket.getDescription(), "NIL"));
        }

        return ticket_rep.save(ticket);
    }



}
