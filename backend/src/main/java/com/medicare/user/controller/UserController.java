package com.medicare.user.controller;

import com.medicare.auth.dto.AuthDtos;
import com.medicare.user.dto.UserDtos;
import com.medicare.user.service.UserService;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/me")
    public UserDtos.UserResponse me(Authentication authentication) {
        return userService.currentProfile(authentication);
    }

    @PutMapping("/me")
    public UserDtos.UserResponse updateMe(
            @Valid @RequestBody UserDtos.UpdateProfileRequest request,
            Authentication authentication) {
        return userService.updateProfile(authentication, request);
    }

    @PutMapping("/me/password")
    public AuthDtos.MessageResponse changePassword(
            @Valid @RequestBody UserDtos.ChangePasswordRequest request,
            Authentication authentication) {
        userService.changePassword(authentication, request);
        return new AuthDtos.MessageResponse("Password updated successfully");
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public List<UserDtos.UserResponse> allUsers() {
        return userService.findAll();
    }

    @PatchMapping("/{id}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public UserDtos.UserResponse updateRole(
            @PathVariable Long id,
            @Valid @RequestBody UserDtos.UpdateRoleRequest request) {
        return userService.updateRole(id, request);
    }
}
