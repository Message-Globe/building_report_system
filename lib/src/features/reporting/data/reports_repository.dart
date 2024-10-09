import 'package:building_report_system/src/features/reporting/domain/report.dart';

class ReportsRepository {
  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
  }) async {
    return Future.value([]);
  }
}
