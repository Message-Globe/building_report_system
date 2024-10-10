import 'package:building_report_system/src/features/reporting/data/reports_repository.dart';
import 'package:building_report_system/src/features/reporting/data/test_reports.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:building_report_system/src/utils/delay.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/data/auth_repository.dart';
import '../../authentication/domain/user_profile.dart';

part 'fake_reports_repository.g.dart';

class FakeReportsRepository implements ReportsRepository {
  final bool addDelay;

  FakeReportsRepository({this.addDelay = true});

  final _reports = kTestReports;

  @override
  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  }) async {
    await delay(addDelay);

    // Filtro per ruolo dell'utente
    List<Report> filteredReports = _reports.where((report) {
      if (userProfile.role == UserRole.reporter) {
        // Se l'utente è un reporter, mostra solo i suoi report
        if (report.userId != userProfile.appUser.uid) {
          return false;
        }
      } else if (userProfile.role == UserRole.operator) {
        // Se è un operatore, mostra solo i report degli edifici assegnati
        if (!userProfile.buildingsIds.contains(report.buildingId)) {
          return false;
        }
      }
      // Se è un admin, non facciamo alcun filtro sull'utente o sugli edifici (vedrà tutto)

      // Filtro per edificio (se selezionato un edificio specifico)
      if (buildingId != null && report.buildingId != buildingId) {
        return false;
      }

      // Filtro per status
      if (report.status == ReportStatus.active) {
        return true; // Mostra sempre report attivi
      } else if (report.status == ReportStatus.completed && showCompleted) {
        return true; // Mostra report completati se il filtro è abilitato
      } else if (report.status == ReportStatus.deleted && showDeleted) {
        return true; // Mostra report eliminati se il filtro è abilitato
      }
      return false;
    }).toList();

    // Ordina i report per data (i più recenti prima, per default)
    filteredReports.sort((a, b) => a.date.compareTo(b.date));

    // Se reverseOrder è true, inverti l'ordine della lista
    if (reverseOrder) {
      filteredReports = filteredReports.reversed.toList();
    }

    return filteredReports;
  }
}

@riverpod
FakeReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return FakeReportsRepository();
}

@riverpod
Future<List<Report>> reportsListFuture(
  ReportsListFutureRef ref, {
  bool showCompleted = false,
  bool showDeleted = false,
  bool reverseOrder = false,
  String? buildingId, // Filtro opzionale per edificio
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);

  // Ottieni l'utente corrente dal provider di autenticazione
  final userProfile = ref.watch(authStateProvider).asData?.value;

  if (userProfile == null) {
    throw Exception("User not authenticated");
  }

  return reportsRepository.fetchReportsList(
    showCompleted: showCompleted,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
    userProfile: userProfile, // Passa il profilo utente per gestire i filtri
    buildingId: buildingId, // Filtro opzionale edificio
  );
}
