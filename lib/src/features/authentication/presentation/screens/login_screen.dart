import 'package:building_report_system/src/constants/app_sizes.dart';
import 'package:building_report_system/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:building_report_system/src/utils/async_value_ui.dart';

import '../controller/login_screen_controller.dart';
import '../email_password_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with EmailPasswordValidators {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_validateForm()) {
      final controller = ref.read(loginScreenControllerProvider.notifier);
      final success = await controller.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (success) {
        // Navigate to another screen on successful login
        ref.read(goRouterProvider).pushReplacementNamed(AppRoute.home.name);
      }
    }
  }

  bool _validateForm() {
    final emailValid = canSubmitEmail(_emailController.text);
    final passwordValid = canSubmitPassword(_passwordController.text);
    return emailValid && passwordValid;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      loginScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(loginScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'test@example.com',
                  errorText: _submitted ? emailErrorText(_emailController.text) : null,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: Sizes.p16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText:
                      _submitted ? passwordErrorText(_passwordController.text) : null,
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: _submit,
              ),
              const SizedBox(height: Sizes.p16),
              ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
