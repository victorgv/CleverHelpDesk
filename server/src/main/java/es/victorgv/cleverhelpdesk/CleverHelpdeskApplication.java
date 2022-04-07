package es.victorgv.cleverhelpdesk;

import es.victorgv.cleverhelpdesk.model.MasterStatus;
import es.victorgv.cleverhelpdesk.model.MasterType;
import es.victorgv.cleverhelpdesk.model.Role;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IMasterStatus;
import es.victorgv.cleverhelpdesk.repository.IMasterType;
import es.victorgv.cleverhelpdesk.repository.IRole;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Arrays;

@SpringBootApplication
public class CleverHelpdeskApplication {

	public static void main(String[] args) {
		SpringApplication.run(CleverHelpdeskApplication.class, args);
	}

	@Bean
	CommandLineRunner LoadData(IRole role_rep,
							   IMasterStatus masterStatus_rep,
							   IMasterType masterType_rep,
							   IUser user_rep) { // Inicializa base de datos registros obligatorios "Role repositorioRole"
		return (args) -> {
			// Aseguramos que existen los ROLEs necesarios, ojo saveAll (save) inserta pero si ya existe el registro updatea por lo que no debería devolver excepciónes (registro duplicado)
			// Utilizar: repositorioRole.saveAll(...) // Crud Repository
			System.out.println("Carga valores por defecto");
			role_rep.saveAll(Arrays.asList(
					new Role("ADMIN","Administrador"),
					new Role("AGENT","Agente"),
					new Role("USER","Usuario")
			));

			masterStatus_rep.saveAll(Arrays.asList(
					new MasterStatus(1L,"Registrado"),
					new MasterStatus(2L,"Pendiente de información"),
					new MasterStatus(3L,"Trabajando"),
					new MasterStatus(4L,"Parado"),
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
					new MasterType(7L,"Cahída/error sistema externo")
			));

			// Crea el usuario administrador (solo si no existía)
			if (user_rep.findByUserName("ADMIN")==null)
			  user_rep.save(new User("admin@admin.es","Administrador","ADMIN","admin", role_rep.findById("ADMIN").orElse(null)));
		};
	}

}
