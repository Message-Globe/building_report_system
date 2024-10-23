import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/async_value_ui.dart';
import '../controller/login_screen_controller.dart';
import '../email_password_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with EmailPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _passwordVisible = false;
  var _submitted = false;

  // TODO: delete this initState after completation
  @override
  void initState() {
    super.initState();
    //!FakeRepository
    _emailController.text = "reporter@example.com";
    _passwordController.text = "password123";
    // _emailController.text = "operator@example.com";
    // _passwordController.text = "password123";

    //!RealRepository
    // _emailController.text = "dedalus80@gmail.com";
    // _passwordController.text = "AIP@5q^7^lMc";
    // _emailController.text = "manutentore@test.it";
    // _passwordController.text = "AIP@5q^7^lMc";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(loginScreenControllerProvider.notifier);
      final success = await controller.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (success) {
        ref.read(goRouterProvider).pushReplacementNamed(AppRoute.home.name);
      }
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(_emailController.text)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitPassword(_passwordController.text)) {
      _node.previousFocus();
      return;
    }
    _submit();
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
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'test@example.com',
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => !_submitted ? null : emailErrorText(email ?? ''),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => _emailEditingComplete(),
                ),
                gapH16,
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabled: !state.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => !_submitted
                      ? null
                      : passwordErrorText(
                          password ?? '',
                        ),
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => _passwordEditingComplete(),
                ),
                gapH16,
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
      ),
    );
  }
}
