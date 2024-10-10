import 'package:building_report_system/src/constants/app_sizes.dart';
import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:building_report_system/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.read(goRouterProvider);
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
              child: const Center(
                child: Text(
                  'Building Report System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              goRouter.pushNamed(AppRoute.profile.name);
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
