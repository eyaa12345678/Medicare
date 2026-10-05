package com.medicare.medication;

import com.medicare.user.repository.UserRepository;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/medications")
@RequiredArgsConstructor
public class MedicationController {
    private final MedicationRepository repo;
    private final UserRepository users;

    public record MedicationRequest(@NotBlank String name, String dosage,
                                     String frequency, String instructions) {}

    @GetMapping
    public List<Medication> all(Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        return repo.findByUserIdOrderByName(u.getId());
    }

    @PostMapping
    public Medication create(@Valid @RequestBody MedicationRequest r, Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        return repo.save(Medication.builder().user(u).name(r.name()).dosage(r.dosage())
                .frequency(r.frequency()).instructions(r.instructions()).build());
    }

    @PutMapping("/{id}")
    public Medication update(@PathVariable Long id, @Valid @RequestBody MedicationRequest r,
                             Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        var m = repo.findById(id).orElseThrow();
        if (!m.getUser().getId().equals(u.getId())) throw new RuntimeException("Forbidden");
        m.setName(r.name()); m.setDosage(r.dosage()); m.setFrequency(r.frequency());
        m.setInstructions(r.instructions());
        return repo.save(m);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, Authentication auth) {
        var u = users.findByEmail(auth.getName()).orElseThrow();
        var m = repo.findById(id).orElseThrow();
        if (!m.getUser().getId().equals(u.getId())) throw new RuntimeException("Forbidden");
        repo.delete(m);
    }
}
