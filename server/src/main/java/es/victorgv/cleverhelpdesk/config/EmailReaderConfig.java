package es.victorgv.cleverhelpdesk.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.config.EnableIntegration;
import org.springframework.integration.mail.ImapIdleChannelAdapter;
import org.springframework.integration.mail.ImapMailReceiver;

import java.util.Properties;

@Configuration
@EnableIntegration
public class EmailReaderConfig {
    // Inyecta la configuración del servidor email
    @Value("${email.username}") private String username;
    @Value("${email.password}") private String password;
    @Value("${email.server.host}") private String server_host;
    @Value("${email.server.port}") private String server_port;


    // Propiedades específicas de la conexión IMAP
    private Properties IMAP_Properties() {
        Properties prop = new Properties();
        prop.setProperty("mail.imap.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        prop.setProperty("mail.imap.socketFactory.fallback", "false");
        prop.setProperty("mail.store.protocol", "imaps");
        prop.setProperty("mail.debug", "false");
        return prop;
    }

    // Inyectará un canal de conexión a la cuenta email configurada (dentro de dicho canal se deberá hacer la suscripción correspondiente para recibir sus emails)
    @Bean
    public DirectChannel emailDirectChannel() {
        return new DirectChannel();
    }

    // SPRING lo detecta e inicializa para poder interrogar el email asincronamente
    @Bean
    ImapIdleChannelAdapter emailAdapter() {
        ImapIdleChannelAdapter imapIdleChannelAdapter = new ImapIdleChannelAdapter(emailReceiver());
        imapIdleChannelAdapter.setAutoStartup(true);
        imapIdleChannelAdapter.setOutputChannel(emailDirectChannel());
        return imapIdleChannelAdapter;
    }

    // Genera la URL de conexión al servidor email
    private String generateIMAP_URL() {
        return "imaps://"+username+":"+password+"@"+server_host+":"+server_port+"/inbox";
    }

    @Bean
    ImapMailReceiver emailReceiver() {
        ImapMailReceiver imapEmailReceiver = new ImapMailReceiver(generateIMAP_URL());
        imapEmailReceiver.setJavaMailProperties(IMAP_Properties());
        imapEmailReceiver.setShouldDeleteMessages(false);
        imapEmailReceiver.setAutoCloseFolder(false);
        imapEmailReceiver.setShouldMarkMessagesAsRead(true);
        return imapEmailReceiver;
    }


}
