package com.drivebee.backend.controller;

import com.drivebee.backend.dto.VehicleDto;
import com.drivebee.backend.model.Vehicle;
import com.drivebee.backend.service.VehicleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vehicles")
@RequiredArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    /**
     * POST endpoint to add a new vehicle.
     * Accessible via POST /api/v1/vehicles
     */
    @PostMapping
    public ResponseEntity<Vehicle> addVehicle(@Valid @RequestBody VehicleDto vehicleDto) {
        Vehicle savedVehicle = vehicleService.addVehicle(vehicleDto);
        return new ResponseEntity<>(savedVehicle, HttpStatus.CREATED);
    }

    /**
     * GET endpoint to fetch all vehicles.
     * Accessible via GET /api/v1/vehicles
     */
    @GetMapping
    public ResponseEntity<List<Vehicle>> getAllVehicles() {
        List<Vehicle> vehicles = vehicleService.getAllVehicles();
        return ResponseEntity.ok(vehicles);
    }
}
