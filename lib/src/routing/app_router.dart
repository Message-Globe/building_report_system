import 'package:building_report_system/src/features/reporting/presentation/screens/reports_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRoute {
  home,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: "/",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: "/",
        name: AppRoute.home.name,
        builder: (context, state) => const ReportsListScreen(
          userType: 'Operator',
        ),
      ),
    ],
  );
}
