// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ReportStatus {
  open,
  assigned,
  completed,
  deleted,
}

class Report {
  final String userId;
  final String buildingId;
  final String title;
  final String description;
  final ReportStatus status;
  final DateTime date;
  final List<String> photoUrls;
  final String operatorId;
  final String repairDescription;
  final List<String> repairPhotosUrls;

  Report({
    required this.userId,
    required this.buildingId,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.photoUrls,
    required this.operatorId,
    required this.repairDescription,
    required this.repairPhotosUrls,
  });

  Report copyWith({
    String? userId,
    String? buildingId,
    String? title,
    String? description,
    ReportStatus? status,
    DateTime? date,
    List<String>? photoUrls,
    String? operatorId,
    String? repairDescription,
    List<String>? repairPhotosUrls,
  }) {
    return Report(
      userId: userId ?? this.userId,
      buildingId: buildingId ?? this.buildingId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
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
      'title': title,
      'description': description,
      'status': status.name,
      'date': date.millisecondsSinceEpoch,
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
      title: map['title'] as String,
      description: map['description'] as String,
      status: ReportStatus.values.byName(map['status']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
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
    return 'Report(userId: $userId, buildingId: $buildingId, title: $title, description: $description, status: $status, date: $date, photoUrls: $photoUrls, operatorId: $operatorId, repairDescription: $repairDescription, repairPhotosUrls: $repairPhotosUrls)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.buildingId == buildingId &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.date == date &&
        listEquals(other.photoUrls, photoUrls) &&
        other.operatorId == operatorId &&
        other.repairDescription == repairDescription &&
        listEquals(other.repairPhotosUrls, repairPhotosUrls);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        buildingId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        status.hashCode ^
        date.hashCode ^
        photoUrls.hashCode ^
        operatorId.hashCode ^
        repairDescription.hashCode ^
        repairPhotosUrls.hashCode;
  }
}
