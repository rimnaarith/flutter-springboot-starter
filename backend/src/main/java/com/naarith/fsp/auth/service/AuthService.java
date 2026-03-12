package com.naarith.fsp.auth.service;

import com.naarith.fsp.auth.dto.LoginRequest;
import com.naarith.fsp.auth.dto.LoginResponse;
import com.naarith.fsp.auth.dto.RegisterRequest;
import com.naarith.fsp.auth.exception.InvalidCredentialsExceptions;
import com.naarith.fsp.auth.exception.TokenInvalidException;
import com.naarith.fsp.auth.mapper.AuthMapper;
import com.naarith.fsp.auth.security.CustomUserDetailsService;
import com.naarith.fsp.auth.security.UserPrincipal;
import com.naarith.fsp.auth.service.model.LoginResult;
import com.naarith.fsp.user.exception.EmailAlreadyExistsException;
import com.naarith.fsp.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UserService userService;
    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthMapper mapper;

    // Register user
    public void register(RegisterRequest request) {
        var newUser = mapper.toUser(request);

        // Encode passwor
        newUser.setPassword(passwordEncoder.encode(request.password()));

        // Create user
        try {
            userService.createUserForRegistration(newUser);
            log.info("Registered successfully email={}", request.email());
        } catch (EmailAlreadyExistsException e) {
            log.warn("Register failed: email {} already exists", request.email());
            throw e;
        }
    }

    // Login user
    public LoginResult login(LoginRequest request) {
        // Authenticate
        final UserPrincipal userPrincipal;
        try {
            var auth = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.email(), request.password()));
            userPrincipal = (UserPrincipal) auth.getPrincipal();
            log.info("Successful authentication for email={}", request.email());
        } catch (BadCredentialsException | UsernameNotFoundException e) {
            log.warn("Login failed for email={}: Invalid credentials", request.email());
            // Invalid email/password or User not found
            throw new InvalidCredentialsExceptions();
        }

        if (userPrincipal == null) {
            log.error("Authenticated principal null error for email={}", request.email());
            throw new IllegalStateException("Authenticated principal is null");
        }

        // Generate tokens
        var accessToken = jwtService.generateAccessToken(userPrincipal);
        var refreshToken = jwtService.generateRefreshToken(userPrincipal);

        return LoginResult.builder()
                .loginResponse(LoginResponse
                        .builder()
                        .accessToken(accessToken)
                        .email(userPrincipal.user().getEmail())
                        .build()
                )
                .refreshToken(refreshToken)
                .build();
    }

    // Refresh token
    public LoginResult refresh(String refreshToken) {
        // Validate refresh token
        // TokenExpiredException and TokenInvalidException are handle in GlobalExceptionHandler
        var userPrincipal = jwtService.validateRefreshToken(refreshToken);

        // Check if the user still exists.
        final UserPrincipal user;
        try {
            user = (UserPrincipal) userDetailsService.loadUserByUsername(userPrincipal.getUsername());
        } catch (UsernameNotFoundException e) {
            log.warn("Refresh token invalid email={}", userPrincipal.getUsername());
            throw new TokenInvalidException();
        }

        // Generate tokens
        var newAccessToken = jwtService.generateAccessToken(user);
        var newRefreshToken = jwtService.generateRefreshToken(user);

        log.info("Successful refresh token for email={}", user.getUsername());
        return LoginResult.builder()
                .loginResponse(LoginResponse
                        .builder()
                        .accessToken(newAccessToken)
                        .email(userPrincipal.user().getEmail())
                        .build()
                )
                .refreshToken(newRefreshToken)
                .build();
    }
}
