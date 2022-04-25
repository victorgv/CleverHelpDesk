package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.Role;
import es.victorgv.cleverhelpdesk.repository.IRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;

@Service
@Transactional
public class RoleService {
    @Autowired IRole role_rep;

    // Carga loa valores iniciales en BD (siempre y cuando no estubiesen previamente cargados)
    public void init() {
        if (role_rep.findAll().isEmpty()) {
            // Aseguramos que existen los ROLEs necesarios, ojo saveAll (save) inserta pero si ya existe el registro updatea por lo que no debería devolver excepciónes (registro duplicado)
            System.out.println("Carga ROLEs por defecto");
            role_rep.saveAll(Arrays.asList(
                    new Role("ADMIN","Administrador"),
                    new Role("AGENT","Agente"),
                    new Role("USER","Usuario")
            ));
        }
    }

    public Role getByRoleCode(String roleCode) {
        return role_rep.findByRoleCode(roleCode);
    }

}
