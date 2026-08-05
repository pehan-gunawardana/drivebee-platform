package com.drivebee.backend.service;

import com.drivebee.backend.dto.UserRegistrationDto;
import com.drivebee.backend.model.Role;
import com.drivebee.backend.model.User;
import com.drivebee.backend.model.UserStatus;
import com.drivebee.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public User registerUser(UserRegistrationDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + dto.getEmail());
        }

        // Split fullName into firstName and lastName
        String fullName = dto.getFullName() != null ? dto.getFullName().trim() : "";
        String firstName;
        String lastName;
        int lastSpaceIdx = fullName.lastIndexOf(' ');
        if (lastSpaceIdx > 0) {
            firstName = fullName.substring(0, lastSpaceIdx);
            lastName = fullName.substring(lastSpaceIdx + 1);
        } else {
            firstName = fullName;
            lastName = "";
        }

        // Set default status: PENDING for OWNER, VERIFIED for others (such as CUSTOMER)
        UserStatus status = (dto.getRole() == Role.OWNER) ? UserStatus.PENDING : UserStatus.VERIFIED;

        User user = User.builder()
                .firstName(firstName)
                .lastName(lastName)
                .email(dto.getEmail())
                .password(passwordEncoder.encode(dto.getPassword()))
                .phoneNumber(dto.getPhoneNumber())
                .role(dto.getRole())
                .status(status)
                .build();

        return userRepository.save(user);
    }
}
