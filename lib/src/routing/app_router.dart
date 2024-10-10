import 'package:building_report_system/src/features/reporting/presentation/screens/report_create_screen.dart';
import 'package:building_report_system/src/features/reporting/presentation/screens/reports_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';

import '../features/authentication/presentation/screens/login_screen.dart';

part 'app_router.g.dart';

enum AppRoute {
  login,
  home,
  createReport,
  profile,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/",
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = authState.asData?.value;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/login') {
          return '/';
        }
      } else {
        if (path != "/login") {
          return "/login";
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: "/",
        name: AppRoute.home.name,
        builder: (context, state) {
          final userProfile = authState.asData!.value!;

          return ReportsListScreen(
            userRole: userProfile.role,
            buildingsIds: userProfile.buildingsIds,
          );
        },
        routes: [
          GoRoute(
            path: "create-report",
            name: AppRoute.createReport.name,
            builder: (context, state) => const ReportCreateScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/login",
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
