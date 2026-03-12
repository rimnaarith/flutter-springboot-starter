package com.naarith.fsp.user.service;

import com.naarith.fsp.user.entity.User;
import com.naarith.fsp.user.exception.EmailAlreadyExistsException;
import com.naarith.fsp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository repository;

    public void createUserForRegistration(User user) {
        // Check if the email is already in use
        if (repository.findByEmail(user.getEmail()).isPresent()) {
            log.warn("Create user failed: email {} already exists", user.getEmail());
            throw new EmailAlreadyExistsException();
        }

        // Save create user
        repository.save(user);
    }

}
