package com.medicare.auth.dto;

import com.medicare.user.dto.UserDtos;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public final class AuthDtos {
    private AuthDtos() {}

    public record RegisterRequest(
            @NotBlank @Size(max = 120) String fullName,
            @Email @NotBlank @Size(max = 160) String email,
            @NotBlank @Size(min = 6, max = 100) String password
    ) {}

    public record LoginRequest(
            @Email @NotBlank String email,
            @NotBlank String password
    ) {}

    public record ForgotPasswordRequest(
            @Email @NotBlank String email
    ) {}

    public record AuthResponse(
            String token,
            String tokenType,
            long expiresInMs,
            UserDtos.UserResponse user
    ) {}

    public record MessageResponse(String message) {}
}
