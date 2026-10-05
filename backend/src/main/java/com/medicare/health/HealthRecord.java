package com.medicare.health;

import com.medicare.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class HealthRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional = false)
    private User user;
    @Column(nullable = false)
    private LocalDateTime recordedAt;
    private Double weight;
    private Integer heartRate;
    private Integer systolic;
    private Integer diastolic;
    private Double temperature;
}
