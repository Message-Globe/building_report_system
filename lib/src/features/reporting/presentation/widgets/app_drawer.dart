import '../../../../routing/app_router.dart';

import '../../../authentication/domain/user_profile.dart';

import '../../../../l10n/string_extensions.dart';

import '../../../authentication/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userProfile = authRepository.currentUser!;
    final goRouter = ref.watch(goRouterProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              '${userProfile.name} - ${userProfile.role.toLocalizedString(context).capitalizeFirst()}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Password'),
            onTap: () {
              goRouter.pop();
              goRouter.pushNamed(AppRoute.changePassword.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authRepository.signOut();
            },
          ),
        ],
      ),
    );
  }
}
