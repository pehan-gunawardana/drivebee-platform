package com.drivebee.backend.service;

import com.drivebee.backend.dto.BookingDto;
import com.drivebee.backend.model.Booking;
import com.drivebee.backend.model.BookingStatus;
import com.drivebee.backend.model.User;
import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.repository.BookingRepository;
import com.drivebee.backend.repository.UserRepository;
import com.drivebee.backend.repository.VehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final VehicleRepository vehicleRepository;

    /**
     * Creates a new booking.
     * Resolves the authenticated user, finds the vehicle, calculates the total price,
     * and sets status to PENDING.
     */
    public Booking createBooking(BookingDto dto) {
        // Resolve authenticated user's email
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User customer = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        // Find the vehicle
        Vehicle vehicle = vehicleRepository.findById(dto.getVehicleId())
                .orElseThrow(() -> new IllegalArgumentException("Vehicle not found with ID: " + dto.getVehicleId()));

        // Validate dates
        if (dto.getEndDate().isBefore(dto.getStartDate())) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }

        long days = ChronoUnit.DAYS.between(dto.getStartDate(), dto.getEndDate());
        if (days <= 0) {
            throw new IllegalArgumentException("Booking duration must be at least 1 day");
        }

        // Calculate total price (days * pricePerDay)
        BigDecimal totalPrice = vehicle.getPricePerDay().multiply(BigDecimal.valueOf(days));

        // Build Booking entity
        Booking booking = Booking.builder()
                .customer(customer)
                .vehicle(vehicle)
                .startDate(dto.getStartDate().atStartOfDay())
                .endDate(dto.getEndDate().atStartOfDay())
                .totalPrice(totalPrice)
                .status(BookingStatus.PENDING)
                .build();

        return bookingRepository.save(booking);
    }

    /**
     * Fetches all bookings for the currently authenticated user.
     */
    public List<Booking> getBookingsForCurrentUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return bookingRepository.findByCustomerEmail(email);
    }
}
