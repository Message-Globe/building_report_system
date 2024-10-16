import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';

part 'edit_report_screen_controller.g.dart';

@riverpod
class EditReportScreenController extends _$EditReportScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> updateReport({
    required Report report,
    required String title,
    required String description,
    required String buildingSpot,
    required PriorityLevel priority,
    List<String>? photoUrls,
    ReportStatus? status,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).updateReport(
            report: report,
            title: title,
            description: description,
            buildingSpot: buildingSpot,
            priority: priority,
            photoUrls: photoUrls,
            status: status,
          ),
    );
  }

  Future<void> completeReport({
    required Report report,
    required String repairDescription,
    List<String>? repairPhotosUrls,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).updateReport(
            report: report,
            status: ReportStatus.completed,
            repairDescription: repairDescription,
            repairPhotosUrls: repairPhotosUrls,
          ),
    );
  }
}
