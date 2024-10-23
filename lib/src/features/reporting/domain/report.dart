// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ReportStatus {
  opened,
  assigned,
  completed,
  deleted,
}

enum PriorityLevel {
  normal,
  urgent,
}

class Report {
  final String id;
  final String createdBy;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReportStatus status;
  final String buildingId;
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
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.buildingId,
    required this.buildingSpot,
    required this.priority,
    required this.title,
    required this.description,
    required this.maintenanceDescription,
    required this.photoUrls,
    required this.maintenancePhotoUrls,
  });

  Report copyWith({
    String? id,
    String? createdBy,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReportStatus? status,
    String? buildingId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      buildingId: buildingId ?? this.buildingId,
      buildingSpot: buildingSpot ?? this.buildingSpot,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      maintenanceDescription: maintenanceDescription ?? this.maintenanceDescription,
      photoUrls: photoUrls ?? this.photoUrls,
      maintenancePhotoUrls: maintenancePhotoUrls ?? this.maintenancePhotoUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status.name,
      'buildingId': buildingId,
      'buildingSpot': buildingSpot,
      'priority': priority.name,
      'title': title,
      'description': description,
      'maintenanceDescription': maintenanceDescription,
      'photoUrls': photoUrls,
      'maintenancePhotoUrls': maintenancePhotoUrls,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      assignedTo: map['assignedTo'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      status: ReportStatus.values.byName(map['status']),
      buildingId: map['buildingId'] as String,
      buildingSpot: map['buildingSpot'] as String,
      priority: PriorityLevel.values.byName(map['priority']),
      title: map['title'] as String,
      description: map['description'] as String,
      maintenanceDescription: map['maintenanceDescription'] as String,
      photoUrls: List<String>.from((map['photoUrls'] as List<String>)),
      maintenancePhotoUrls:
          List<String>.from((map['maintenancePhotoUrls'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(id: $id, createdBy: $createdBy, assignedTo: $assignedTo, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, buildingId: $buildingId, buildingSpot: $buildingSpot, priority: $priority, title: $title, description: $description, maintenanceDescription: $maintenanceDescription, photoUrls: $photoUrls, maintenancePhotoUrls: $maintenancePhotoUrls)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.assignedTo == assignedTo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status &&
        other.buildingId == buildingId &&
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
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode ^
        buildingId.hashCode ^
        buildingSpot.hashCode ^
        priority.hashCode ^
        title.hashCode ^
        description.hashCode ^
        maintenanceDescription.hashCode ^
        photoUrls.hashCode ^
        maintenancePhotoUrls.hashCode;
  }
}
