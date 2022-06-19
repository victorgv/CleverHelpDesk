package es.victorgv.cleverhelpdesk.service;

import ch.qos.logback.core.net.SyslogOutputStream;
import es.victorgv.cleverhelpdesk.DTO.User_LoginDTO;
import es.victorgv.cleverhelpdesk.DTO.User_CreateDTO;
import es.victorgv.cleverhelpdesk.DTO.User_ModifyDTO;
import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IRole;
import es.victorgv.cleverhelpdesk.repository.IUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional
public class UserService {
    @Autowired private IUser user_rep;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private IRole role_rep;

    public IUser getUser_rep() {
        return user_rep;
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

    // Método que creará el usuario
    public User createUser(User_CreateDTO newUser) {
        return user_rep.save(new User(newUser.getUserName(),newUser.getName(),newUser.getEmail(),passwordEncoder.encode(newUser.getPassword()), role_rep.findById(newUser.getRoleCode()).orElse(null), null));
    }

    // Modificará el usuario
    public User modifyUser(User_ModifyDTO modifiedUser, Long id) {
        User user = user_rep.findByUserId(id); // Recupera el usuario y le actualizamos los campos
        user.setUserName(modifiedUser.getUserName());
        user.setName(modifiedUser.getName());
        user.setEmail(modifiedUser.getEmail());
        user.setDeletedDate(modifiedUser.getDeletedDate());
        user.setRole(role_rep.findById(modifiedUser.getRoleCode()).orElse(null));
        if (modifiedUser.getNewPassword() != null) // Si se ha asignado un passw nuevo también lo tenemos que grabar
            user.setPassword(passwordEncoder.encode(modifiedUser.getNewPassword()));
        return user_rep.save(user);
    }
}
