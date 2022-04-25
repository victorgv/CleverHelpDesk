package es.victorgv.cleverhelpdesk.security;

import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.util.Date;

// Genara el token, tendrá métodos de validación para ver que esté bien generado, no expirado, etc.

@Component
public class JWTProvider {
    private final static Logger logger = LoggerFactory.getLogger(JWTProvider.class);

    @Value("${jwt.secret}") private String secret;
    @Value("${jwt.expiration}") private int expiration;

    public String generateToken(Authentication authentication) {
        UserDetailsImp userDetailsImp = (UserDetailsImp) authentication.getPrincipal();
        return Jwts.builder().setSubject(userDetailsImp.getUsername())
                .setIssuedAt(new Date())
                .setExpiration(new Date(new Date().getTime() + expiration))
                .signWith(SignatureAlgorithm.HS512, secret)
                .compact();
    }

    public String getUserNameFromToken(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody().getSubject();
    }


    // Valida que el token es correcto y válido
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(secret).parseClaimsJws(token);
            return true;
        } catch (MalformedJwtException e) {
            logger.error("token mal formado");
        } catch (UnsupportedJwtException e) {
            logger.error("token no soportado");
        } catch (ExpiredJwtException e) {
            logger.error("token expirado");
        } catch (IllegalArgumentException e) {
            logger.error("token vacio");
        } catch (SignatureException e) {
            logger.error("fallo en la firma");
        }
        return false;
    }
}
