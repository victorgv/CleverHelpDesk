package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    IUser userRepository;

    public User loginUser(String userName, String password) {
        return userRepository.findByUserName(userName);
    }
}
