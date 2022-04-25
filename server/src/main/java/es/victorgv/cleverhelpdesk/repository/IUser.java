package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IUser extends JpaRepository<User, Long> {
    User findByUserName(String userName);
    User findByEmail(String email);
    boolean existsByUserName(String userName);
    boolean existsByEmail(String email);
}
