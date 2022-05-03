package es.victorgv.cleverhelpdesk.repository;

import es.victorgv.cleverhelpdesk.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IUser extends JpaRepository<User, Long> {
    User findByUserName(String userName);
    User findByUserId(Long userId);
    User findByEmail(String email);
    boolean existsByUserName(String userName);
    boolean existsByEmail(String email);
}
