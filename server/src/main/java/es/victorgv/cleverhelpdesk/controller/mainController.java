package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.LoginUserDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
public class MainController {

    @Autowired
    UserService userService;

    @GetMapping("/util/ping")
    public ResponseEntity<?> ping() {
        return ResponseEntity.status(HttpStatus.CREATED).body("pong");
    }


    @PostMapping("/user/login")
    public ResponseEntity<?> loginUser(@RequestBody LoginUserDTO loginUserDTO) {
        User user = userService.loginUser(loginUserDTO);

        return ResponseEntity.status(HttpStatus.ACCEPTED).body(user);
    }

}
