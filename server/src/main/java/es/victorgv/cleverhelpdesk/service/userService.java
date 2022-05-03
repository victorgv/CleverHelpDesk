package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
@Transactional
public class UserService {
    @Autowired private IUser user_rep;

    public IUser getUser_rep() {
        return user_rep;
    }

    public User loginUser(User_LoginDTO userLoginDTO) {
        return user_rep.findByUserName(userLoginDTO.getUserName());
    }

    // Devuelve el "User" si el email pertenece a alguno de los usuarios registrados, NULL si no está registrado
    public User findByEmail(String email) {
        System.out.println("Buscamos usuario del email: "+email);
        return user_rep.findByEmail(email);
    }

    public User findByUserName(String userName) {
        return user_rep.findByUserName(userName);
    }

    public User findByUserId(Long userId) {
        return user_rep.findByUserId(userId);
    }

    public boolean existsByUserName(String userName) {
        return user_rep.existsByUserName(userName);
    }

    public boolean existsByEmail(String email) {
        return user_rep.existsByEmail(email);
    }

    public void save(User user) {
        user_rep.save(user);
    }


}
