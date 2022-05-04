package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.repository.IUser;
import es.victorgv.cleverhelpdesk.security.UserDetailsImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    IUser user_rep; //UserService user_service;

    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
        User user = user_rep.findByUserName(userName);
        return UserDetailsImp.build(user);
    }
}
