import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';

part 'report_dismissible_tile_controller.g.dart';

@riverpod
class ReportDismissibleTileController extends _$ReportDismissibleTileController {
  @override
  FutureOr<void> build() {}

  Future<void> deleteReport(Report report) async {
    state = const AsyncLoading();
    await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).deleteReport(report),
    );
  }

  Future<void> assignReport(Report report) async {
    state = const AsyncLoading();
    final userProfile = ref.read(authRepositoryProvider).currentUser!;
    state = await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).assignReportToOperator(
            report: report,
            operatorId: userProfile.appUser.uid,
          ),
    );
  }

  Future<void> unassignReport(Report report) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).unassignReportFromOperator(report),
    );
  }
}
