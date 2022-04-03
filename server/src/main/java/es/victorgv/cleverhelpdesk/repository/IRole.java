package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IRole extends JpaRepository<Role, String> {
}
