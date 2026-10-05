class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.birthDate,
    this.bio,
    this.profilePhotoUrl,
  });

  final int id;
  final String fullName;
  final String email;
  final String role;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? bio;
  final String? profilePhotoUrl;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      phoneNumber: json['phoneNumber'] as String?,
      birthDate: _parseDate(json['birthDate']),
      bio: json['bio'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}
