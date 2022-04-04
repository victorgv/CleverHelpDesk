package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class userService {
    @Autowired
    IUser userRepository;

    public User login(String email, String password) {
        return new User("qqq@www.es", "Yo","VICTORGV","dddd","ADMIN");
    }
}
