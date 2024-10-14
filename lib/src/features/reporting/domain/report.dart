// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ReportStatus {
  open,
  worked,
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

  Report({
    required this.userId,
    required this.buildingId,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.photoUrls,
  });

  Report copyWith({
    String? userId,
    String? buildingId,
    String? title,
    String? description,
    ReportStatus? status,
    DateTime? date,
    List<String>? photoUrls,
  }) {
    return Report(
      userId: userId ?? this.userId,
      buildingId: buildingId ?? this.buildingId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
      photoUrls: photoUrls ?? this.photoUrls,
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
      photoUrls: List<String>.from(
        (map['photoUrls'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(userId: $userId, buildingId: $buildingId, title: $title, description: $description, status: $status, date: $date, photoUrls: $photoUrls)';
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
        listEquals(other.photoUrls, photoUrls);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        buildingId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        status.hashCode ^
        date.hashCode ^
        photoUrls.hashCode;
  }
}
