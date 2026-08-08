package com.drivebee.backend.controller;

import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @PostMapping("/{vehicleId}")
    public ResponseEntity<Boolean> toggleFavorite(@PathVariable Long vehicleId) {
        boolean isFavorited = favoriteService.toggleFavorite(vehicleId);
        return ResponseEntity.ok(isFavorited);
    }

    @GetMapping
    public ResponseEntity<List<Vehicle>> getFavorites() {
        List<Vehicle> favorites = favoriteService.getFavoriteVehicles();
        return ResponseEntity.ok(favorites);
    }
}
