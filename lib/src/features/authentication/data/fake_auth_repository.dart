// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:building_report_system/src/utils/in_memory_store.dart';

import '../domain/user_profile.dart';
import 'test_users.dart';

class FakeAuthRepository implements AuthRepository {
  final bool addDelay;

  FakeAuthRepository({required this.addDelay});

  final _authState = InMemoryStore<UserProfile?>(null);

  @override
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = kTestUsers.firstWhere(
      (profile) =>
          profile.appUser.email == email && kTestUserPasswords[email] == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    _authState.value = user;
    return null;
  }

  @override
  Future<void> signOut() async {
    _authState.value = null;
  }

  @override
  UserProfile? get currentUser => _authState.value;

  @override
  Stream<UserProfile?> get authStateChanges => _authState.stream;
}
