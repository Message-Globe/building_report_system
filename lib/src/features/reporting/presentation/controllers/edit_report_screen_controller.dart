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
    required String buildingId,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    List<String>? photoUrls,
    required String repairDescription,
    List<String>? repairPhotosUrls,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(reportsRepositoryProvider).updateReport(
            report: report,
            buildingId: buildingId,
            buildingSpot: buildingSpot,
            priority: priority,
            title: title,
            description: description,
            photoUrls: photoUrls,
            repairDescription: repairDescription,
            repairPhotosUrls: repairPhotosUrls,
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
