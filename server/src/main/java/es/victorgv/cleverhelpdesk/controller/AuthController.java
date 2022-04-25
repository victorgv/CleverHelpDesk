package es.victorgv.cleverhelpdesk.controller;

import es.victorgv.cleverhelpdesk.DTO.MensajeDTO;
import es.victorgv.cleverhelpdesk.DTO.User_JWT_DTO;
import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.DTO.User_NewDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.security.JWTProvider;
import es.victorgv.cleverhelpdesk.service.RoleService;
import es.victorgv.cleverhelpdesk.service.UserDetailsServiceImpl;
import es.victorgv.cleverhelpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@CrossOrigin
public class AuthController {
    @Autowired PasswordEncoder passwordEncoder;
    @Autowired AuthenticationManager authenticationManager;
    @Autowired UserService userService;
    @Autowired RoleService roleService;
    @Autowired JWTProvider jwtProvider;

    @GetMapping("/ping")
    public ResponseEntity<?> ping() {
        return ResponseEntity.status(HttpStatus.CREATED).body("pong");
    }

    @PostMapping("/login")
    public ResponseEntity<User_JWT_DTO> login(@RequestBody User_LoginDTO loginUsuario, BindingResult bindingResult){
        if(bindingResult.hasErrors())
            return new ResponseEntity(new MensajeDTO("campos mal puestos"), HttpStatus.BAD_REQUEST);
        Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(loginUsuario.getUserName(), loginUsuario.getPassword()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtProvider.generateToken(authentication);
        UserDetails userDetails = (UserDetails)authentication.getPrincipal();
        User_JWT_DTO jwtDto = new User_JWT_DTO(jwt, userDetails.getUsername(), userDetails.getAuthorities());
        return new ResponseEntity(jwtDto, HttpStatus.OK);
    }
}
