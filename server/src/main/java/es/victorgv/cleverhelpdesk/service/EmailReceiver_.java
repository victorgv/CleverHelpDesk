package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.Ticket;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IMasterStatus;
import es.victorgv.cleverhelpdesk.repository.ITicket;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.apache.commons.mail.util.MimeMessageParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mail.MailReceiver;
import org.springframework.messaging.Message;

import org.springframework.messaging.MessageHandler;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Service;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Service
public class EmailReceiver_ {

    @Autowired private UserService user_ser;
    @Autowired private ITicket ticket_repo;
    @Autowired private TicketService ticketService;
    @Autowired private IMasterStatus masterStatus_rep;

    public EmailReceiver_(DirectChannel emailDirectChannel) {
        // Nos suscribimos al canal y llamará asincronamente al handleMessage cada vez que entre un email nuevo
        emailDirectChannel.subscribe(new MessageHandler() {
            @Override
            public void handleMessage(Message<?> message) throws MessagingException { // Se lanza por cada email recibido
                processor(message); // Procesa el email recibido
            }
        });
    }

    // Procesará el email recibido
    private void processor(Message<?> message) {
        try {
            MimeMessage mensaje = (MimeMessage) message.getPayload();
            MimeMessageParser mensaje2 = new MimeMessageParser(mensaje);
            System.out.println("*********** ASUNTO: " + mensaje.getSubject());
            System.out.println("*********** REMITENTE: " + mensaje.getSender().toString()); //mensaje.getFrom()[0]);
            System.out.println("*********** CUERPO: " + mensaje2.parse().getPlainContent());

            String emailDireccion = ((InternetAddress) mensaje.getFrom()[0]).getAddress();

            // 2 Verifica si el email pertenece a algún usuario
            User user = user_ser.findByEmail(emailDireccion);

            if (user == null) { // 3 Si el email remitente no está registrado en la base de datos lo ignoramos
                System.out.println("***** DIRECCIÓN EMAIL: " + emailDireccion + " no pertenece a ningún usuario, ###IGNORAMOS EL EMAIL###");
            } else { // 4 En el caso de pertenecer a algún usuario procedemos a registrar el TICKET
                System.out.println("***** DIRECCIÓN EMAIL: " + emailDireccion + " OK ###CREAMOS TICKET###");
                Ticket newTicket = new Ticket();
                newTicket.setSubject(StaticUtils.NVL(mensaje.getSubject().substring(0,Math.min(400, mensaje.getSubject().length())), "null"));
                newTicket.setUserOpenedId(user);
                newTicket.setDescription(StaticUtils.NVL(mensaje2.parse().getPlainContent().substring(0,Math.min(3500, mensaje2.parse().getPlainContent().length())), "null"));
                newTicket.setMasterStatus(masterStatus_rep.findById(1L).orElse(null));

                ticketService.createTicket(newTicket);
            }

        } catch (Exception e){
            System.err.println("ERROR: "+e);
            e.printStackTrace();
        }
    }



}
