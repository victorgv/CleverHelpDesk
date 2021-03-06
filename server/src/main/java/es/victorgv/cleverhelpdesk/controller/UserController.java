package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.DTO.User_CreateDTO;
import es.victorgv.cleverhelpdesk.DTO.User_ModifyDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired UserService userService;

    @PostMapping("/") // EndPoint para crear un usuario
    public User createUser(@RequestBody User_CreateDTO nuevoUsuario) {
        return userService.createUser(nuevoUsuario);
    }

    @PutMapping("/{id}") // EndPoint para modificar el usuario con el ID pasado en el path
    public User modifyUser(@PathVariable("id") Long id, @RequestBody User_ModifyDTO modifiedUser) {
        return userService.modifyUser(modifiedUser, id);
    }

    @GetMapping("/{userName}") // EndPoint que recupera un usuario a partir de su userName
    public ResponseEntity<?> findByUsername(@PathVariable("userName") String userName) {
        User user = userService.findByUserName(userName);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @GetMapping("/id/{userId}") // EndPoint que recupera un usuario a partir de su ID
    public ResponseEntity<?> findByUsername(@PathVariable("userId") Long id) {
        User user = userService.findByUserId(id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @GetMapping("/")
    public List<User> findAll() {
        return userService.getUser_rep().findAll(); //  findAllAndDeletedDateIsNull();
    }
}
