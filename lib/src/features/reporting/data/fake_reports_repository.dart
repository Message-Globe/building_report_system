import 'package:building_report_system/src/features/reporting/data/reports_repository.dart';
import 'package:building_report_system/src/features/reporting/data/test_reports.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:building_report_system/src/utils/delay.dart';
import 'package:building_report_system/src/utils/in_memory_store.dart';

import '../../authentication/domain/user_profile.dart';

class FakeReportsRepository implements ReportsRepository {
  final bool addDelay;

  FakeReportsRepository({this.addDelay = true});

  final _reports = InMemoryStore<List<Report>>(List.from(kTestReports));

  @override
  Stream<List<Report>> get reportsStream => _reports.stream;

  @override
  Future<List<Report>> fetchReportsList({
    required bool showworked,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  }) async {
    await delay(addDelay);

    // Filtro per ruolo dell'utente
    List<Report> filteredReports = _reports.value.where((report) {
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
      if (report.status == ReportStatus.open) {
        return true; // Mostra sempre report attivi
      } else if (report.status == ReportStatus.worked && showworked) {
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

  @override
  Future<void> addReport({
    required UserProfile userProfile,
    required String buildingId,
    required String title,
    required String description,
    required List<String> photoUrls,
  }) async {
    await delay(addDelay);

    final newReport = Report(
      userId: userProfile.appUser.uid,
      buildingId: buildingId,
      title: title,
      description: description,
      status: ReportStatus.open,
      date: DateTime.now(),
      photoUrls: [],
    );

    // Aggiungi il nuovo report alla lista
    _reports.value = [..._reports.value, newReport];
  }

  @override
  Future<void> deleteReport(Report report) async {
    await delay(addDelay);

    final index = _reports.value.indexOf(report);
    if (index != -1) {
      // Invece di rimuovere fisicamente il report, lo marchiamo come "deleted"
      _reports.value[index] = report.copyWith(status: ReportStatus.deleted);
    }
  }

  @override
  Future<void> updateReport({
    required Report report,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
  }) async {
    await delay(addDelay);

    final index = _reports.value.indexOf(report);
    if (index != -1) {
      // Aggiorna i campi del report solo se vengono forniti nuovi valori
      _reports.value[index] = report.copyWith(
        title: title,
        description: description,
        photoUrls: photoUrls ?? report.photoUrls,
        status: status ?? report.status,
      );
    }
  }
}
