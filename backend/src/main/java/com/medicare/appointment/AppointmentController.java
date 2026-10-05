package com.medicare.appointment;

import com.medicare.user.repository.UserRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/appointments")
@RequiredArgsConstructor
public class AppointmentController {
    private final AppointmentRepository repo;
    private final UserRepository users;

    public record AppointmentRequest(@NotNull LocalDateTime dateTime,
                                      @NotBlank String doctorName,
                                      String reason) {}

    @GetMapping
    public List<Appointment> all(Authentication auth) {
        var user = users.findByEmail(auth.getName()).orElseThrow();
        return repo.findByUserIdOrderByDateTimeDesc(user.getId());
    }

    @PostMapping
    public Appointment create(@Valid @RequestBody AppointmentRequest req, Authentication auth) {
        var user = users.findByEmail(auth.getName()).orElseThrow();
        return repo.save(Appointment.builder().user(user)
                .dateTime(req.dateTime()).doctorName(req.doctorName())
                .reason(req.reason()).status("PLANNED").build());
    }

    @PutMapping("/{id}")
    public Appointment update(@PathVariable Long id, @Valid @RequestBody AppointmentRequest req,
                              Authentication auth) {
        var user = users.findByEmail(auth.getName()).orElseThrow();
        var a = repo.findById(id).orElseThrow();
        if (!a.getUser().getId().equals(user.getId())) throw new RuntimeException("Forbidden");
        a.setDateTime(req.dateTime()); a.setDoctorName(req.doctorName()); a.setReason(req.reason());
        return repo.save(a);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, Authentication auth) {
        var user = users.findByEmail(auth.getName()).orElseThrow();
        var a = repo.findById(id).orElseThrow();
        if (!a.getUser().getId().equals(user.getId())) throw new RuntimeException("Forbidden");
        repo.delete(a);
    }
}
