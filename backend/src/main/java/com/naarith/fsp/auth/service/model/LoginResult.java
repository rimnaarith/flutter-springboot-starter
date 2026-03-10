package com.naarith.fsp.auth.service.model;

import com.naarith.fsp.auth.dto.LoginResponse;
import lombok.Builder;

@Builder
public record LoginResult(
        LoginResponse loginResponse,
        String refreshToken
) {}
