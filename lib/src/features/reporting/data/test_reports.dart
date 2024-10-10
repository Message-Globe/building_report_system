import 'package:building_report_system/src/features/reporting/domain/report.dart';

final kTestReports = <Report>[
  Report(
    userId: "1",
    buildingId: "1",
    title: 'Fridge Broken',
    description: "",
    status: ReportStatus.active,
    date: DateTime.parse('2024-10-08'),
  ),
  Report(
    userId: "1",
    buildingId: "2",
    title: 'Light Broken',
    description: "",
    status: ReportStatus.active,
    date: DateTime.parse('2024-10-07'),
  ),
  Report(
    userId: "1",
    buildingId: "3",
    title: 'Door Fixed',
    description: "",
    status: ReportStatus.completed,
    date: DateTime.parse('2024-09-15'),
  ),
  Report(
    userId: "1",
    buildingId: "1",
    title: 'Window Broken',
    description: "",
    status: ReportStatus.deleted,
    date: DateTime.parse('2024-08-01'),
  ),
];
