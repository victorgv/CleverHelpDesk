package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.repository.ITicket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TicketService {
    @Autowired
    ITicket ticket_role;
}
