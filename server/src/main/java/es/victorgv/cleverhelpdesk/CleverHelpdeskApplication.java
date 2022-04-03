package es.victorgv.cleverhelpdesk;

import es.victorgv.cleverhelpdesk.model.Role;
import es.victorgv.cleverhelpdesk.repository.IRole;
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
	CommandLineRunner LoadData(IRole role_rep) { // Inicializa base de datos registros obligatorios "Role repositorioRole"
		return (args) -> {
			System.out.println("Holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			// Aseguramos que existen los ROLEs necesarios, ojo saveAll (save) inserta pero si ya existe el registro updatea por lo que no debería devolver excepciónes (registro duplicado)
			// Utilizar: repositorioRole.saveAll(...) // Crud Repository
			System.out.println("22222222222222222222222222222222222222");
			role_rep.saveAll(Arrays.asList(
					new Role("ADMIN","Administrador"),
					new Role("AGENT","Agente"),
					new Role("USER","Usuario")
			));
		};
	}

}
