package com.drivebee.backend.service;

import com.drivebee.backend.dto.ReviewRequestDto;
import com.drivebee.backend.dto.ReviewResponseDto;
import com.drivebee.backend.model.Review;
import com.drivebee.backend.model.User;
import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.repository.ReviewRepository;
import com.drivebee.backend.repository.UserRepository;
import com.drivebee.backend.repository.VehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final VehicleRepository vehicleRepository;

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
    }

    public ReviewResponseDto createReview(ReviewRequestDto dto) {
        User user = getAuthenticatedUser();
        Vehicle vehicle = vehicleRepository.findById(dto.getVehicleId())
                .orElseThrow(() -> new IllegalArgumentException("Vehicle not found with ID: " + dto.getVehicleId()));

        Review review = Review.builder()
                .user(user)
                .vehicle(vehicle)
                .rating(dto.getRating())
                .comment(dto.getComment())
                .build();

        Review saved = reviewRepository.save(review);
        return mapToResponseDto(saved);
    }

    public List<ReviewResponseDto> getReviewsByVehicle(Long vehicleId) {
        return reviewRepository.findByVehicleId(vehicleId).stream()
                .map(this::mapToResponseDto)
                .collect(Collectors.toList());
    }

    private ReviewResponseDto mapToResponseDto(Review review) {
        return ReviewResponseDto.builder()
                .id(review.getId())
                .vehicleId(review.getVehicle().getId())
                .userId(review.getUser().getId())
                .userFirstName(review.getUser().getFirstName())
                .userLastName(review.getUser().getLastName())
                .rating(review.getRating())
                .comment(review.getComment())
                .createdAt(review.getCreatedAt())
                .build();
    }
}
