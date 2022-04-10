package es.victorgv.cleverhelpdesk.service;

import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mail.MailReceiver;
import org.springframework.messaging.Message;

import org.springframework.messaging.MessageHandler;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Service;

@Service
public class EmailReader {
    private MailReceiver receptor; //

    public EmailReader(DirectChannel emailDirectChannel) {
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
        System.out.println("*********** TEXTO: " + message);
    }

}
