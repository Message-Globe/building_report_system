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

  // Metodo per filtrare i report in base al ruolo dell'utente
  bool _filterByUserRole(Report report, UserProfile userProfile) {
    if (userProfile.role == UserRole.reporter) {
      return report.userId == userProfile.appUser.uid;
    } else if (userProfile.role == UserRole.operator) {
      return userProfile.buildingsIds.contains(report.buildingId);
    }
    // Se è un admin, mostra tutti i report
    return true;
  }

// Metodo per filtrare i report in base all'edificio
  bool _filterByBuilding(Report report, String? buildingId) {
    if (buildingId != null) {
      return report.buildingId == buildingId;
    }
    // Se nessun edificio specifico è selezionato, mostra tutti i report
    return true;
  }

// Metodo per filtrare i report in base allo stato
  bool _filterByStatus(Report report, bool showCompleted, bool showDeleted) {
    if (report.status == ReportStatus.open || report.status == ReportStatus.assigned) {
      return true; // Mostra sempre report attivi e assegnati
    } else if (report.status == ReportStatus.completed) {
      return showCompleted; // Mostra solo se showCompleted è abilitato
    } else if (report.status == ReportStatus.deleted) {
      return showDeleted; // Mostra solo se showDeleted è abilitato
    }
    return false;
  }

  @override
  Future<List<Report>> fetchReportsList({
    required UserProfile userProfile,
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    String? buildingId,
  }) async {
    await delay(addDelay);

    // Filtra i report
    List<Report> filteredReports = _reports.value
        .where((report) => _filterByUserRole(report, userProfile))
        .where((report) => _filterByBuilding(report, buildingId))
        .where((report) => _filterByStatus(report, showCompleted, showDeleted))
        .toList();

    // Ordina i report per data
    filteredReports.sort((a, b) => a.date.compareTo(b.date));

    // Inverti l'ordine se necessario
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
      // Filtra i report
      List<Report> filteredReports = _reports.value
          .where((report) => _filterByUserRole(report, userProfile))
          .where((report) => _filterByBuilding(report, buildingId))
          .where((report) => _filterByStatus(report, showCompleted, showDeleted))
          .toList();

      // Ordina i report per data
      filteredReports.sort((a, b) => a.date.compareTo(b.date));

      // Inverti l'ordine se necessario
      if (reverseOrder) {
        filteredReports = filteredReports.reversed.toList();
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
