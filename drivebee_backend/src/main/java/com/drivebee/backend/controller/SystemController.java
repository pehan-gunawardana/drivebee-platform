package com.drivebee.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/system")
public class SystemController {

    @GetMapping("/status")
    public String getSystemStatus() {
        return "DriveBee Backend is up and running successfully!";
    }
}
