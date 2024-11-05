import '../../authentication/data/auth_repository.dart';
import 'http_reports_repository.dart';

import '../../authentication/domain/building.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/domain/user_profile.dart';
import '../domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  Future<List<Report>> fetchReportsList(UserProfile currentUser);

  Future<Report> addReport({
    required UserProfile currentUser,
    required String title,
    required String description,
    required Building building,
    required String buildingSpot,
    required PriorityLevel priority,
    List<String>? photos,
  });

  Future<void> deleteReport(String reportId);

  Future<Report> updateReport({
    required UserProfile currentUser,
    required String reportId,
    ReportStatus? status,
    String? title,
    String? description,
    Building? building,
    String? buildingSpot,
    PriorityLevel? priority,
    List<String>? photosUrls,
    List<String>? newPhotos,
    String? maintenanceDescription,
    List<String>? maintenancePhotoUrls,
    List<String>? newMaintenancePhotos,
  });

  Future<Report> assignReportToOperator({
    required UserProfile currentUser,
    required String reportId,
    required String maintenanceDescription,
  });

  Future<Report> unassignReportFromOperator({
    required UserProfile currentUser,
    required String reportId,
    required String maintenanceDescription,
  });

  Future<void> completeReport({
    required UserProfile currentUser,
    required String reportId,
    required String maintenanceDescription,
    List<String>? maintenancePhotosUrls,
  });
}

@riverpod
ReportsRepository reportsRepository(Ref ref) {
  final userToken = ref.watch(authRepositoryProvider).userToken;
  return HttpReportsRepository(userToken: userToken);
}

@riverpod
Future<List<Report>> reportsListFuture(Ref ref) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  final currentUser = ref.read(authRepositoryProvider).currentUser;
  return reportsRepository.fetchReportsList(currentUser!);
}
