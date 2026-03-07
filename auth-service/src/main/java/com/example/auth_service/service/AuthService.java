package com.example.auth_service.service;

import com.example.auth_service.model.User;
import com.example.auth_service.repository.UserRepository;
import com.example.auth_service.util.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    // constructor injection
    public AuthService(
        UserRepository userRepository,
        JwtUtil jwtUtil,
        PasswordEncoder passwordEncoder
    ) {
        this.userRepository = userRepository;
        this.jwtUtil = jwtUtil;
        this.passwordEncoder = passwordEncoder;
    }

    // method for register
    public void register(String username, String password) {
        // create new user with encrypted password
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));

        // save user into dynamodb
        userRepository.saveUser(user);
    }

    // method for login
    public String login(String username, String password) {
        User user = userRepository.getUserByUsername(username);

        // no user found or password doesn't match
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            throw new RuntimeException("Invalid username or password");
        }

        // if credential matches, return a new jwt token
        return jwtUtil.generateToken(user.getUsername());
    }

}
