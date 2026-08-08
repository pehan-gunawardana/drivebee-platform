package com.drivebee.backend.repository;

import com.drivebee.backend.model.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserId(Long userId);
    
    Optional<Favorite> findByUserIdAndVehicleId(Long userId, Long vehicleId);

    @Transactional
    void deleteByUserIdAndVehicleId(Long userId, Long vehicleId);
}
