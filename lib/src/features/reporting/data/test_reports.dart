import 'package:building_report_system/src/features/reporting/domain/report.dart';

final kTestReports = <Report>[
  Report(
    userId: "1",
    buildingId: "building1",
    title: 'Fridge Broken',
    description: "",
    status: ReportStatus.open,
    date: DateTime.parse('2024-10-08'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
  ),
  Report(
    userId: "1",
    buildingId: "building2",
    title: 'Light Broken',
    description: "",
    status: ReportStatus.open,
    date: DateTime.parse('2024-10-07'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
  ),
  Report(
    userId: "1",
    buildingId: "building3",
    title: 'Door Fixed',
    description: "",
    status: ReportStatus.worked,
    date: DateTime.parse('2024-09-15'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
  ),
  Report(
    userId: "1",
    buildingId: "building1",
    title: 'Window Broken',
    description: "",
    status: ReportStatus.deleted,
    date: DateTime.parse('2024-08-01'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
  ),
];
