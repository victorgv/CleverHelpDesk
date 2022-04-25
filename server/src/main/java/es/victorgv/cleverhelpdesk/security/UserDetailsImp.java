package es.victorgv.cleverhelpdesk.security;

import es.victorgv.cleverhelpdesk.model.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class UserDetailsImp implements UserDetails {
    private String email;
    private String name;
    private String userName;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;

    public UserDetailsImp(String email, String name, String userName, String password, Collection<? extends GrantedAuthority> authorities) {
        this.email = email;
        this.name = name;
        this.userName = userName;
        this.password = password;
        this.authorities = authorities;
    }

    public static UserDetailsImp build(User user) {
        // Definimos el ROL del usuario
        List<GrantedAuthority> authorities = new ArrayList<>();
        if (user.getRole().getCode() == "ADMIN") {
            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        } else if (user.getRole().getCode() == "AGENT") {
            authorities.add(new SimpleGrantedAuthority("ROLE_AGENT"));
        } else if (user.getRole().getCode() == "USER") {
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        }

        return new UserDetailsImp(user.getEmail(), user.getName(), user.getUserName(), user.getPassword(), authorities);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return userName;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }
}
