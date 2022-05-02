package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/ticket")
public class TicketController {
    @Autowired TicketService ticketService;

    @PostMapping("/")
    public Ticket createTicket(@RequestBody Ticket newTicket) {
        return ticketService.createTicket(newTicket);
    }
}
