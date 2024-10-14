import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/data/auth_repository.dart';
import 'fake_reports_repository.dart';

part 'reports_repository.g.dart';

abstract class ReportsRepository {
  /// Recupera la lista dei report, con filtri per:
  /// - [showworked]: mostra report completati
  /// - [showDeleted]: mostra report eliminati
  /// - [reverseOrder]: ordine inverso per data
  /// - [userProfile]: il profilo dell'utente corrente, utilizzato per filtrare i report in base al ruolo
  /// - [buildingId]: opzionale, filtra per edificio specifico
  Future<List<Report>> fetchReportsList({
    required bool showworked,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile, // Profilo utente obbligatorio
    String? buildingId, // Filtro opzionale per edificio
  });

  /// Aggiunge un nuovo report
  Future<void> addReport({
    required UserProfile userProfile,
    required String buildingId,
    required String title,
    required String description,
    required List<String> photoUrls,
  });

  /// Modifica un report esistente
  Future<void> updateReport({
    required Report report,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
  });

  /// Elimina un report (cambia il suo stato in deleted)
  Future<void> deleteReport(Report report);

  Stream<List<Report>> get reportsStream;
}

@riverpod
ReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return FakeReportsRepository();
}

@riverpod
Future<List<Report>> reportsListFuture(
  ReportsListFutureRef ref, {
  bool showworked = false,
  bool showDeleted = false,
  bool reverseOrder = false,
  String? buildingId,
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);

  // Ottieni l'utente corrente dal provider di autenticazione
  final userProfile = ref.watch(authStateProvider).asData?.value;

  if (userProfile == null) {
    throw Exception("User not authenticated");
  }

  return reportsRepository.fetchReportsList(
    showworked: showworked,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
    userProfile: userProfile, // Passa il profilo utente per gestire i filtri
    buildingId: buildingId, // Filtro opzionale edificio
  );
}

@riverpod
Stream<List<Report>> reportsListStream(
  ReportsListStreamRef ref, {
  bool showworked = false,
  bool showDeleted = false,
  bool reverseOrder = false,
  String? buildingId,
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);

  // Ottieni l'utente corrente dal provider di autenticazione
  final userProfile = ref.watch(authStateProvider).asData?.value;

  if (userProfile == null) {
    throw Exception("User not authenticated");
  }

  // Applica i filtri e restituisci lo stream filtrato
  return reportsRepository.reportsStream.map((reports) {
    List<Report> filteredReports = reports.where((report) {
      // Applica i filtri basati sul ruolo dell'utente
      if (userProfile.role == UserRole.reporter) {
        if (report.userId != userProfile.appUser.uid) return false;
      } else if (userProfile.role == UserRole.operator) {
        if (!userProfile.buildingsIds.contains(report.buildingId)) return false;
      }

      // Filtro per edificio
      if (buildingId != null && report.buildingId != buildingId) return false;

      // Filtro per stato
      if (report.status == ReportStatus.open) return true;
      if (report.status == ReportStatus.worked && showworked) return true;
      if (report.status == ReportStatus.deleted && showDeleted) return true;

      return false;
    }).toList();

    // Ordina i report per data
    if (reverseOrder) {
      filteredReports.sort((a, b) => b.date.compareTo(a.date));
    } else {
      filteredReports.sort((a, b) => a.date.compareTo(b.date));
    }

    return filteredReports;
  });
}

@riverpod
Future<int> openReportsCount(OpenReportsCountRef ref) async {
  final reports = await ref.watch(
    reportsListFutureProvider(
      showworked: false,
      showDeleted: false,
      reverseOrder: false,
    ).future,
  );

  return reports.where((report) => report.status == ReportStatus.open).length;
}
