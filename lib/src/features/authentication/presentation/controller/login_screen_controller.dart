import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/auth_repository.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  FutureOr<void> build() {}

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authenticate(email, password),
    );
    return state.hasError == false;
  }

  Future<void> sendResetPasswordEmail(String email) async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(
      () => authRepository.sendResetPasswordEmail(email),
    );
  }

  Future<bool> resetPassword(String oldPassword, String newPassword) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(
      () => authRepository.resetPassword(oldPassword, newPassword),
    );
    return state.hasError == false;
  }

  Future<void> _authenticate(String email, String password) {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.signInWithEmailAndPassword(email, password);
  }
}
