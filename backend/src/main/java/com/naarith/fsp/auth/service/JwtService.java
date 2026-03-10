package com.naarith.fsp.auth.service;

import com.naarith.fsp.auth.enums.TokenType;
import com.naarith.fsp.auth.exception.TokenExpiredException;
import com.naarith.fsp.auth.exception.TokenInvalidException;
import com.naarith.fsp.auth.security.UserPrincipal;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
public class JwtService {
    private final SecretKey secretKey;

    public JwtService(
            @Value("${application.security.secret}")
            String secret
    ) {
        // Create secret key for secret string
        byte[] keyBytes = Base64.getDecoder().decode(secret.getBytes(StandardCharsets.UTF_8));
        this.secretKey = Keys.hmacShaKeyFor(keyBytes);
    }

    private String generateToken(UserPrincipal userPrincipal, TokenType tokenType,  int expiredInSec) {

        // Create JWT claims
        Map<String, Object> claims = new HashMap<>();
        claims.put("email", userPrincipal.user().getEmail());
        claims.put("tokenType", tokenType.name());

        // Generate JWT
        return Jwts.builder()
                .subject(userPrincipal.user().getId())
                .claims().add(claims)
                .issuedAt(new Date())
                .expiration(Date.from(Instant.now().plusSeconds(expiredInSec)))
                .and()
                .signWith(secretKey)
                .compact();
    }

    // Generate access token
    public String generateAccessToken(UserPrincipal userPrincipal) {
        return generateToken(userPrincipal, TokenType.ACCESS, 600); // 10min
    }

    // Generate refresh token
    public String generateRefreshToken(UserPrincipal userPrincipal) {
        return generateToken(userPrincipal, TokenType.REFRESH, 3600); // 60min
    }

    private UserPrincipal validateToken(String token, TokenType tokenType) throws TokenExpiredException, TokenInvalidException {
        // Validate token
        try {
            var claims = Jwts.parser()
                    .verifyWith(secretKey)
                    .build()
                    .parseSignedClaims(token);

            // Validate token type
            var tokenTypeStr = claims.getPayload().get("tokenType", String.class);
            var jwtTokenType = TokenType.valueOf(tokenTypeStr);
            if (!tokenType.equals(jwtTokenType)) {
                // Invalid token
                throw new TokenInvalidException();
            }

            // Create UserPrincipal from jwt
            var id = claims.getPayload().getSubject();
            var email = claims.getPayload().get("email", String.class);
            return UserPrincipal.of(id, email);

        } catch (ExpiredJwtException e) {
            // Token expired
            throw new TokenExpiredException();
        } catch (JwtException e) {
            // Invalid token
            throw new TokenInvalidException();
        }
    }

    // Validate access token
    public UserPrincipal validateAccessToken(String toke) throws TokenExpiredException, TokenInvalidException {
        return validateToken(toke, TokenType.ACCESS);
    }

    // Validate refresh token
    public UserPrincipal validateRefreshToken(String toke) throws TokenExpiredException, TokenInvalidException {
        return validateToken(toke, TokenType.REFRESH);
    }
}
