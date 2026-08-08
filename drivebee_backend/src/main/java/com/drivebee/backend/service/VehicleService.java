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
import java.util.stream.Collectors;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

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
                .category(dto.getCategory())
                .build();

        return vehicleRepository.save(vehicle);
    }

    /**
     * Fetches all vehicle records, optionally matching a search query and category.
     */
    public List<Vehicle> getAllVehicles(String search, String category) {
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasCategory = category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All");

        if (hasSearch && hasCategory) {
            String query = search.trim().toLowerCase();
            String cat = category.trim().toLowerCase();
            return vehicleRepository.findByCategoryIgnoreCase(cat).stream()
                    .filter(v -> (v.getBrand() != null && v.getBrand().toLowerCase().contains(query))
                            || (v.getModel() != null && v.getModel().toLowerCase().contains(query)))
                    .collect(Collectors.toList());
        } else if (hasSearch) {
            return vehicleRepository.findByBrandContainingIgnoreCaseOrModelContainingIgnoreCase(search.trim(), search.trim());
        } else if (hasCategory) {
            return vehicleRepository.findByCategoryIgnoreCase(category.trim());
        }
        return vehicleRepository.findAll();
    }

    /**
     * Uploads and saves an image for a vehicle locally.
     * Maps the file path to "/uploads/vehicles/UUID.ext" and saves to the database.
     */
    public String uploadVehicleImage(Long vehicleId, MultipartFile file) {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new IllegalArgumentException("Vehicle not found with ID: " + vehicleId));

        if (file.isEmpty()) {
            throw new IllegalArgumentException("Cannot upload empty file");
        }

        // Target path: uploads/vehicles/
        String uploadDir = "uploads/vehicles/";
        Path uploadPath = Paths.get(uploadDir);

        try {
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Get original extension
            String originalFileName = file.getOriginalFilename();
            String extension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                extension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }

            // Unique file name
            String uniqueFileName = UUID.randomUUID().toString() + extension;
            Path filePath = uploadPath.resolve(uniqueFileName);

            // Copy file to directory
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            // Relative URL for serving
            String imageUrl = "/uploads/vehicles/" + uniqueFileName;
            vehicle.setImageUrl(imageUrl);
            vehicleRepository.save(vehicle);

            return imageUrl;

        } catch (IOException e) {
            throw new RuntimeException("Failed to store file: " + e.getMessage(), e);
        }
    }

    public List<Vehicle> getMyListings() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User owner = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        return vehicleRepository.findByOwnerId(owner.getId());
    }

    public void deleteVehicle(Long vehicleId) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User owner = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new IllegalArgumentException("Vehicle not found with ID: " + vehicleId));

        if (!vehicle.getOwner().getId().equals(owner.getId())) {
            throw new IllegalStateException("You are not authorized to delete this vehicle listing");
        }

        vehicleRepository.delete(vehicle);
    }
}
