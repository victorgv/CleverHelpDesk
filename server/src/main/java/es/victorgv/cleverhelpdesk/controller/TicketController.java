package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ticket")
public class TicketController {
    @Autowired TicketService ticketService;

    @PostMapping("/")
    public Ticket createTicket(@RequestBody Ticket newTicket) {
        return ticketService.createTicket(newTicket);
    }

    @GetMapping("/")
    public List<Ticket> findAll() {
        return ticketService.getTicket_rep().findAll(); //  findAllAndDeletedDateIsNull()
    }
}
