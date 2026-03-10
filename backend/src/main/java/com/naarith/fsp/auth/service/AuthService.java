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
import com.naarith.fsp.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

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
        userService.createUserForRegistration(newUser);
    }

    // Login user
    public LoginResult login(LoginRequest request) {
        // Authenticate
        final UserPrincipal userPrincipal;
        try {
            var auth = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.email(), request.password()));
            userPrincipal = (UserPrincipal) auth.getPrincipal();
        } catch (BadCredentialsException | UsernameNotFoundException e) {
            // Invalid email/password or User not found
            throw new InvalidCredentialsExceptions();
        }

        if (userPrincipal == null) {
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
            throw new TokenInvalidException();
        }

        // Generate tokens
        var newAccessToken = jwtService.generateAccessToken(user);
        var newRefreshToken = jwtService.generateRefreshToken(user);

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
