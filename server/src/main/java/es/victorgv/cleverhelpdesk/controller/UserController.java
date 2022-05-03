package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.MensajeDTO;
import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.DTO.User_NewDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    UserService userService;

    @PostMapping("/new") // *********************************************************
    public ResponseEntity<?> nuevo(@RequestBody User_NewDTO nuevoUsuario, BindingResult bindingResult) {
        if(bindingResult.hasErrors())
            return new ResponseEntity(new MensajeDTO("campos mal puestos o email inválido"), HttpStatus.BAD_REQUEST);
        if(userService.existsByUserName(nuevoUsuario.getUserName()))
            return new ResponseEntity(new MensajeDTO("ese nombre ya existe"), HttpStatus.BAD_REQUEST);
        if(userService.existsByEmail(nuevoUsuario.getEmail()))
            return new ResponseEntity(new MensajeDTO("ese email ya existe"), HttpStatus.BAD_REQUEST);
            /*User usuario =
                    new User(nuevoUsuario.getUserName(), nuevoUsuario.getName(), nuevoUsuario.getEmail(),
                            passwordEncoder.encode(nuevoUsuario.getPassword()),'USER');
            Set<Rol> roles = new HashSet<>();
            roles.add(rolService.getByRolNombre(RolNombre.ROLE_USER).get());
            if(nuevoUsuario.getRoles().contains("admin"))
                roles.add(rolService.getByRolNombre(RolNombre.ROLE_ADMIN).get());
            usuario.setRoles(roles);
            usuarioService.save(usuario);*/
        return new ResponseEntity(new MensajeDTO("usuario guardado"), HttpStatus.CREATED);
    }


    @PostMapping("/login") // *********************************************************
    public ResponseEntity<?> loginUser(@RequestBody User_LoginDTO userLoginDTO) {
        User user = userService.loginUser(userLoginDTO);

        return ResponseEntity.status(HttpStatus.ACCEPTED).body(user);
    }

    @GetMapping("/{userName}")
    public ResponseEntity<?> findByUsername(@PathVariable("userName") String userName) {
        User user = userService.findByUserName(userName);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @GetMapping("/id/{userId}")
    public ResponseEntity<?> findByUsername(@PathVariable("userId") Long id) {
        User user = userService.findByUserId(id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @GetMapping("/")
    public List<User> findAll() {
        return userService.getUser_rep().findAll(); //  findAllAndDeletedDateIsNull();
    }
}
