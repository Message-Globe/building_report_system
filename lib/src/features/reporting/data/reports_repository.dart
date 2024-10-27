import 'package:building_report_system/src/features/authentication/domain/building.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'fake_reports_repository.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  Future<List<Report>> fetchReportsList();

  Future<Report> addReport({
    required String createdBy,
    required Building building,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    required List<String>? photoUrls,
  });

  Future<void> deleteReport(Report report);

  Future<void> updateReport({
    required Report report,
    Building? building,
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
ReportsRepository reportsRepository(Ref ref) {
  // TODO: switch with real repo after completation
  return FakeReportsRepository();
}

@Riverpod(keepAlive: true)
Future<List<Report>> reportsListFuture(Ref ref) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  return reportsRepository.fetchReportsList();
}
