import '../../authentication/data/auth_repository.dart';
import 'http_reports_repository.dart';

import '../../authentication/domain/building.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/domain/user_profile.dart';
import '../domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  Future<List<Map<String, String>>> fetchBuildingAreas({
    required String buildingId,
    required int page,
  });

  Future<List<String>> fetchReportCategories();

  Future<List<Map<String, String>>> fetchMaintenanceTeams(String reportId);

  Future<List<Report>> fetchReportsList(UserProfile currentUser);

  Future<Report> fetchReport({
    required UserProfile currentUser,
    required String reportId,
  });

  Future<Report> addReport({
    required String category,
    required UserProfile currentUser,
    required String description,
    required Building building,
    required String buildingAreaId,
    required PriorityLevel priority,
    List<String>? photos,
    String? resolveBy,
  });

  Future<void> deleteReport(String reportId);

  Future<Report> updateReport({
    required UserProfile currentUser,
    required String reportId,
    String operatorId,
    ReportStatus? status,
    String? category,
    String? title,
    String? description,
    String? resolveBy,
    Building? building,
    String? buildingAreaId,
    PriorityLevel? priority,
    bool? escalatedToAdmin,
    bool? areaNotAvailable,
    List<String>? photosUrls,
    List<String>? newPhotos,
    String? maintenanceDescription,
    List<String>? maintenancePhotoUrls,
    List<String>? newMaintenancePhotos,
  });

  Future<void> assignReportToUser({
    required String reportId,
    required int userId,
  });

  Future<Report> assignReportToOperator({
    required UserProfile currentUser,
    required String reportId,
    required String operatorId,
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
