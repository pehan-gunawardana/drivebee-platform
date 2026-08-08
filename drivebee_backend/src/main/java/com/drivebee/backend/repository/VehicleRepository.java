package com.drivebee.backend.repository;

import com.drivebee.backend.model.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {
    List<Vehicle> findByBrandContainingIgnoreCaseOrModelContainingIgnoreCase(String brand, String model);
    List<Vehicle> findByCategoryIgnoreCase(String category);
    List<Vehicle> findByOwnerId(Long ownerId);
}
