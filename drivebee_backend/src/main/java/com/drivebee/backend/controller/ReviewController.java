package com.drivebee.backend.controller;

import com.drivebee.backend.dto.ReviewRequestDto;
import com.drivebee.backend.dto.ReviewResponseDto;
import com.drivebee.backend.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    public ResponseEntity<ReviewResponseDto> createReview(@RequestBody ReviewRequestDto dto) {
        ReviewResponseDto response = reviewService.createReview(dto);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping("/vehicle/{vehicleId}")
    public ResponseEntity<List<ReviewResponseDto>> getReviewsForVehicle(@PathVariable Long vehicleId) {
        List<ReviewResponseDto> reviews = reviewService.getReviewsByVehicle(vehicleId);
        return ResponseEntity.ok(reviews);
    }
}
