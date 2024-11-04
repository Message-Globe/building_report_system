import 'dart:convert';
import '../../authentication/domain/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../authentication/domain/building.dart';
import '../domain/report.dart';
import 'reports_repository.dart';

class HttpReportsRepository implements ReportsRepository {
  final String userToken;

  const HttpReportsRepository({required this.userToken});

  static const String _baseUrl = "https://api.cooperativadoc.it";

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      };

  @override
  Future<List<Report>> fetchReportsList(UserProfile currentUser) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/reports'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        final List<dynamic> data = responseBody['data'];
        return data
            .map((json) => Report.fromJson(json, currentUser.assignedBuildings))
            .toList();
      } else {
        throw Exception('Failed to load reports: success flag is false');
      }
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  Future<Report> addReport({
    required UserProfile currentUser,
    required Building building,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    List<String>? photos,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/reports'));

    request.fields['created_by'] = currentUser.appUser.uid;
    request.fields['structure_id'] = building.id;
    request.fields['site'] = buildingSpot;
    request.fields['priority'] = priority.toString().split('.').last;
    request.fields['subject'] = title;
    request.fields['description'] = description;

    if (photos != null && photos.isNotEmpty) {
      for (var dataUri in photos) {
        final base64Data = dataUri.split(',').last;
        final bytes = base64Decode(base64Data);
        request.files.add(http.MultipartFile.fromBytes(
          'upload_report_pictures[]',
          bytes,
          filename: 'report_picture.png', // Aggiungi un nome di file
          contentType: MediaType('image', 'png'),
        ));
      }
    }

    request.headers['Authorization'] = 'Bearer $userToken';

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final data = json.decode(responseBody)['data'];
      return Report.fromJson(data, currentUser.assignedBuildings);
    } else {
      throw Exception('Failed to create report');
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/reports/$reportId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report');
    }
  }

  @override
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
  }) async {
    // Inizializza una richiesta Multipart
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/reports/$reportId'));

    // Aggiungi i campi solo se non sono null
    if (status != null) request.fields['status'] = status.name;
    if (title != null) request.fields['subject'] = title;
    if (description != null) request.fields['description'] = description;
    if (building != null) request.fields['structure_id'] = building.id;
    if (buildingSpot != null) request.fields['site'] = buildingSpot;
    if (priority != null) request.fields['priority'] = priority.name;
    if (maintenanceDescription != null) {
      request.fields['maintenance_description'] = maintenanceDescription;
    }

    // Gestisci le foto del report
    if (photosUrls != null) {
      if (photosUrls.isEmpty) {
        request.fields['report_pictures[]'] = "";
      } else {
        // TODO: check fix with Luciano
        // request.fields['report_pictures[]'] = jsonEncode(photosUrls);
        for (var url in photosUrls) {
          request.fields['report_pictures[]'] = url;
        }
      }
    }
    if (newPhotos != null && newPhotos.isNotEmpty) {
      for (var dataUri in newPhotos) {
        final base64Data = dataUri.split(',').last;
        final bytes = base64Decode(base64Data);
        request.files.add(http.MultipartFile.fromBytes(
          'upload_report_pictures[]',
          bytes,
          filename: 'report_picture.png', // Aggiungi un nome di file
          contentType: MediaType('image', 'png'),
        ));
      }
    }

    // Gestisci le foto di manutenzione
    if (maintenancePhotoUrls != null) {
      if (maintenancePhotoUrls.isEmpty) {
        request.fields['maintenance_pictures[]'] = "";
      } else {
        // TODO: check fix with Luciano
        // request.fields['maintenance_pictures[]'] = jsonEncode(maintenancePhotoUrls);
        for (var url in maintenancePhotoUrls) {
          request.fields['maintenance_pictures[]'] = url;
        }
      }
    }
    if (newMaintenancePhotos != null) {
      for (var dataUri in newMaintenancePhotos) {
        final base64Data = dataUri.split(',').last;
        final bytes = base64Decode(base64Data);
        request.files.add(http.MultipartFile.fromBytes(
          'upload_maintenance_pictures[]',
          bytes,
          filename: 'maintenance_picture.png', // Aggiungi un nome di file
          contentType: MediaType('image', 'png'),
        ));
      }
    }

    // Aggiungi l’header di autorizzazione
    request.headers['Authorization'] = 'Bearer $userToken';

    // Invia la richiesta
    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseBody)['data'];
      return Report.fromJson(data, currentUser.assignedBuildings);
    } else {
      throw Exception('Failed to update report');
    }
  }

  @override
  Future<void> assignReportToOperator({
    required UserProfile currentUser,
    required String reportId,
  }) async {
    await updateReport(
      currentUser: currentUser,
      reportId: reportId,
      status: ReportStatus.assigned,
    );
  }

  @override
  Future<void> unassignReportFromOperator({
    required UserProfile currentUser,
    required String reportId,
  }) async {
    await updateReport(
      currentUser: currentUser,
      reportId: reportId,
      status: ReportStatus.opened,
    );
  }

  @override
  Future<void> completeReport({
    required UserProfile currentUser,
    required String reportId,
    required String maintenanceDescription,
    List<String>? maintenancePhotosUrls,
  }) async {
    await updateReport(
      currentUser: currentUser,
      reportId: reportId,
      maintenanceDescription: maintenanceDescription,
      maintenancePhotoUrls: maintenancePhotosUrls,
      status: ReportStatus.completed,
    );
  }
}
