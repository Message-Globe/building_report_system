import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/primary_button.dart';
import '../../../../common_widgets/responsive_scrollable_card.dart';
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

  var _isResetPassword = false;

  var _passwordVisible = false;
  var _submitted = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      // !FakeRepository
      // _emailController.text = dotenv.env['FAKE_REPORTER_EMAIL']!;
      // _passwordController.text = dotenv.env['FAKE_PASSWORD']!;
      // _emailController.text = dotenv.env['FAKE_OPERATOR_EMAIL']!;
      // _passwordController.text = dotenv.env['FAKE_PASSWORD']!;

      // !RealRepository
      _emailController.text = dotenv.env['TEST_REPORTER_EMAIL']!;
      _passwordController.text = dotenv.env['TEST_PASSWORD']!;
      // _emailController.text = dotenv.env['TEST_OPERATOR_EMAIL']!;
      // _passwordController.text = dotenv.env['TEST_PASSWORD']!;
    }
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

  Future<void> _submitResetPassword() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final controller = ref.read(loginScreenControllerProvider.notifier);
      await controller.sendResetPasswordEmail(_emailController.text);
      setState(() => _isResetPassword = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Email per il reset della password inviata con successo.'),
          duration: const Duration(seconds: 3),
        ),
      );
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
      body: ResponsiveScrollableCard(
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/splash_screen.png',
                    height: 120,
                  ),
                ),
                gapH32,
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
                if (!_isResetPassword) ...[
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
                ],
                gapH16,
                PrimaryButton(
                  isLoading: state.isLoading,
                  onPressed: state.isLoading
                      ? null
                      : _isResetPassword
                          ? _submitResetPassword
                          : _submit,
                  text:
                      _isResetPassword ? context.loc.sendLink.capitalizeFirst() : 'Login',
                ),
                gapH16,
                TextButton(
                  onPressed: () => setState(
                    () => _isResetPassword = !_isResetPassword,
                  ),
                  child: Text(
                    _isResetPassword
                        ? context.loc.cancel.capitalizeFirst()
                        : context.loc.forgotPassword.capitalizeFirst(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
