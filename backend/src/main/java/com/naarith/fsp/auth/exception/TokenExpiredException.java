package com.naarith.fsp.auth.exception;

import com.naarith.fsp.common.exception.BaseException;
import org.springframework.http.HttpStatus;

public class TokenExpiredException extends BaseException {
    public TokenExpiredException() {
        super(HttpStatus.UNAUTHORIZED);
    }
}
