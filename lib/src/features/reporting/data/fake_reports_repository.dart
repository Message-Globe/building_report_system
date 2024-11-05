// import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';

// import '../../../utils/delay.dart';
// import '../../authentication/domain/building.dart';
// import '../domain/report.dart';
// import 'reports_repository.dart';
// import 'test_reports.dart';

// class FakeReportsRepository implements ReportsRepository {
//   // 1. Variabili finali
//   final bool addDelay;
//   List<Report> _reports = kTestReports;

//   // 2. Costruttore
//   FakeReportsRepository({this.addDelay = true});

//   // 3. Metodi privati
//   String _generateNewReportId() {
//     if (_reports.isEmpty) {
//       return '1';
//     }
//     final highestId =
//         _reports.map((r) => int.tryParse(r.id) ?? 0).reduce((a, b) => a > b ? a : b);
//     return (highestId + 1).toString();
//   }

//   // TODO: give me only my reports
//   // bool _filterByUserRole(Report report, UserProfile userProfile) {
//   //   if (userProfile.role == UserRole.reporter) {
//   //     return report.createdBy == userProfile.appUser.uid;
//   //   } else if (userProfile.role == UserRole.operator) {
//   //     return userProfile.assignedBuildings.containsKey(report.buildingId);
//   //   }
//   //   return true; // Se è un admin, mostra tutti i report
//   // }

//   // 4. Metodi pubblici
//   @override
//   Future<List<Report>> fetchReportsList(UserProfile currentUser) async {
//     await delay(addDelay);
//     return _reports;
//   }

//   @override
//   Future<Report> addReport({
//     required UserProfile currentUser,
//     required Building building,
//     required String buildingSpot,
//     required PriorityLevel priority,
//     required String title,
//     required String description,
//     List<String>? photoUrls,
//   }) async {
//     await delay(addDelay);

//     final newReport = Report(
//       id: _generateNewReportId(),
//       createdBy: currentUser.appUser.uid,
//       assignedTo: '', // Non assegnato inizialmente
//       building: building,
//       buildingSpot: buildingSpot,
//       priority: priority,
//       title: title,
//       description: description,
//       status: ReportStatus.opened,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       photoUrls: photoUrls ?? [],
//       maintenanceDescription: '',
//       maintenancePhotoUrls: [],
//     );

//     _reports = [..._reports, newReport];

//     return newReport;
//   }

//   @override
//   Future<void> updateReport({
//     required String reportId,
//     ReportStatus? status,
//     String? assignedTo,
//     Building? building,
//     String? buildingSpot,
//     PriorityLevel? priority,
//     String? title,
//     String? description,
//     List<String>? photoUrls,
//     String? maintenanceDescription,
//     List<String>? maintenancePhotoUrls,
//   }) async {
//     await delay(addDelay);

//     // Trova l'indice del report con il reportId specificato
//     final index = _reports.indexWhere((r) => r.id == reportId);
//     if (index != -1) {
//       // Crea una nuova lista copiando quella esistente
//       final updatedReports = List<Report>.from(_reports);

//       // Usa il report corrente e aggiorna solo i campi specificati
//       final currentReport = _reports[index];
//       final newReport = currentReport.copyWith(
//         status: status ?? currentReport.status,
//         building: building ?? currentReport.building,
//         buildingSpot: buildingSpot ?? currentReport.buildingSpot,
//         priority: priority ?? currentReport.priority,
//         title: title ?? currentReport.title,
//         description: description ?? currentReport.description,
//         photoUrls: photoUrls ?? currentReport.photoUrls,
//         maintenanceDescription:
//             maintenanceDescription ?? currentReport.maintenanceDescription,
//         maintenancePhotoUrls: maintenancePhotoUrls ?? currentReport.maintenancePhotoUrls,
//         updatedAt: DateTime.now(),
//       );

//       // Sostituisci il report esistente con il nuovo nella lista aggiornata
//       updatedReports[index] = newReport;

//       // Aggiorna la lista dei report
//       _reports = updatedReports;
//     } else {
//       throw Exception('Report not found');
//     }
//   }

//   @override
//   Future<void> deleteReport(String reportId) async {
//     final report = _reports.firstWhere((r) => r.id == reportId);
//     if (report.status != ReportStatus.opened) {
//       throw Exception("Only unassigned reports can be deleted.");
//     }
//     await delay(addDelay);

//     updateReport(
//       reportId: reportId,
//       status: ReportStatus.deleted,
//     );
//   }

//   @override
//   Future<void> completeReport({
//     required String reportId,
//     required String maintenanceDescription,
//     List<String>? maintenancePhotosUrls,
//   }) async {
//     final report = _reports.firstWhere((r) => r.id == reportId);
//     if (report.status != ReportStatus.assigned) {
//       throw Exception("Only assigned reports can be closed.");
//     }
//     if (report.maintenanceDescription.isEmpty && report.maintenancePhotoUrls.isEmpty) {
//       throw Exception("At least maintenance description or photos must be provided.");
//     }
//     updateReport(
//       reportId: reportId,
//       status: ReportStatus.closed,
//       maintenanceDescription: maintenanceDescription,
//       maintenancePhotoUrls: maintenancePhotosUrls,
//     );
//   }

//   @override
//   Future<void> assignReportToOperator(String reportId, [String? operatorId]) async {
//     final report = _reports.firstWhere((r) => r.id == reportId);
//     if (report.status != ReportStatus.opened) {
//       throw Exception("Report is already assigned.");
//     }

//     // throw Exception('test');

//     await updateReport(
//       reportId: reportId,
//       status: ReportStatus.assigned,
//       assignedTo: operatorId,
//     );
//   }

//   @override
//   Future<void> unassignReportFromOperator(String reportId) async {
//     final report = _reports.firstWhere((r) => r.id == reportId);
//     if (report.status != ReportStatus.assigned) {
//       throw Exception("Only assigned reports can be unassigned.");
//     }

//     await updateReport(
//       reportId: reportId,
//       status: ReportStatus.opened,
//       assignedTo: '',
//     );
//   }
// }
