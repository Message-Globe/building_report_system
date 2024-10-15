import '../../../utils/delay.dart';
import '../../../utils/in_memory_store.dart';
import '../../authentication/domain/user_profile.dart';
import '../domain/report.dart';
import 'reports_repository.dart';
import 'test_reports.dart';

class FakeReportsRepository implements ReportsRepository {
  final bool addDelay;

  FakeReportsRepository({this.addDelay = true});

  final _reports = InMemoryStore<List<Report>>(kTestReports);

  @override
  Stream<List<Report>> get reportsStream => _reports.stream;

  @override
  Future<List<Report>> fetchReportsList({
    required UserProfile userProfile,
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    // TODO: make buildingIds, so that I can have multiple buildingId to filter
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

  @override
  Stream<List<Report>> watchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile,
    String? buildingId,
  }) {
    return reportsStream.map((reports) {
      List<Report> filteredReports = reports.where((report) {
        if (userProfile.role == UserRole.reporter) {
          if (report.userId != userProfile.appUser.uid) return false;
        } else if (userProfile.role == UserRole.operator) {
          if (!userProfile.buildingsIds.contains(report.buildingId)) return false;
        }

        // Filtro per edificio
        if (buildingId != null && report.buildingId != buildingId) return false;

        // Filtro per stato
        if (report.status == ReportStatus.open ||
            report.status == ReportStatus.assigned) {
          return true;
        }
        if (report.status == ReportStatus.completed && showCompleted) return true;
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

  @override
  Future<void> addReport({
    required String userId,
    required String buildingId,
    required String title,
    required String description,
    required List<String>? photoUrls,
  }) async {
    await delay(addDelay);

    final newReport = Report(
      userId: userId,
      buildingId: buildingId,
      title: title,
      description: description,
      status: ReportStatus.open,
      date: DateTime.now(),
      photoUrls: photoUrls ?? [],
      operatorId: '',
      repairDescription: '',
      repairPhotosUrls: [],
    );

    _reports.value = [..._reports.value, newReport];
  }

  @override
  Future<void> deleteReport(Report report) async {
    if (report.status != ReportStatus.open) {
      throw Exception("Only unassigned reports can be deleted.");
    }
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
    String? buildingId,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
    List<String>? repairPhotosUrls,
    String? operatorId,
    String? repairDescription,
  }) async {
    await delay(addDelay);

    final index = _reports.value.indexOf(report);
    if (index != -1) {
      _reports.value[index] = report.copyWith(
        buildingId: buildingId,
        title: title,
        description: description,
        status: status,
        photoUrls: photoUrls,
        repairPhotosUrls: repairPhotosUrls,
        operatorId: operatorId,
        repairDescription: repairDescription,
      );
    }
  }

  @override
  Future<void> assignReportToOperator({
    required Report report,
    required String operatorId,
  }) async {
    // Assicura che il report sia ancora open
    if (report.status != ReportStatus.open) {
      throw Exception("Report is already assigned.");
    }
    // Assegna il report all'operatore
    updateReport(
      report: report,
      status: ReportStatus.assigned,
      operatorId: operatorId,
    );
  }

  @override
  Future<void> unassignReportFromOperator(Report report) async {
    if (report.status != ReportStatus.assigned) {
      throw Exception("Only assigned reports can be unassigned.");
    }
    updateReport(
      report: report,
      status: ReportStatus.open,
      operatorId: '',
    );
  }

  @override
  Future<void> completeReport(Report report) async {
    if (report.status != ReportStatus.assigned) {
      throw Exception("Only assigned reports can be completed.");
    }
    if (report.repairDescription.isEmpty && report.repairPhotosUrls.isEmpty) {
      throw Exception("At least repair description or photos must be provided.");
    }
    updateReport(
      report: report,
      status: ReportStatus.completed,
    );
  }
}
