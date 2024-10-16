import 'fake_auth_repository.dart';
import '../domain/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  UserProfile? get currentUser;
  Stream<UserProfile?> get authStateChanges;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FakeAuthRepository(addDelay: true);
}

@Riverpod(keepAlive: true)
Stream<UserProfile?> authState(AuthStateRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}

@riverpod
UserRole? userRole(UserRoleRef ref) {
  final userProfile = ref.watch(authStateProvider).asData?.value;

  if (userProfile == null) {
    return null;
  }
  return userProfile.role;
}
