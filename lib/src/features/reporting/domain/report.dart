// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum ReportStatus {
  active,
  completed,
  deleted,
}

class Report {
  final String title;
  final String description;
  final ReportStatus status;
  final DateTime date;

  Report({
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });

  Report copyWith({
    String? title,
    String? description,
    ReportStatus? status,
    DateTime? date,
  }) {
    return Report(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'status': status.name,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      title: map['title'] as String,
      description: map['description'] as String,
      status: ReportStatus.values.byName((map['status'])),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(title: $title, description: $description, status: $status, date: $date)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.status == status &&
        other.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^ description.hashCode ^ status.hashCode ^ date.hashCode;
  }
}
