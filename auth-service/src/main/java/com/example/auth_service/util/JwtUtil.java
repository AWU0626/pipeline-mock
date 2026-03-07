package com.example.auth_service.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtil {
    @Value("${jwt.expiration}")
    private Long expiration;

    @Value("${jwt.secret}")
    private String secret;

    // created jwt token from secret
    public String generateToken(String username) {
        return Jwts
            .builder()
            .setSubject(username) // person that this key belongs to
            .setIssuedAt(new Date()) // created now
            .setExpiration(
                new Date(System.currentTimeMillis() + expiration)
            ) // expires 1 hour from now
            .signWith(
                Keys.hmacShaKeyFor(secret.getBytes()),
                SignatureAlgorithm.HS256
            ) // sign key to prevent tampering
            .compact(); // generate final jwt string
    }

    // gets username from token
    public String validateToken(String token) {
        return Jwts
            .parserBuilder()
            .setSigningKey(
                Keys.hmacShaKeyFor(secret.getBytes())
            ) // provide the key signing method
            .build()
            .parseClaimsJws(token) // parse the jwt token
            .getBody()
            .getSubject(); // extract the sub -> username
    }

}
