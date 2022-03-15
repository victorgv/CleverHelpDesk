package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IUser extends JpaRepository<User, Long> {
    User findByid(String id);


}
