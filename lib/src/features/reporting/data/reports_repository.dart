import '../../authentication/domain/user_profile.dart';
import '../domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/data/auth_repository.dart';
import '../presentation/controllers/filters_controllers.dart';
import 'fake_reports_repository.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  });

  Future<Report> addReport({
    required String createdBy,
    required String buildingId,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    required List<String>? photoUrls,
  });

  Future<void> deleteReport(Report report);

  Future<void> updateReport({
    required Report report,
    String? buildingId,
    String? buildingSpot,
    PriorityLevel? priority,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
    String? assignedTo, // Modificato da operatorId a assignedTo
    String? maintenanceDescription,
    List<String>? maintenancePhotoUrls,
  });

  Future<void> assignReportToOperator({
    required Report report,
    required String operatorId, // Modificato da operatorId a assignedTo
  });

  Future<void> unassignReportFromOperator(Report report);

  Future<void> completeReport(Report report);
}

@Riverpod(keepAlive: true)
ReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  // TODO: switch with real repo after completation
  return FakeReportsRepository();
}

@riverpod
Future<List<Report>> reportsListFuture(ReportsListFutureRef ref) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  final userProfile = ref.watch(authRepositoryProvider).currentUser!;

  final showCompleted = ref.watch(showworkedFilterProvider);
  final showDeleted = ref.watch(showDeletedFilterProvider);
  final reverseOrder = ref.watch(reverseOrderFilterProvider);
  final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

  return reportsRepository.fetchReportsList(
    showCompleted: showCompleted,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
    userProfile: userProfile,
    buildingId: selectedBuilding,
  );
}
