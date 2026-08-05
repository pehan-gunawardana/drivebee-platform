package com.drivebee.backend.service;

import com.drivebee.backend.dto.VehicleDto;
import com.drivebee.backend.model.User;
import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.model.VehicleStatus;
import com.drivebee.backend.repository.UserRepository;
import com.drivebee.backend.repository.VehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VehicleService {

    private final VehicleRepository vehicleRepository;
    private final UserRepository userRepository;

    /**
     * Adds a new vehicle to the database.
     * The owner is automatically set to the currently authenticated user.
     * Status is defaulted to AVAILABLE.
     */
    public Vehicle addVehicle(VehicleDto dto) {
        // Retrieve currently authenticated user's email
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User owner = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        Vehicle vehicle = Vehicle.builder()
                .brand(dto.getBrand())
                .model(dto.getModel())
                .licensePlate(dto.getLicensePlate())
                .year(dto.getManufactureYear())
                .status(VehicleStatus.AVAILABLE)
                .owner(owner)
                .pricePerDay(BigDecimal.valueOf(50.0)) // Default placeholder price per day
                .build();

        return vehicleRepository.save(vehicle);
    }

    /**
     * Fetches all vehicle records.
     */
    public List<Vehicle> getAllVehicles() {
        return vehicleRepository.findAll();
    }
}
