package com.medicare.appointment;

import com.medicare.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Appointment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional = false)
    private User user;
    @Column(nullable = false)
    private LocalDateTime dateTime;
    @Column(nullable = false)
    private String doctorName;
    private String reason;
    @Builder.Default
    private String status = "PLANNED";
}
