package com.naarith.fsp.auth.exception;

import com.naarith.fsp.common.exception.BaseException;
import org.springframework.http.HttpStatus;

public class InvalidCredentialsExceptions extends BaseException {
    public InvalidCredentialsExceptions() {
        super("Invalid credentials", HttpStatus.UNAUTHORIZED);
    }
}
