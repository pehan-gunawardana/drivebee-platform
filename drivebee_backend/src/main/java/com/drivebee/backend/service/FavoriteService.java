package com.drivebee.backend.service;

import com.drivebee.backend.model.Favorite;
import com.drivebee.backend.model.User;
import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.model.VehicleStatus;
import com.drivebee.backend.repository.FavoriteRepository;
import com.drivebee.backend.repository.UserRepository;
import com.drivebee.backend.repository.VehicleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final VehicleRepository vehicleRepository;

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
    }

    public boolean toggleFavorite(Long vehicleId) {
        User user = getAuthenticatedUser();
        Optional<Favorite> existing = favoriteRepository.findByUserIdAndVehicleId(user.getId(), vehicleId);

        if (existing.isPresent()) {
            favoriteRepository.delete(existing.get());
            return false; // Removed from favorites
        } else {
            Vehicle vehicle = vehicleRepository.findById(vehicleId)
                    .orElseThrow(() -> new IllegalArgumentException("Vehicle not found with ID: " + vehicleId));
            Favorite favorite = Favorite.builder()
                    .user(user)
                    .vehicle(vehicle)
                    .build();
            favoriteRepository.save(favorite);
            return true; // Added to favorites
        }
    }

    public List<Vehicle> getFavoriteVehicles() {
        User user = getAuthenticatedUser();
        List<Favorite> favorites = favoriteRepository.findByUserId(user.getId());
        return favorites.stream()
                .map(Favorite::getVehicle)
                .filter(Objects::nonNull)
                .map((Vehicle v) -> {
                    try {
                        // Resolve fields from Hibernate proxy first
                        String brand = v.getBrand();
                        String model = v.getModel();
                        String licensePlate = v.getLicensePlate();
                        Integer year = v.getYear();
                        java.math.BigDecimal price = v.getPricePerDay();
                        VehicleStatus status = v.getStatus();
                        String imageUrl = v.getImageUrl();
                        String category = v.getCategory();

                        // Return a clean unmanaged copy to prevent Jackson serialization loops or proxy issues
                        Vehicle copy = Vehicle.builder()
                                .id(v.getId())
                                .brand(brand)
                                .model(model)
                                .licensePlate(licensePlate)
                                .year(year)
                                .pricePerDay(price)
                                .status(status)
                                .imageUrl(imageUrl)
                                .category(category)
                                .build();
                        return copy;
                    } catch (Exception e) {
                        return (Vehicle) null; // Explicit type cast to resolve type inference issue
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }
}
