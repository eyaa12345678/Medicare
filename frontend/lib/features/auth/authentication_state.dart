import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import 'auth_repository.dart';
import 'auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

final authenticationStateProvider =
    StateNotifierProvider<AuthenticationController, AsyncValue<AuthUser?>>(
  (ref) => AuthenticationController(ref),
);

class AuthenticationController extends StateNotifier<AsyncValue<AuthUser?>> {
  AuthenticationController(this.ref) : super(const AsyncValue.loading()) {
    restoreSession();
  }

  final Ref ref;

  Future<void> restoreSession() async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.read();
    if (token == null || token.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final user = await ref.read(authRepositoryProvider).me();
      state = AsyncValue.data(user);
    } catch (_) {
      await storage.clear();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final session = await ref.read(authRepositoryProvider).login(email, password);
      await ref.read(tokenStorageProvider).save(session.token);
      state = AsyncValue.data(session.user);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> register(String fullName, String email, String password) async {
    try {
      final session =
          await ref.read(authRepositoryProvider).register(fullName, email, password);
      await ref.read(tokenStorageProvider).save(session.token);
      state = AsyncValue.data(session.user);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
    DateTime? birthDate,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      final user = await ref.read(authRepositoryProvider).updateProfile(
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            birthDate: birthDate,
            bio: bio,
            profilePhotoUrl: profilePhotoUrl,
          );
      state = AsyncValue.data(user);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await ref.read(authRepositoryProvider).changePassword(currentPassword, newPassword);
  }

  Future<void> forgotPassword(String email) async {
    await ref.read(authRepositoryProvider).forgotPassword(email);
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // Local logout must work even if the token is expired or the API is offline.
    }
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncValue.data(null);
  }
}
