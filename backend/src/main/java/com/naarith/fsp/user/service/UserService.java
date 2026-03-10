package com.naarith.fsp.user.service;

import com.naarith.fsp.user.entity.User;
import com.naarith.fsp.user.exception.EmailAlreadyExistsException;
import com.naarith.fsp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository repository;

    public void createUserForRegistration(User user) {
        // Check if the email is already in use
        if (repository.findByEmail(user.getEmail()).isPresent()) {
            throw new EmailAlreadyExistsException();
        }

        // Save create user
        repository.save(user);
    }

}
