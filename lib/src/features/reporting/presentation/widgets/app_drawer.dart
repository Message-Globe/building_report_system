import '../../../../l10n/string_extensions.dart';

import '../../../../utils/context_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_sizes.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../../routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Sizes.p4,
                vertical: Sizes.p8,
              ),
              padding: const EdgeInsets.all(Sizes.p16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(Sizes.p20),
              ),
              child: Center(
                child: Text(
                  context.loc.buildingReportSystem.capitalizeFirst(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(context.loc.profile.capitalizeFirst()),
            onTap: () {
              context.goNamed(AppRoute.profile.name);
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
