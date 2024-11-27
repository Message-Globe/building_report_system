import 'dart:convert';

import '../../../l10n/string_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../authentication/domain/building.dart';
import '../../authentication/domain/user_profile.dart';
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
  Future<List<Map<String, String>>> fetchBuildingAreas({
    required String buildingId,
    required int page,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/areas/$buildingId?page=$page'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        if (responseBody['data']['data'] is List) {
          return [];
        }

        final data = Map<String, dynamic>.from(responseBody['data']['data']);
        return data.entries
            .map((entry) => {'id': entry.key, 'name': entry.value.toString()})
            .toList();
      } else {
        throw Exception('Failed to load building areas'.hardcoded);
      }
    } else {
      throw Exception('Failed to load building areas'.hardcoded);
    }
  }

  @override
  Future<List<String>> fetchReportCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/reports/categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(responseBody['data']);

        return data.values.map((value) => value.toString()).toList();
      } else {
        throw Exception('Failed to load report categories: success flag is false');
      }
    } else {
      throw Exception('Failed to load report categories');
    }
  }

  @override
  Future<List<Map<String, String>>> fetchMaintenanceTeams(String reportId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/maintenance/teams/$reportId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        final data = Map<String, dynamic>.from(responseBody['data']);
        return data.entries
            .map((entry) => {'id': entry.key, 'name': entry.value.toString()})
            .toList();
      } else {
        throw Exception('Failed to fetch maintenance teams: success flag is false');
      }
    } else {
      throw Exception('Failed to fetch maintenance teams');
    }
  }

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
        throw Exception('Failed to load reports: success flag is false'.hardcoded);
      }
    } else {
      throw Exception('Failed to load reports'.hardcoded);
    }
  }

  @override
  Future<Report> fetchReport({
    required UserProfile currentUser,
    required String reportId,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/reports/$reportId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        final data = responseBody['data'];

        return Report.fromJson(data, currentUser.assignedBuildings);
      } else {
        throw Exception('Failed to load reports: success flag is false'.hardcoded);
      }
    } else {
      throw Exception('Failed to load reports'.hardcoded);
    }
  }

  @override
  Future<Report> addReport({
    required String category,
    required UserProfile currentUser,
    required Building building,
    required String buildingAreaId,
    required PriorityLevel priority,
    required String description,
    List<String>? photos,
    String? resolveBy,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/reports'));

    request.fields['category_name'] = category;
    request.fields['created_by'] = currentUser.appUser.uid;
    request.fields['structure_id'] = building.id;
    request.fields['structure_area_id'] = buildingAreaId;
    request.fields['priority'] = (priority.index + 1).toString();
    request.fields['description'] = description;
    if (resolveBy != null) request.fields['resolve_by'] = resolveBy;

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
      throw Exception('Failed to create report'.hardcoded);
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/reports/$reportId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report'.hardcoded);
    }
  }

  @override
  Future<Report> updateReport({
    required UserProfile currentUser,
    required String reportId,
    String? operatorId,
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
  }) async {
    // Inizializza una richiesta Multipart
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/reports/$reportId'));

    // Aggiungi i campi solo se non sono null
    if (operatorId != null) request.fields['assigned_to'] = operatorId;
    if (status != null) request.fields['status'] = status.name;
    if (category != null) request.fields['category_name'] = category;
    if (title != null) request.fields['subject'] = title;
    if (description != null) request.fields['description'] = description;
    if (resolveBy != null) request.fields['resolve_by'] = resolveBy;
    if (building != null) request.fields['structure_id'] = building.id;
    if (buildingAreaId != null) request.fields['structure_area_id'] = buildingAreaId;
    if (priority != null) request.fields['priority'] = (priority.index + 1).toString();
    if (escalatedToAdmin != null) {
      request.fields['escalated_to_admin'] = escalatedToAdmin ? '1' : '0';
    }
    if (areaNotAvailable != null) {
      request.fields['area_not_available'] = areaNotAvailable ? '1' : '0';
    }
    if (maintenanceDescription != null) {
      request.fields['maintenance_description'] = maintenanceDescription;
    }

    // Gestisci le foto del report
    if (photosUrls != null) {
      request.fields['report_pictures'] = jsonEncode(photosUrls);
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
      request.fields['maintenance_pictures'] = jsonEncode(maintenancePhotoUrls);
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
      throw Exception('Failed to update report'.hardcoded);
    }
  }

  @override
  Future<void> assignReportToUser({
    required String reportId,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/reports/$reportId/assign-to'),
      headers: _headers,
      body: jsonEncode({
        'assign_user': userId,
      }),
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw Exception(
        'Failed to assign report: ${responseBody['message'] ?? 'Unknown error'}'
            .hardcoded,
      );
    }
  }

  @override
  Future<Report> assignReportToOperator({
    required UserProfile currentUser,
    required String reportId,
    required String operatorId,
    required String maintenanceDescription,
  }) async {
    return await updateReport(
      currentUser: currentUser,
      reportId: reportId,
      operatorId: operatorId,
      status: ReportStatus.assigned,
      maintenanceDescription: maintenanceDescription,
    );
  }

  @override
  Future<Report> unassignReportFromOperator({
    required UserProfile currentUser,
    required String reportId,
    required String maintenanceDescription,
  }) async {
    return await updateReport(
      currentUser: currentUser,
      reportId: reportId,
      status: ReportStatus.opened,
      maintenanceDescription: maintenanceDescription,
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
      status: ReportStatus.closed,
    );
  }
}
