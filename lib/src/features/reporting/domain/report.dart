// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ReportStatus {
  open,
  assigned,
  completed,
  deleted,
}

enum PriorityLevel {
  normal,
  urgent,
}

class Report {
  final String userId;
  final String buildingId;
  final String buildingSpot;
  final PriorityLevel priority;
  final String title;
  final String description;
  final ReportStatus status;
  final DateTime timestamp;
  final List<String> photoUrls;
  final String operatorId;
  final String repairDescription;
  final List<String> repairPhotosUrls;

  Report({
    required this.userId,
    required this.buildingId,
    required this.buildingSpot,
    required this.priority,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
    required this.photoUrls,
    required this.operatorId,
    required this.repairDescription,
    required this.repairPhotosUrls,
  });

  Report copyWith({
    String? userId,
    String? buildingId,
    String? buildingSpot,
    PriorityLevel? priority,
    String? title,
    String? description,
    ReportStatus? status,
    DateTime? timestamp,
    List<String>? photoUrls,
    String? operatorId,
    String? repairDescription,
    List<String>? repairPhotosUrls,
  }) {
    return Report(
      userId: userId ?? this.userId,
      buildingId: buildingId ?? this.buildingId,
      buildingSpot: buildingSpot ?? this.buildingSpot,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      photoUrls: photoUrls ?? this.photoUrls,
      operatorId: operatorId ?? this.operatorId,
      repairDescription: repairDescription ?? this.repairDescription,
      repairPhotosUrls: repairPhotosUrls ?? this.repairPhotosUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'buildingId': buildingId,
      'buildingSpot': buildingSpot,
      'priority': priority.name,
      'title': title,
      'description': description,
      'status': status.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'photoUrls': photoUrls,
      'operatorId': operatorId,
      'repairDescription': repairDescription,
      'repairPhotosUrls': repairPhotosUrls,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      userId: map['userId'] as String,
      buildingId: map['buildingId'] as String,
      buildingSpot: map['buildingSpot'] as String,
      priority: PriorityLevel.values.byName(map['priority']),
      title: map['title'] as String,
      description: map['description'] as String,
      status: ReportStatus.values.byName(map['status']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      photoUrls: List<String>.from((map['photoUrls'] as List<String>)),
      operatorId: map['operatorId'] as String,
      repairDescription: map['repairDescription'] as String,
      repairPhotosUrls: List<String>.from((map['repairPhotosUrls'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(userId: $userId, buildingId: $buildingId, buildingSpot: $buildingSpot, priority: $priority, title: $title, description: $description, status: $status, timestamp: $timestamp, photoUrls: $photoUrls, operatorId: $operatorId, repairDescription: $repairDescription, repairPhotosUrls: $repairPhotosUrls)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.buildingId == buildingId &&
        other.buildingSpot == buildingSpot &&
        other.priority == priority &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.timestamp == timestamp &&
        listEquals(other.photoUrls, photoUrls) &&
        other.operatorId == operatorId &&
        other.repairDescription == repairDescription &&
        listEquals(other.repairPhotosUrls, repairPhotosUrls);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        buildingId.hashCode ^
        buildingSpot.hashCode ^
        priority.hashCode ^
        title.hashCode ^
        description.hashCode ^
        status.hashCode ^
        timestamp.hashCode ^
        photoUrls.hashCode ^
        operatorId.hashCode ^
        repairDescription.hashCode ^
        repairPhotosUrls.hashCode;
  }
}
