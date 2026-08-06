package com.drivebee.backend.controller;

import com.drivebee.backend.dto.BookingDto;
import com.drivebee.backend.dto.BookingResponseDto;
import com.drivebee.backend.service.BookingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    /**
     * POST endpoint to create a booking.
     * Accessible via POST /api/v1/bookings
     */
    @PostMapping
    public ResponseEntity<BookingResponseDto> createBooking(@Valid @RequestBody BookingDto bookingDto) {
        BookingResponseDto savedBooking = bookingService.createBooking(bookingDto);
        return new ResponseEntity<>(savedBooking, HttpStatus.CREATED);
    }

    /**
     * GET endpoint to fetch all bookings for the currently authenticated user.
     * Accessible via GET /api/v1/bookings
     */
    @GetMapping
    public ResponseEntity<List<BookingResponseDto>> getMyBookings() {
        List<BookingResponseDto> bookings = bookingService.getBookingsForCurrentUser();
        return ResponseEntity.ok(bookings);
    }
}
