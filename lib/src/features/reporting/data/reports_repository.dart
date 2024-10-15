import '../../authentication/domain/user_profile.dart';
import '../domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/data/auth_repository.dart';
import 'fake_reports_repository.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  Stream<List<Report>> get reportsStream;

  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  });

  Stream<List<Report>> watchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  });

  Future<void> addReport({
    required String userId,
    required String buildingId,
    required String title,
    required String description,
    required List<String>? photoUrls,
  });

  Future<void> deleteReport(Report report);

  Future<void> updateReport({
    required Report report,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
  });

  Future<void> assignReportToOperator({
    required Report report,
    required String operatorId,
  });

  Future<void> unassignReportFromOperator(Report report);

  Future<void> completeReport(Report report);
}

@riverpod
ReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return FakeReportsRepository();
}

@riverpod
Future<List<Report>> reportsListFuture(
  ReportsListFutureRef ref, {
  bool showCompleted = false,
  bool showDeleted = false,
  bool reverseOrder = false,
  String? buildingId,
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  final userProfile = ref.watch(authStateProvider).asData!.value!;

  return reportsRepository.fetchReportsList(
    showCompleted: showCompleted,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
    userProfile: userProfile,
    buildingId: buildingId,
  );
}

@riverpod
Stream<List<Report>> reportsListStream(
  ReportsListStreamRef ref, {
  bool showCompleted = false,
  bool showDeleted = false,
  bool reverseOrder = false,
  String? buildingId,
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  final userProfile = ref.watch(authStateProvider).asData!.value!;

  return reportsRepository.watchReportsList(
    showCompleted: showCompleted,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
    userProfile: userProfile,
    buildingId: buildingId,
  );
}

@riverpod
Future<int> openReportsCount(OpenReportsCountRef ref) async {
  final reports = await ref.watch(
    reportsListFutureProvider(
      showCompleted: false,
      showDeleted: false,
      reverseOrder: false,
    ).future,
  );

  return reports.where((report) => report.status == ReportStatus.open).length;
}
