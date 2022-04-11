package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    IUser user_rep;

    public User loginUser(String userName, String password) {
        return user_rep.findByUserName(userName);
    }

    // Devuelve el "User" si el email pertenece a alguno de los usuarios registrador, NULL si no está registrado
    public User findByEmail(String email) {
        System.out.println("Buscamos usuario del email: "+email);
        return user_rep.findByEmail(email);
    }
}
