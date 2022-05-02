package es.victorgv.cleverhelpdesk.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

// Clase que realizará los envíos de emails
@Service
public class EmailSender_ {
    @Autowired private JavaMailSender emailSender;
    @Value("${spring.mail.username}") private String remitente;

    public void sendEmail(Long ticketId, TypeOfEmail typeOfEmail, String to, String subject, String text) {
        // Inicializaciones
        // Crea el mensaje
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setFrom(remitente);
        simpleMailMessage.setTo(to);
        simpleMailMessage.setSubject(formatSubject(ticketId,subject));
        simpleMailMessage.setText(formatText(typeOfEmail, text));
        // Envía
        emailSender.send(simpleMailMessage);
    }

    // Formatea como se indicará el ticket en el asunto del email
    private String formatSubject(Long ticketId, String subject) {
        return "#TICK"+ticketId+"#|"+subject;
    }

    // Formatea como se mostrará la información en el body del email
    private String formatText(TypeOfEmail typeOfEmail, String text) {
        String resultText;
        switch (typeOfEmail) {
            case CREATED_TICKET:
                resultText = "TICKET CREADO";
                break;
            case UPDATED_TICKET:
                resultText = "TICKET MODIFICADO";
                break;
            case CLOSED_TICKET:
                resultText = "TICKET CERRADO";
                break;
            case ADDED_COMMENT_TICKED:
                resultText = "TICKET AÑADIDO COMENTARIO";
                break;
            default:
                resultText = "ACCIÓN DESCONOCIDA";
        }
        DateTimeFormatter formatoFecha = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm");
        resultText += " " + formatoFecha.format(LocalDateTime.now()) + "\n" + "# # # # # # # # # # # # # # # # # # # #\n" + text;
        return resultText;
    }
}

// Tipo enumerado para identificar el tipo de email que se quiere emitir
enum TypeOfEmail {
    CREATED_TICKET, UPDATED_TICKET, CLOSED_TICKET, ADDED_COMMENT_TICKED
}