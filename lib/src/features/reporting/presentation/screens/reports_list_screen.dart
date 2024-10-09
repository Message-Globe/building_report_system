import 'package:building_report_system/src/common_widgets/async_value_widget.dart';
import 'package:building_report_system/src/features/reporting/data/fake_reports_repository.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/filters_controllers.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/filters_button.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/report_status_icon.dart';
import 'package:building_report_system/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsListScreen extends ConsumerWidget {
  final String userType;

  const ReportsListScreen({
    super.key,
    required this.userType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.read(dateFormatterProvider);
    final showCompleted = ref.watch(showCompletedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reportsListValue = ref.watch(
      reportsListFutureProvider(
        showCompleted: showCompleted,
        showDeleted: showDeleted,
        reverseOrder: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
        actions: const [FiltersButton()],
      ),
      body: AsyncValueWidget(
        value: reportsListValue,
        data: (reports) => RefreshIndicator(
          // TODO: check if this onRefresh really works
          onRefresh: () async => ref.refresh(
            reportsListFutureProvider(
              showCompleted: showCompleted,
              showDeleted: showCompleted,
              reverseOrder: false,
            ),
          ),
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    // Navigate to detailed view
                  },
                  child: ListTile(
                    leading: ReportStatusIcon(status: report.status),
                    title: Text(report.title),
                    subtitle: Text('Date: ${dateFormatter.format(report.date)}'),
                    trailing: report.status == ReportStatus.active &&
                            userType == 'Operator'
                        ? const Icon(Icons.check_circle) // Operator can mark as complete
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: userType == 'Reporter'
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to ReportCreateScreen
              },
              child: const Icon(Icons.add),
            )
          : null, // Only Reporter can add new reports
    );
  }
}
