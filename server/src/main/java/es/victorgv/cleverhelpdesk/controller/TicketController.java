package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
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
    public List<Ticket> findByFilters(@RequestParam(name="from", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from_,
                                      @RequestParam(name="to", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to_) {
        return ticketService.getTicket_rep().findByFilters(from_, to_); //findByFilters(LocalDate.now(), LocalDate.now()); //
    }
}
