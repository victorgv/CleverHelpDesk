package es.victorgv.cleverhelpdesk;

import es.victorgv.cleverhelpdesk.model.MasterStatus;
import es.victorgv.cleverhelpdesk.model.MasterType;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IMasterStatus;
import es.victorgv.cleverhelpdesk.repository.IMasterType;
import es.victorgv.cleverhelpdesk.repository.IRole;
import es.victorgv.cleverhelpdesk.repository.IUser;
import es.victorgv.cleverhelpdesk.service.EmailReceiver_;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;

@SpringBootApplication
@EnableScheduling
public class CleverHelpdeskApplication {
	private int contador=0;

	public static void main(String[] args) {
		SpringApplication.run(CleverHelpdeskApplication.class, args);
	}

	@Bean
	CommandLineRunner LoadData(IRole role_rep,
							   IMasterStatus masterStatus_rep,
							   IMasterType masterType_rep,
							   IUser user_rep) { // Inicializa base de datos registros obligatorios "Role repositorioRole"
		return (args) -> {
			masterStatus_rep.saveAll(Arrays.asList(
					new MasterStatus(1L,"Registrado"),
					new MasterStatus(2L,"Pendiente de información"),
					new MasterStatus(3L,"Parado"),
					new MasterStatus(4L,"Trabajando"),
					new MasterStatus(5L,"Terminado"),
					new MasterStatus(6L,"Cancelado")
			));
			masterType_rep.saveAll(Arrays.asList(
					new MasterType(1L,"Consulta"),
					new MasterType(2L,"Asistencia"),
					new MasterType(3L,"Administración usuario/dispositivo"),
					new MasterType(4L,"Extracción datos/informes"),
					new MasterType(5L,"Control proactivo"),
					new MasterType(6L,"Correctivo/incidencia"),
					new MasterType(7L,"Cahída/error sistema externo"),
					new MasterType(8L,"Petición de mejora/desarrollo")
			));

			// Crea el usuario administrador (solo si no existía)
			//if (!user_rep.existsByUserName("ADMIN"))
			//	user_rep.save(new User("ADMIN","Pepe Administrador","admin@admin.es",passwordEncoder.encode("admin"), role_rep.findById("ADMIN").orElse(null), null));
		};
	}

	@Autowired
	private EmailReceiver_ serviceEmailReceiver;

	/*@Scheduled(fixedRate = 5000)
	public void miraSiHayEmailsNuevos() {
		System.out.println("Tarea asíncrona A "+ ++contador);
		serviceEmailReader.recuperarMensajes();
	}*/
}
