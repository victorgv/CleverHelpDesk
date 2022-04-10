package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
public class MainController {

    @Autowired
    UserService userService;

    @GetMapping("/user/login")
    public User loginUser (@RequestParam String userName) {
        User user = userService.loginUser(userName, "1111");
        return  user;
    }

    @PostMapping("/user/login")
    public User loginUser(@RequestBody String userName, @RequestBody String password) {
        User user = userService.loginUser(userName, password);

        return user;
    }

}
