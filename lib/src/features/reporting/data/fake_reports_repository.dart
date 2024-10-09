import 'package:building_report_system/src/features/reporting/data/reports_repository.dart';
import 'package:building_report_system/src/features/reporting/data/test_reports.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_reports_repository.g.dart';

class FakeReportsRepository implements ReportsRepository {
  final bool addDelay;

  FakeReportsRepository({this.addDelay = true});

  final _reports = kTestReports;

  @override
  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
  }) async {
    // Simulate delay if needed
    if (addDelay) {
      await Future.delayed(const Duration(seconds: 1));
    }
    // Filter the reports based on their status
    List<Report> filteredReports = _reports.where((report) {
      if (report.status == ReportStatus.active) {
        return true; // Always show active reports
      } else if (report.status == ReportStatus.completed && showCompleted) {
        return true; // Show completed reports if filter is enabled
      } else if (report.status == ReportStatus.deleted && showDeleted) {
        return true; // Show deleted reports if filter is enabled
      }
      return false; // Hide reports that don't match the filter
    }).toList();
    // Sort the reports by date (most recent first by default)
    filteredReports.sort((a, b) => a.date.compareTo(b.date));
    // If reverseOrder is true, reverse the list
    if (reverseOrder) {
      filteredReports = filteredReports.reversed.toList();
    }
    return filteredReports;
  }
}

@riverpod
FakeReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return FakeReportsRepository();
}

@riverpod
Future<List<Report>> reportsListFuture(
  ReportsListFutureRef ref, {
  bool showCompleted = false,
  bool showDeleted = false,
  bool reverseOrder = false,
}) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  return reportsRepository.fetchReportsList(
    showCompleted: showCompleted,
    showDeleted: showDeleted,
    reverseOrder: reverseOrder,
  );
}
