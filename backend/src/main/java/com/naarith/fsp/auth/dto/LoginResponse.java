package com.naarith.fsp.auth.dto;

import lombok.Builder;

@Builder
public record LoginResponse (
        String email,
        String accessToken
){}
