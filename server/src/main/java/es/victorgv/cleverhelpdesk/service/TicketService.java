package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.ITicket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

// Clase con la lógica de negocio del Ticket
@Service
public class TicketService {
    @Autowired private ITicket ticket_rep;
    @Autowired private UserService userService;
    @Autowired private EmailSender_ envioEmail;

    // Método que creará el ticket, emitirá un email al creador del mismo con el número de ticket
    public Ticket createTicket(Ticket newTicket) {
        // Inicializaciones
        if (newTicket.getDescription() == null || newTicket.getDescription() == "") {
            System.out.println("****************Desc NULO??? " + newTicket.getUserOpenedId().getUserId());
            newTicket.setDescription("NIL"); }
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

    public ITicket getTicket_rep() {return ticket_rep;}
}
