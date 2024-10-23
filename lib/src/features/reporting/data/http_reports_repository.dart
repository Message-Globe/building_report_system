// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../authentication/domain/user_profile.dart';
// import '../domain/report.dart';
// import 'reports_repository.dart';

// class HttpReportsRepository implements ReportsRepository {
//   // 1. Costanti
//   static const String _baseUrl = "https://api.cooperativadoc.it";
//   String? _token;

//   // 2. StreamController per simulare lo stream locale
//   final _reportsStreamController = StreamController<List<Report>>.broadcast();
//   List<Report> _reportsCache = [];

//   // 3. Getter per lo stream
//   @override
//   Stream<List<Report>> get reportsStream => _reportsStreamController.stream;

//   // 4. Metodi per gestire i report

//   @override
//   Future<List<Report>> fetchReportsList({
//     required bool showCompleted,
//     required bool showDeleted,
//     required bool reverseOrder,
//     required UserProfile userProfile,
//     String? buildingId,
//   }) async {
//     final url = Uri.parse("$_baseUrl/api/reports");
//     final response = await http.get(
//       url,
//       headers: {'Authorization': 'Bearer $_token'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body)['data'];
//       _reportsCache = _parseReportsFromJson(data);

//       _reportsStreamController.add(_filterReports(
//         userProfile: userProfile,
//         showCompleted: showCompleted,
//         showDeleted: showDeleted,
//         reverseOrder: reverseOrder,
//         buildingId: buildingId,
//       ));

//       return _reportsCache;
//     } else {
//       throw Exception("Failed to fetch reports: ${response.body}");
//     }
//   }

//   @override
//   Stream<List<Report>> watchReportsList({
//     required bool showCompleted,
//     required bool showDeleted,
//     required bool reverseOrder,
//     required UserProfile userProfile,
//     String? buildingId,
//   }) {
//     // Filtra i report ogni volta che cambia qualcosa
//     _reportsStreamController.add(_filterReports(
//       userProfile: userProfile,
//       showCompleted: showCompleted,
//       showDeleted: showDeleted,
//       reverseOrder: reverseOrder,
//       buildingId: buildingId,
//     ));

//     return reportsStream;
//   }

//   @override
//   Future<Report> addReport({
//     required String createdBy,
//     required String buildingId,
//     required String buildingSpot,
//     required PriorityLevel priority,
//     required String title,
//     required String description,
//     required List<String>? photoUrls,
//   }) async {
//     final url = Uri.parse("$_baseUrl/api/reports");
//     final response = await http.post(
//       url,
//       headers: {'Authorization': 'Bearer $_token'},
//       body: {
//         "user_id": createdBy,
//         "building_id": buildingId,
//         "building_spot": buildingSpot,
//         "priority": priority.toString(),
//         "title": title,
//         "description": description,
//         "photos": photoUrls ?? [],
//       },
//     );

//     if (response.statusCode == 201) {
//       final data = json.decode(response.body)['data'];

//       final newReport = Report(
//         id: data['id'], // Usa l'ID generato dal backend
//         createdBy: createdBy,
//         assignedTo: '', // Inizialmente vuoto
//         createdAt: DateTime.parse(data['created_at']),
//         updatedAt: DateTime.parse(data['updated_at']),
//         status: ReportStatus.opened,
//         buildingId: buildingId,
//         buildingSpot: buildingSpot,
//         priority: priority,
//         title: title,
//         description: description,
//         maintenanceDescription: '',
//         photoUrls: photoUrls ?? [],
//         maintenancePhotoUrls: [],
//       );

//       _reportsCache.add(newReport);
//       _reportsStreamController.add(_reportsCache);
//     } else {
//       throw Exception("Failed to add report: ${response.body}");
//     }
//   }

//   @override
//   Future<void> updateReport({
//     required Report report,
//     String? buildingId,
//     String? buildingSpot,
//     PriorityLevel? priority,
//     String? title,
//     String? description,
//     ReportStatus? status,
//     List<String>? photoUrls,
//     String? assignedTo,
//     String? maintenanceDescription,
//     List<String>? maintenancePhotoUrls,
//   }) async {
//     final url = Uri.parse("$_baseUrl/api/reports/${report.id}");
//     final response = await http.post(
//       url,
//       headers: {'Authorization': 'Bearer $_token'},
//       body: {
//         "building_id": buildingId ?? report.buildingId,
//         "building_spot": buildingSpot ?? report.buildingSpot,
//         "priority": priority?.toString() ?? report.priority.toString(),
//         "title": title ?? report.title,
//         "description": description ?? report.description,
//         "status": status?.toString() ?? report.status.toString(),
//         "photos": photoUrls ?? report.photoUrls,
//         "assigned_to": assignedTo ?? report.assignedTo,
//         "maintenance_description":
//             maintenanceDescription ?? report.maintenanceDescription,
//         "maintenance_photos": maintenancePhotoUrls ?? report.maintenancePhotoUrls,
//       },
//     );

//     if (response.statusCode == 200) {
//       final index = _reportsCache.indexOf(report);
//       if (index != -1) {
//         _reportsCache[index] = report.copyWith(
//           buildingId: buildingId,
//           buildingSpot: buildingSpot,
//           priority: priority,
//           title: title,
//           description: description,
//           status: status,
//           photoUrls: photoUrls,
//           assignedTo: assignedTo,
//           maintenanceDescription: maintenanceDescription,
//           maintenancePhotoUrls: maintenancePhotoUrls,
//         );
//         _reportsStreamController.add(_reportsCache);
//       }
//     } else {
//       throw Exception("Failed to update report: ${response.body}");
//     }
//   }

//   @override
//   Future<void> deleteReport(Report report) async {
//     final url = Uri.parse("$_baseUrl/api/reports/${report.id}");
//     final response = await http.delete(
//       url,
//       headers: {'Authorization': 'Bearer $_token'},
//     );

//     if (response.statusCode == 200) {
//       _reportsCache.remove(report);
//       _reportsStreamController.add(_reportsCache);
//     } else {
//       throw Exception("Failed to delete report: ${response.body}");
//     }
//   }

//   @override
//   Future<void> completeReport(Report report) async {
//     if (report.status != ReportStatus.assigned) {
//       throw Exception("Only assigned reports can be completed.");
//     }

//     if (report.maintenanceDescription.isEmpty && report.maintenancePhotoUrls.isEmpty) {
//       throw Exception("At least repair description or photos must be provided.");
//     }

//     await updateReport(
//       report: report,
//       status: ReportStatus.completed,
//     );
//   }

//   @override
//   Future<void> assignReportToOperator({
//     required Report report,
//     required String operatorId,
//   }) async {
//     if (report.status != ReportStatus.opened) {
//       throw Exception("Report is already assigned.");
//     }

//     await updateReport(
//       report: report,
//       status: ReportStatus.assigned,
//       assignedTo: operatorId,
//     );
//   }

//   @override
//   Future<void> unassignReportFromOperator(Report report) async {
//     if (report.status != ReportStatus.assigned) {
//       throw Exception("Only assigned reports can be unassigned.");
//     }

//     await updateReport(
//       report: report,
//       status: ReportStatus.opened,
//       assignedTo: '',
//     );
//   }

//   // Metodi privati per parsing e filtraggio

//   List<Report> _parseReportsFromJson(List<dynamic> data) {
//     return data.map((json) => Report.fromJson(json)).toList();
//   }

//   List<Report> _filterReports({
//     required UserProfile userProfile,
//     required bool showCompleted,
//     required bool showDeleted,
//     required bool reverseOrder,
//     String? buildingId,
//   }) {
//     List<Report> filteredReports = _reportsCache.where((report) {
//       final byUserRole = _filterByUserRole(report, userProfile);
//       final byBuilding = _filterByBuilding(report, buildingId);
//       final byStatus = _filterByStatus(report, showCompleted, showDeleted);
//       return byUserRole && byBuilding && byStatus;
//     }).toList();

//     filteredReports.sort((a, b) => a.createdAt.compareTo(b.createdAt));

//     if (reverseOrder) {
//       filteredReports = filteredReports.reversed.toList();
//     }

//     return filteredReports;
//   }

//   bool _filterByUserRole(Report report, UserProfile userProfile) {
//     if (userProfile.role == UserRole.reporter) {
//       return report.createdBy == userProfile.appUser.uid;
//     } else if (userProfile.role == UserRole.operator) {
//       // Controlla se l'ID dell'edificio è presente nella mappa `assignedBuildings`
//       return userProfile.assignedBuildings.containsKey(report.buildingId);
//     }
//     // Se è un admin, mostra tutti i report
//     return true;
//   }

//   bool _filterByBuilding(Report report, String? buildingId) {
//     if (buildingId != null) {
//       return report.buildingId == buildingId;
//     }
//     return true;
//   }

//   bool _filterByStatus(Report report, bool showCompleted, bool showDeleted) {
//     if (report.status == ReportStatus.opened || report.status == ReportStatus.assigned) {
//       return true;
//     } else if (report.status == ReportStatus.completed) {
//       return showCompleted;
//     } else if (report.status == ReportStatus.deleted) {
//       return showDeleted;
//     }
//     return false;
//   }
// }
