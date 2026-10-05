# MediCare Full-Stack

Application mobile de suivi médical :
- Frontend : Flutter
- Backend : Spring Boot 3.5.x / Java 21
- Database : PostgreSQL
- Authentication : JWT
- API : REST

## Fonctionnalités incluses

- Inscription / connexion avec JWT
- Profil utilisateur
- CRUD rendez-vous
- CRUD médicaments
- CRUD mesures de santé
- Dashboard Flutter
- Communication Flutter -> Spring Boot via Dio
- Stockage sécurisé du JWT avec flutter_secure_storage
- PostgreSQL via Spring Data JPA
- Validation DTO
- Gestion globale des erreurs

## 1. PostgreSQL

Créer la base :

```sql
CREATE DATABASE medicare;
```

Puis définir les variables :

```text
DB_USERNAME=postgres
DB_PASSWORD=postgres
JWT_SECRET=change-this-secret-key-with-at-least-32-characters
```

## 2. Backend

```bash
cd backend
./mvnw spring-boot:run
```

ou :

```bash
mvn spring-boot:run
```

API : http://localhost:8080

Pour Android Emulator, le frontend utilise `10.0.2.2` pour atteindre le localhost de la machine.

## 3. Frontend

Le dossier Flutter contient le code applicatif. Générer les fichiers plateformes :

```bash
cd frontend
flutter create .
flutter pub get
flutter run
```

Pour un téléphone physique, modifier `frontend/lib/core/network/api_client.dart`
et remplacer `10.0.2.2` par l'adresse IP locale de la machine.

## Comptes

Inscription via l'écran Register. Le mot de passe est hashé avec BCrypt.
Le token JWT est retourné après login et envoyé ensuite dans :

```text
Authorization: Bearer <token>
```

## Architecture

Flutter
   |
   | HTTP/JSON + JWT
   v
Spring Boot REST API
   |
   | JPA/Hibernate
   v
PostgreSQL
