package com.naarith.fsp.auth.exception;

import com.naarith.fsp.common.exception.BaseException;
import org.springframework.http.HttpStatus;

public class TokenInvalidException extends BaseException {
    public TokenInvalidException() {
        super(HttpStatus.UNAUTHORIZED);
    }
}
