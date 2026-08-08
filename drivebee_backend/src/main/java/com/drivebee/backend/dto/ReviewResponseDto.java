package com.drivebee.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReviewResponseDto {
    private Long id;
    private Long vehicleId;
    private Long userId;
    private String userFirstName;
    private String userLastName;
    private Integer rating;
    private String comment;
    private LocalDateTime createdAt;
}
