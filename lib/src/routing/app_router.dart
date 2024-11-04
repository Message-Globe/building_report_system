import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/reporting/domain/report.dart';
import '../features/reporting/presentation/screens/create_report_screen.dart';
import '../features/reporting/presentation/screens/edit_report_screen.dart';
import '../features/reporting/presentation/screens/photo_view_gallery_screen.dart';
import '../features/reporting/presentation/screens/reports_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/data/auth_repository.dart';

import '../features/authentication/presentation/screens/login_screen.dart';

part 'app_router.g.dart';

enum AppRoute {
  login,
  home,
  createReport,
  editReport,
  photoGallery,
  profile,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: "/",
    debugLogDiagnostics: true,
    refreshListenable: authRepository,
    redirect: (context, state) {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;

      // Logica di redirect per gestire il login/logout
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
        builder: (context, state) => const ReportsListScreen(),
        routes: [
          GoRoute(
            path: "create-report",
            name: AppRoute.createReport.name,
            builder: (context, state) => const CreateReportScreen(),
          ),
          GoRoute(
            path: "edit-report",
            name: AppRoute.editReport.name,
            builder: (context, state) {
              final report = state.extra as Report;
              return EditReportScreen(report: report);
            },
          ),
          GoRoute(
            path: "photo-gallery",
            name: AppRoute.photoGallery.name,
            builder: (context, state) {
              final args = state.extra as PhotoViewGalleryArgs;
              return PhotoViewGalleryScreen(
                imageUrls: args.imageUrls,
                imageUris: args.imageUris,
                initialIndex: args.initialIndex,
              );
            },
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
