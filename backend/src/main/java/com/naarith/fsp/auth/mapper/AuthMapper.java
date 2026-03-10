package com.naarith.fsp.auth.mapper;

import com.naarith.fsp.auth.dto.RegisterRequest;
import com.naarith.fsp.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AuthMapper {
    public User toUser(RegisterRequest request) {
        return User.builder()
                .email(request.email())
                .password(request.password())
                .build();
    }
}
