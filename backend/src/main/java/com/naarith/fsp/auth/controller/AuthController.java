package com.naarith.fsp.auth.controller;

import com.naarith.fsp.auth.dto.LoginResponse;
import com.naarith.fsp.auth.dto.LoginRequest;
import com.naarith.fsp.auth.dto.RegisterRequest;
import com.naarith.fsp.auth.exception.TokenInvalidException;
import com.naarith.fsp.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Authentication")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService service;

    // Register
    @Operation(summary = "Register")
    @ApiResponses({
            @ApiResponse(responseCode = "201"),
            @ApiResponse(responseCode = "409", description = "Email already exists"),
            @ApiResponse(responseCode = "400", description = "Bad Request (validation error)")

    })
    @PostMapping("/register")
    public ResponseEntity<Void> register(@RequestBody @Valid RegisterRequest request) {
        service.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    // Login
    @Operation(summary = "Login")
    @ApiResponses({
            @ApiResponse(responseCode = "200"),
            @ApiResponse(responseCode = "400", description = "Bad Request (validation error)"),
            @ApiResponse(responseCode = "401", description = "Invalid credentials")
    })
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody @Valid LoginRequest request) {

        var loginResult = service.login(request);

        // Set refresh token cookie
        var cookie = ResponseCookie.from("refresh_token", loginResult.refreshToken())
                .httpOnly(true)
                .secure(true) // Set as Secure if using HTTPS
                .path("/")
                .maxAge(Duration.ofSeconds(3900)) // 65min
                .build();

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookie.toString())
                .body(loginResult.loginResponse());
    }

    // Refresh token
    @Operation(summary = "Refresh token")
    @ApiResponses({
            @ApiResponse(responseCode = "200"),
            @ApiResponse(responseCode = "401", description = "Invalid credentials")
    })
    @GetMapping("/refresh")
    public ResponseEntity<LoginResponse> refresh(HttpServletRequest request) {
        var cookies = request.getCookies();
        String refreshToken = null;
        if (cookies != null) {
            for (var cookie : cookies) {
                if ("refresh_token".equals(cookie.getName())) {
                    refreshToken = cookie.getValue();
                    break;
                }
            }
        }
        if (refreshToken == null) {
            throw new TokenInvalidException();
        }

        var result = service.refresh(refreshToken);

        // Set refresh token cookie
        var cookie = ResponseCookie.from("refresh_token", result.refreshToken())
                .httpOnly(true)
                .secure(true) // Set as Secure if using HTTPS
                .path("/")
                .maxAge(Duration.ofSeconds(3900)) // 65min
                .build();


        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookie.toString())
                .body(result.loginResponse());
    }

}
