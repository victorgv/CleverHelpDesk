package es.victorgv.cleverhelpdesk;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class CleverHelpdeskApplication {

	public static void main(String[] args) {
		SpringApplication.run(CleverHelpdeskApplication.class, args);
	}

	@Bean
	CommandLineRunner inidDbData() { // Inicializa base de datos registros obligatorios "Role repositorioRole"
		return (args) -> {
			System.out.println("Holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			// Asegurmos que existen los ROLEs necesarios, ojo saveAll (save) inserta pero si ya existe el registro updatea por lo que no debería devolver excepciónes (registro duplicado)
			// Utilizar: repositorioRole.saveAll(...) // Crud Repository
		};
	}

}
