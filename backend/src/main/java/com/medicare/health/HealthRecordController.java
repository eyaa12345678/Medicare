package com.medicare.health;

import com.medicare.user.repository.UserRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/health-records")
@RequiredArgsConstructor
public class HealthRecordController {
    private final HealthRecordRepository repo;
    private final UserRepository users;

    public record HealthRequest(@NotNull LocalDateTime recordedAt, Double weight,
                                Integer heartRate, Integer systolic, Integer diastolic,
                                Double temperature) {}

    @GetMapping
    public List<HealthRecord> all(Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        return repo.findByUserIdOrderByRecordedAtDesc(u.getId());
    }

    @PostMapping
    public HealthRecord create(@Valid @RequestBody HealthRequest r, Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        return repo.save(HealthRecord.builder().user(u).recordedAt(r.recordedAt())
                .weight(r.weight()).heartRate(r.heartRate()).systolic(r.systolic())
                .diastolic(r.diastolic()).temperature(r.temperature()).build());
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        var h = repo.findById(id).orElseThrow();
        if (!h.getUser().getId().equals(u.getId())) throw new RuntimeException("Forbidden");
        repo.delete(h);
    }
}
