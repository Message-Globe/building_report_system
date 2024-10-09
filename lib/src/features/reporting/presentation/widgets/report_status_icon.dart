import 'package:flutter/material.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';

class ReportStatusIcon extends StatelessWidget {
  final ReportStatus status;

  const ReportStatusIcon({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ReportStatus.active:
        return const Icon(
          Icons.report,
          color: Colors.red,
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
