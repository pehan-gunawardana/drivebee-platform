package com.drivebee.backend.dto;

import com.drivebee.backend.model.BookingStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookingResponseDto {
    private Long id;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private BigDecimal totalPrice;
    private BookingStatus status;
    private VehicleSummaryDto vehicle;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class VehicleSummaryDto {
        private Long id;
        private String brand;
        private String model;
        private String licensePlate;
        private Integer year;
        private BigDecimal pricePerDay;
        private String status;
    }
}
