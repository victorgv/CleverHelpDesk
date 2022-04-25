package es.victorgv.cleverhelpdesk.service;

import es.victorgv.cleverhelpdesk.model.User;
import es.victorgv.cleverhelpdesk.security.UserDetailsImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired UserService user_service;

    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
        User user = user_service.getByUserName(userName);
        return UserDetailsImp.build(user);
    }
}
