package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class mainController {

    @Autowired
    IUser userRepository;



    @PostMapping("/users/login")
    @RequestMapping("/")
    public User loginUser(@RequestBody String email, @RequestBody String password) {
        User user = null; //userRepository.findByUserId(1);

        return user;
    }

}
