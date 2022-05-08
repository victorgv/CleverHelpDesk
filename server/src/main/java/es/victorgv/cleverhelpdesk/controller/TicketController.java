package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.Comment_ListDTO;
import es.victorgv.cleverhelpdesk.DTO.Ticket_ModifyDTO;
import es.victorgv.cleverhelpdesk.model.Comment;
import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IComment;
import es.victorgv.cleverhelpdesk.service.CommentService;
import es.victorgv.cleverhelpdesk.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/ticket")
public class TicketController {
    @Autowired TicketService ticketService;
    @Autowired CommentService commentService;


    // ENDPOINT para crear un ticket nuevo
    @PostMapping("/")
    public Ticket createTicket(@RequestBody Ticket newTicket) {
        return ticketService.createTicket(newTicket);
    }

    // ENDPOINT para modificar un ticket nuevo
    @PutMapping("/")
    public Ticket updateTicket(@RequestBody Ticket_ModifyDTO updatedTicket) {
        return ticketService.updateTicket(updatedTicket);
    }

    // ENDPOINT que recuperará la lista de tickets en función de los parámetros recibidos
    @GetMapping("/")
    public List<Ticket> findByFilters(@RequestParam(name="from", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from_,
                                      @RequestParam(name="to", required = true) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to_,
                                      @RequestParam( name="userId_my", required = false) Long userId_my,
                                      @RequestParam( name="statusId_param", required = false) Long statusId_param,
                                      @RequestParam( name="typeId_param", required = false) Long typeId_param,
                                      @RequestParam( name="projectId_param", required = false) Long projectId_param,
                                      @RequestParam( name="userOpenedId_param", required = false) Long userOpenedId_param,
                                      @RequestParam( name="userAssignedId_param", required = false) Long userAssignedId_param) {
        System.out.println("************************************ "+ userOpenedId_param);
        return ticketService.getTicket_rep().findByFilters(from_, to_, userId_my, statusId_param, typeId_param, projectId_param, userOpenedId_param, userAssignedId_param);
    }

    // ENDPOINT que recuperará la información de un ticket
    @GetMapping("/id/{ticketId}")
    public ResponseEntity<?> findByUsername(@PathVariable("ticketId") Long id) {
        Ticket ticket = ticketService.getTicket_rep().findById(id).orElse(null);
        return new ResponseEntity<>(ticket, HttpStatus.OK);
    }

    // ENDPOINT que obtendrá todos los comentarios de un ticket
    @GetMapping("/comment/{ticketId}")
    public List<Comment_ListDTO> findCommentsFromTicket(@PathVariable("ticketId") Long ticketId) {
        return commentService.findCommentsFromTicket(ticketId);
    }

    // ENDPOINT que añadirá un nuevo comentario al ticket
    @PostMapping("/comment")
    public Comment createTicket(@RequestBody Comment newComment) {
        return commentService.createComment(newComment);
    }


}
