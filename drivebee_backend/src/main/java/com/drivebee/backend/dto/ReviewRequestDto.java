package com.drivebee.backend.dto;

import lombok.Data;

@Data
public class ReviewRequestDto {
    private Long vehicleId;
    private Integer rating;
    private String comment;
}
