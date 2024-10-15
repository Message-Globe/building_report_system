import 'package:flutter/material.dart';
import '../../domain/report.dart';

class ReportStatusIcon extends StatelessWidget {
  final ReportStatus status;

  const ReportStatusIcon({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ReportStatus.open:
        return const Icon(
          Icons.report,
          color: Colors.red,
        );
      case ReportStatus.assigned:
        return const Icon(
          Icons.handyman,
          color: Colors.amber,
        );
      case ReportStatus.completed:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case ReportStatus.deleted:
        return const Icon(
          Icons.delete,
          color: Colors.grey,
        );
    }
  }
}