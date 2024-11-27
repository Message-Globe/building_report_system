import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_profile.dart';
import 'http_auth_repository.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository with ChangeNotifier {
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password);
  Future<void> sendResetPasswordEmail(String email);
  Future<void> resetPassword(String oldPassword, String newPassword);
  Future<void> signOut();
  UserProfile? get currentUser;
  Future<UserProfile?> checkUserToken();
  set fcmToken(String? fcmToken);
  set deviceType(String deviceType);
  set deviceId(String? deviceId);
  String get userToken;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return HttpAuthRepository();
}
