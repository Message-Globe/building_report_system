// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/context_extensions.dart';
import '../../authentication/domain/building.dart';

enum ReportStatus {
  opened,
  assigned,
  closed,
  deleted,
}

enum PriorityLevel {
  low,
  medium,
  high,
  urgent,
  critical,
}

extension PriorityLevelLocalization on PriorityLevel {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case PriorityLevel.low:
        return context.loc.low;
      case PriorityLevel.medium:
        return context.loc.medium;
      case PriorityLevel.high:
        return context.loc.high;
      case PriorityLevel.urgent:
        return context.loc.urgent;
      case PriorityLevel.critical:
        return context.loc.critical;
    }
  }
}

class Report {
  final String id;
  final String createdBy;
  final String createdByName;
  final String category;
  final String assignedTo;
  final String nameAuditor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReportStatus status;
  final Building building;
  final String buildingSpotId;
  final String buildingSpot;
  final PriorityLevel priority;
  final bool escalatedToAdmin;
  final bool areaNotAvailable;
  final String description;
  final String resolveBy;
  final String maintenanceDescription;
  final List<String> photoUrls;
  final List<String> maintenancePhotoUrls;

  Report({
    required this.id,
    required this.createdBy,
    required this.createdByName,
    required this.category,
    required this.assignedTo,
    required this.nameAuditor,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.building,
    required this.buildingSpotId,
    required this.buildingSpot,
    required this.priority,
    required this.escalatedToAdmin,
    required this.areaNotAvailable,
    required this.description,
    required this.resolveBy,
    required this.maintenanceDescription,
    required this.photoUrls,
    required this.maintenancePhotoUrls,
  });

  /// Metodo `fromJson` aggiornato
  factory Report.fromJson(Map<String, dynamic> json, List<Building> assignedBuildings) {
    final buildingId = json['structure_id']?.toString() ?? '';
    final building = assignedBuildings.firstWhere(
      (b) => b.id == buildingId,
      orElse: () => Building(id: buildingId, name: 'Unknown'),
    );

    return Report(
      id: json['id'].toString(),
      createdBy: json['created_by']?.toString() ?? '',
      createdByName: json['name_creator'].toString(),
      category: json['category_name'] ?? '',
      assignedTo: json['assigned_to']?.toString() ?? '',
      nameAuditor: json['name_auditor'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] * 1000),
      status: ReportStatus.values.byName(json['status']),
      building: building,
      buildingSpotId: json['structure_area_id'].toString(),
      buildingSpot: json['site'] ?? '',
      priority: PriorityLevel.values[(int.tryParse(json['priority']?.toString() ?? '1')
                  ?.clamp(1, PriorityLevel.values.length) ??
              1) -
          1],
      escalatedToAdmin: json['escalated_to_admin'] ?? false,
      areaNotAvailable: json['area_not_available'] ?? false,
      description: json['description'] ?? '',
      resolveBy: json['resolve_by'] ?? '',
      maintenanceDescription: json['maintenance_description'] ?? '',
      photoUrls: List<String>.from(json['report_pictures'] ?? []),
      maintenancePhotoUrls: List<String>.from(json['maintenance_pictures'] ?? []),
    );
  }

  Report copyWith({
    String? id,
    String? createdBy,
    String? createdByName,
    String? category,
    String? assignedTo,
    String? nameAuditor,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReportStatus? status,
    Building? building,
    String? buildingSpotId,
    String? buildingSpot,
    PriorityLevel? priority,
    bool? escalatedToAdmin,
    bool? areaNotAvailable,
    String? description,
    String? resolveBy,
    String? maintenanceDescription,
    List<String>? photoUrls,
    List<String>? maintenancePhotoUrls,
  }) {
    return Report(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      category: category ?? this.category,
      assignedTo: assignedTo ?? this.assignedTo,
      nameAuditor: nameAuditor ?? this.nameAuditor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      building: building ?? this.building,
      buildingSpotId: buildingSpotId ?? this.buildingSpotId,
      buildingSpot: buildingSpot ?? this.buildingSpot,
      priority: priority ?? this.priority,
      escalatedToAdmin: escalatedToAdmin ?? this.escalatedToAdmin,
      areaNotAvailable: areaNotAvailable ?? this.areaNotAvailable,
      description: description ?? this.description,
      resolveBy: resolveBy ?? this.resolveBy,
      maintenanceDescription: maintenanceDescription ?? this.maintenanceDescription,
      photoUrls: photoUrls ?? this.photoUrls,
      maintenancePhotoUrls: maintenancePhotoUrls ?? this.maintenancePhotoUrls,
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, createdBy: $createdBy, createdByName: $createdByName, category: $category, assignedTo: $assignedTo, nameAuditor: $nameAuditor, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, building: $building, buildingSpotId: $buildingSpotId, buildingSpot: $buildingSpot, priority: $priority, escalatedToAdmin: $escalatedToAdmin, areaNotAvailable: $areaNotAvailable, description: $description, resolveBy: $resolveBy, maintenanceDescription: $maintenanceDescription, photoUrls: $photoUrls, maintenancePhotoUrls: $maintenancePhotoUrls)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.createdByName == createdByName &&
        other.category == category &&
        other.assignedTo == assignedTo &&
        other.nameAuditor == nameAuditor &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status &&
        other.building == building &&
        other.buildingSpotId == buildingSpotId &&
        other.buildingSpot == buildingSpot &&
        other.priority == priority &&
        other.escalatedToAdmin == escalatedToAdmin &&
        other.areaNotAvailable == areaNotAvailable &&
        other.description == description &&
        other.resolveBy == resolveBy &&
        other.maintenanceDescription == maintenanceDescription &&
        listEquals(other.photoUrls, photoUrls) &&
        listEquals(other.maintenancePhotoUrls, maintenancePhotoUrls);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        createdByName.hashCode ^
        category.hashCode ^
        assignedTo.hashCode ^
        nameAuditor.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode ^
        building.hashCode ^
        buildingSpotId.hashCode ^
        buildingSpot.hashCode ^
        priority.hashCode ^
        escalatedToAdmin.hashCode ^
        areaNotAvailable.hashCode ^
        description.hashCode ^
        resolveBy.hashCode ^
        maintenanceDescription.hashCode ^
        photoUrls.hashCode ^
        maintenancePhotoUrls.hashCode;
  }
}
