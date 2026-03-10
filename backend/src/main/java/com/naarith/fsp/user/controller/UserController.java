package com.naarith.fsp.user.controller;

import com.naarith.fsp.auth.exception.TokenExpiredException;
import com.naarith.fsp.user.entity.User;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
@Tag(name = "Users")
@SecurityRequirement(name = "Bearer Authentication")
@RequiredArgsConstructor
public class UserController {
    @GetMapping("/my-info")
    ResponseEntity<User> getInfo() {
        // TODO: Implementing the logic. Currently just throws an expired token to test the front-end refresh token logic.
        throw new TokenExpiredException();
    }
}
