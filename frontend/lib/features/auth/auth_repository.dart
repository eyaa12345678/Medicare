import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import 'auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.user,
  });

  final String token;
  final AuthUser user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] as String,
      user: AuthUser.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
    );
  }
}

class AuthRepository {
  final ApiClient api;
  AuthRepository(this.api);

  Future<AuthSession> login(String email, String password) async {
    final Response response = await api.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthSession.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<AuthSession> register(
      String fullName, String email, String password) async {
    final Response response = await api.dio.post('/auth/register', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });
    return AuthSession.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<AuthUser> me() async {
    final Response response = await api.dio.get('/users/me');
    return AuthUser.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<AuthUser> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
    DateTime? birthDate,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    final Response response = await api.dio.put('/users/me', data: {
      'fullName': fullName,
      'email': email,
      'phoneNumber': _blankToNull(phoneNumber),
      'birthDate': birthDate?.toIso8601String().split('T').first,
      'bio': _blankToNull(bio),
      'profilePhotoUrl': _blankToNull(profilePhotoUrl),
    });
    return AuthUser.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await api.dio.put('/users/me/password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<void> forgotPassword(String email) async {
    await api.dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> logout() async {
    await api.dio.post('/auth/logout');
  }

  String? _blankToNull(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
