import '../../data/auth_repository.dart';
import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/primary_button.dart';
import '../../../../common_widgets/responsive_scrollable_card.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../utils/async_value_ui.dart';
import '../controller/login_screen_controller.dart';
import '../email_password_validators.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen>
    with EmailPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _oldPasswordController = TextEditingController();
  final _repeatOldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  var _passwordVisible = false;
  var _submitted = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _repeatOldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(loginScreenControllerProvider.notifier);
      final success = await controller.resetPassword(
        _repeatOldPasswordController.text,
        _newPasswordController.text,
      );
      if (success) {
        ref.read(authRepositoryProvider).signOut();
      }
    }
  }

  bool _oldPasswordMatching() {
    return _oldPasswordController.text == _repeatOldPasswordController.text;
  }

  void _oldPasswordEditingComplete() {
    if (canSubmitPassword(_oldPasswordController.text)) {
      _node.nextFocus();
    }
  }

  void _repeatOldPasswordEditingComplete() {
    if (canSubmitPassword(_repeatOldPasswordController.text) && _oldPasswordMatching()) {
      _node.nextFocus();
    }
  }

  void _newPasswordEditingComplete() {
    if (!complexCanSubmitPassword(_newPasswordController.text) &&
        _oldPasswordMatching()) {
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
      appBar: AppBar(title: Text(context.loc.forgotPassword.capitalizeFirst())),
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
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    labelText: context.loc.oldPassword.capitalizeFirst(),
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
                  onEditingComplete: () => _oldPasswordEditingComplete(),
                ),
                gapH16,
                TextFormField(
                  controller: _repeatOldPasswordController,
                  decoration: InputDecoration(
                    labelText: context.loc.repeatOldPassword.capitalizeFirst(),
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
                  validator: (password) {
                    if (!_submitted) return null;
                    if (password == null || password.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (password != _oldPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => _repeatOldPasswordEditingComplete(),
                ),
                gapH16,
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: context.loc.newPassword.capitalizeFirst(),
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
                      : complexPasswordErrorText(
                          password ?? '',
                        ),
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => _newPasswordEditingComplete(),
                ),
                gapH16,
                PrimaryButton(
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                  text: 'Change password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
