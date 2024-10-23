import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/domain/user_profile.dart';
import '../../domain/report.dart';
import 'reports_list_controller.dart';

part 'report_dismissible_tile_controller.g.dart';

@riverpod
class ReportDismissibleTileController extends _$ReportDismissibleTileController {
  @override
  FutureOr<void> build() {}

  Future<void> assignReport(
    Report report,
    UserProfile userProfile,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reportsListControllerProvider.notifier).assignReport(
            report: report,
            operatorId: userProfile.appUser.uid,
          ),
    );
  }

  Future<void> unassignReport(Report report) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(reportsListControllerProvider.notifier).unassignReport(report));
  }

  Future<void> deleteReport(Report report) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reportsListControllerProvider.notifier).deleteReport(report),
    );
  }
}
