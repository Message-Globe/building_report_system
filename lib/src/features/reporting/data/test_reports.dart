import 'package:building_report_system/src/features/reporting/domain/report.dart';

final kTestReports = [
  Report(
    title: 'Fridge Broken',
    description: "",
    status: ReportStatus.active,
    date: DateTime.parse('2024-10-08'),
  ),
  Report(
    title: 'Light Broken',
    description: "",
    status: ReportStatus.active,
    date: DateTime.parse('2024-10-07'),
  ),
  Report(
    title: 'Door Fixed',
    description: "",
    status: ReportStatus.completed,
    date: DateTime.parse('2024-09-15'),
  ),
  Report(
    title: 'Window Broken',
    description: "",
    status: ReportStatus.deleted,
    date: DateTime.parse('2024-08-01'),
  ),
];
