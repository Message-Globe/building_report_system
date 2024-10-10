import 'package:building_report_system/src/features/authentication/data/fake_auth_repository.dart';
import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  UserProfile? get currentUser;
  Stream<UserProfile?> get authStateChanges;
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FakeAuthRepository(addDelay: true);
}

@riverpod
Stream<UserProfile?> authState(AuthStateRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}
