package es.victorgv.cleverhelpdesk.security;

import es.victorgv.cleverhelpdesk.service.UserDetailsServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Clase principal, se ejecutará por cada petición, validará que el token es válido, no está caducado, etc... si está todo ok dará acceso al recurso
public class JWTTokenFilter extends OncePerRequestFilter {
    private final static Logger logger = LoggerFactory.getLogger(JWTTokenFilter.class);

    @Autowired JWTProvider jwtProvider;
    @Autowired UserDetailsServiceImpl userDetailsServiceImpl;

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain filterChain) throws ServletException, IOException {
        try {
            String token = getToken(req);
            if(token != null && jwtProvider.validateToken(token)) {
                String userName = jwtProvider.getUserNameFromToken(token);
                UserDetails userDetails = userDetailsServiceImpl.loadUserByUsername(userName);
                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(auth);
            }

        } catch (Exception e) {
            logger.error("fallo en el método doFilter");
        }
        filterChain.doFilter(req, res);
    }

    // Recuperar el token de la petición
    private String getToken(HttpServletRequest req) {
        String header = req.getHeader("Authorization");
        if (header!= null && header.startsWith("Bearer"))
            return header.replace("Bearer", "");
        return null;
    }
}
