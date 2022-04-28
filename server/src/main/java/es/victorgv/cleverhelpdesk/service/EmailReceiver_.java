package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
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

import javax.mail.internet.MimeMessage;

@Service
public class EmailReceiver_ {

    @Autowired
    UserService user_ser;

    @Autowired
    ITicket ticket_repo;

    public EmailReceiver_(DirectChannel emailDirectChannel) {
        // Nos suscribimos al canal y llamará asincronamente al handleMessage cada vez que entre un email nuevo
        emailDirectChannel.subscribe(new MessageHandler() {
            @Override
            public void handleMessage(Message<?> message) throws MessagingException {
                System.out.println("*************************NUEVO EMAIL**************************");
                processor(message);
            }
        });
    }

    // Procesará el email recibido
    private void processor(Message<?> message) {
        try {
            MimeMessage mensaje = (MimeMessage) message.getPayload();
            MimeMessageParser mensaje2 = new MimeMessageParser(mensaje);
            System.out.println("*********** ASUNTO: " + mensaje.getSubject());
            System.out.println("*********** REMITENTE: " + mensaje.getFrom()[0]);
            System.out.println("*********** CUERPO: " + mensaje2.parse().getPlainContent());

            // 2 Verifica si el email pertenece a algún usuario
            User user = user_ser.findByEmail(mensaje.getFrom()[0].toString());

        } catch (Exception e){
            System.err.println("ERROR: "+e);
            e.printStackTrace();
        }
    }



}
