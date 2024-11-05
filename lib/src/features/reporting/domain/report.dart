import '../../../utils/context_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../authentication/domain/building.dart';

enum ReportStatus {
  opened,
  assigned,
  closed,
  deleted,
}

enum PriorityLevel {
  normal,
  urgent,
}

extension PriorityLevelLocalization on PriorityLevel {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case PriorityLevel.normal:
        return context.loc.normal;
      case PriorityLevel.urgent:
        return context.loc.urgent;
    }
  }
}

class Report {
  final String id;
  final String createdBy;
  final String assignedTo;
  final String nameAuditor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReportStatus status;
  final Building building;
  final String buildingSpot;
  final PriorityLevel priority;
  final String title;
  final String description;
  final String maintenanceDescription;
  final List<String> photoUrls;
  final List<String> maintenancePhotoUrls;

  Report({
    required this.id,
    required this.createdBy,
    required this.assignedTo,
    required this.nameAuditor,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.building,
    required this.buildingSpot,
    required this.priority,
    required this.title,
    required this.description,
    required this.maintenanceDescription,
    required this.photoUrls,
    required this.maintenancePhotoUrls,
  });

  /// Metodo `fromJson` personalizzato
  factory Report.fromJson(Map<String, dynamic> json, List<Building> assignedBuildings) {
    // Recupera l'ID della struttura e trova l'oggetto Building corrispondente
    final buildingId = json['structure_id']?.toString() ?? '';
    final building = assignedBuildings.firstWhere(
      (b) => b.id == buildingId,
      orElse: () => Building(id: buildingId, name: 'Unknown'),
    );

    return Report(
      id: json['id'].toString(),
      createdBy: json['created_by']?.toString() ?? '',
      assignedTo: json['assigned_to']?.toString() ?? '',
      nameAuditor: json['name_auditor'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] * 1000),
      status: ReportStatus.values.byName(json['status']),
      building: building,
      buildingSpot: json['site'] ?? '',
      priority: PriorityLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => PriorityLevel.normal,
      ),
      title: json['subject'] ?? '',
      description: json['description'] ?? '',
      maintenanceDescription: json['maintenance_description'] ?? '',
      photoUrls: List<String>.from(json['report_pictures'] ?? []),
      maintenancePhotoUrls: List<String>.from(json['maintenance_pictures'] ?? []),
    );
  }

  Report copyWith({
    String? id,
    String? createdBy,
    String? assignedTo,
    String? nameAuditor,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReportStatus? status,
    Building? building,
    String? buildingSpot,
    PriorityLevel? priority,
    String? title,
    String? description,
    String? maintenanceDescription,
    List<String>? photoUrls,
    List<String>? maintenancePhotoUrls,
  }) {
    return Report(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      nameAuditor: nameAuditor ?? this.nameAuditor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      building: building ?? this.building,
      buildingSpot: buildingSpot ?? this.buildingSpot,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      maintenanceDescription: maintenanceDescription ?? this.maintenanceDescription,
      photoUrls: photoUrls ?? this.photoUrls,
      maintenancePhotoUrls: maintenancePhotoUrls ?? this.maintenancePhotoUrls,
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, createdBy: $createdBy, assignedTo: $assignedTo, nameAuditor: $nameAuditor, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, building: $building, buildingSpot: $buildingSpot, priority: $priority, title: $title, description: $description, maintenanceDescription: $maintenanceDescription, photoUrls: $photoUrls, maintenancePhotoUrls: $maintenancePhotoUrls)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.assignedTo == assignedTo &&
        other.nameAuditor == nameAuditor &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status &&
        other.building == building &&
        other.buildingSpot == buildingSpot &&
        other.priority == priority &&
        other.title == title &&
        other.description == description &&
        other.maintenanceDescription == maintenanceDescription &&
        listEquals(other.photoUrls, photoUrls) &&
        listEquals(other.maintenancePhotoUrls, maintenancePhotoUrls);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        assignedTo.hashCode ^
        nameAuditor.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode ^
        building.hashCode ^
        buildingSpot.hashCode ^
        priority.hashCode ^
        title.hashCode ^
        description.hashCode ^
        maintenanceDescription.hashCode ^
        photoUrls.hashCode ^
        maintenancePhotoUrls.hashCode;
  }
}
