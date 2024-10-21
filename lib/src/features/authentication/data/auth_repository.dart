import 'package:building_report_system/src/features/authentication/data/http_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_profile.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository with ChangeNotifier {
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  UserProfile? get currentUser;
  Future<UserProfile?> checkToken();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // return FakeAuthRepository();
  return HttpAuthRepository();
}
