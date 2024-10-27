import '../../../utils/delay.dart';
import '../../authentication/domain/building.dart';
import '../domain/report.dart';
import 'reports_repository.dart';
import 'test_reports.dart';

class FakeReportsRepository implements ReportsRepository {
  // 1. Variabili finali
  final bool addDelay;
  List<Report> _reports = kTestReports;

  // 2. Costruttore
  FakeReportsRepository({this.addDelay = true});

  // 3. Metodi privati
  String _generateNewReportId() {
    if (_reports.isEmpty) {
      return '1';
    }
    final highestId =
        _reports.map((r) => int.tryParse(r.id) ?? 0).reduce((a, b) => a > b ? a : b);
    return (highestId + 1).toString();
  }

  // TODO: give me only my reports
  // bool _filterByUserRole(Report report, UserProfile userProfile) {
  //   if (userProfile.role == UserRole.reporter) {
  //     return report.createdBy == userProfile.appUser.uid;
  //   } else if (userProfile.role == UserRole.operator) {
  //     return userProfile.assignedBuildings.containsKey(report.buildingId);
  //   }
  //   return true; // Se è un admin, mostra tutti i report
  // }

  // 4. Metodi pubblici
  @override
  Future<List<Report>> fetchReportsList() async {
    await delay(addDelay);
    return _reports;
  }

  @override
  Future<Report> addReport({
    required String createdBy,
    required Building building,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    required List<String>? photoUrls,
  }) async {
    await delay(addDelay);

    final newReport = Report(
      id: _generateNewReportId(),
      createdBy: createdBy,
      assignedTo: '', // Non assegnato inizialmente
      building: building,
      buildingSpot: buildingSpot,
      priority: priority,
      title: title,
      description: description,
      status: ReportStatus.opened,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      photoUrls: photoUrls ?? [],
      maintenanceDescription: '',
      maintenancePhotoUrls: [],
    );

    _reports = [..._reports, newReport];

    return newReport;
  }

  @override
  Future<void> updateReport({
    required Report report,
    Building? building,
    String? buildingSpot,
    PriorityLevel? priority,
    String? title,
    String? description,
    ReportStatus? status,
    List<String>? photoUrls,
    String? assignedTo,
    String? maintenanceDescription,
    List<String>? maintenancePhotoUrls,
  }) async {
    await delay(addDelay);

    final index = _reports.indexOf(report);
    if (index != -1) {
      final updatedReports = List<Report>.from(_reports);
      final newReport = report.copyWith(
        building: building,
        buildingSpot: buildingSpot,
        priority: priority,
        title: title,
        description: description,
        status: status,
        photoUrls: photoUrls,
        assignedTo: assignedTo,
        maintenanceDescription: maintenanceDescription,
        maintenancePhotoUrls: maintenancePhotoUrls,
        updatedAt: DateTime.now(),
      );
      updatedReports[index] = newReport;

      _reports = updatedReports;
    }
  }

  @override
  Future<void> deleteReport(Report report) async {
    if (report.status != ReportStatus.opened) {
      throw Exception("Only unassigned reports can be deleted.");
    }
    await delay(addDelay);

    updateReport(
      report: report,
      status: ReportStatus.deleted,
    );
  }

  @override
  Future<void> completeReport(Report report) async {
    if (report.status != ReportStatus.assigned) {
      throw Exception("Only assigned reports can be completed.");
    }
    if (report.maintenanceDescription.isEmpty && report.maintenancePhotoUrls.isEmpty) {
      throw Exception("At least maintenance description or photos must be provided.");
    }
    updateReport(
      report: report,
      status: ReportStatus.completed,
    );
  }

  @override
  Future<void> assignReportToOperator({
    required Report report,
    required String operatorId,
  }) async {
    if (report.status != ReportStatus.opened) {
      throw Exception("Report is already assigned.");
    }

    // throw Exception('test');

    await updateReport(
      report: report,
      status: ReportStatus.assigned,
      assignedTo: operatorId,
    );
  }

  @override
  Future<void> unassignReportFromOperator(Report report) async {
    if (report.status != ReportStatus.assigned) {
      throw Exception("Only assigned reports can be unassigned.");
    }

    await updateReport(
      report: report,
      status: ReportStatus.opened,
      assignedTo: '',
    );
  }
}
