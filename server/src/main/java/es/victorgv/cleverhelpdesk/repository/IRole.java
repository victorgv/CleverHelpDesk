package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IRole extends JpaRepository<Role, String> {
    Role findByRoleCode(String roleCode);
}
