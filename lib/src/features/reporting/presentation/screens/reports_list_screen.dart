import 'package:building_report_system/src/features/reporting/presentation/controllers/reports_list_screen_controller.dart';
import 'package:building_report_system/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/async_value_widget.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/date_formatter.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import '../widgets/app_drawer.dart';
import '../widgets/filters_button.dart';
import '../widgets/report_status_icon.dart';
import '../widgets/reverse_order_button.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  Future<bool> _confirmDeleteReport(
    BuildContext context,
    WidgetRef ref,
    Report report,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await ref.read(reportsRepositoryProvider).deleteReport(report);
      return true;
    }
    return false;
  }

  Future<bool> _confirmActivate(
    BuildContext context,
    WidgetRef ref,
    Report report,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Activation'),
          content: const Text('Are you sure you want to activate this report?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Activate'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // TODO: add report activation method
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider);
    final reportsListValue = ref.watch(reportsListScreenControllerProvider);

    ref.listen(
      reportsListScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
        actions: const <Widget>[
          ReverseOrderButton(),
          FiltersButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: AsyncValueWidget(
        value: reportsListValue,
        data: (reports) => RefreshIndicator(
          onRefresh: () async => await ref
              .read(reportsListScreenControllerProvider.notifier)
              .refreshReports(),
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Dismissible(
                key: ValueKey(report),
                direction:
                    (userRole == UserRole.reporter || userRole == UserRole.operator) &&
                            report.status == ReportStatus.open
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                background: Container(
                  color: userRole == UserRole.reporter ? Colors.red : Colors.amber,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                  child: Icon(
                    userRole == UserRole.reporter ? Icons.delete : Icons.handyman,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) {
                  if (userRole == UserRole.reporter) {
                    return _confirmDeleteReport(context, ref, report);
                  } else {
                    return _confirmActivate(context, ref, report);
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: Sizes.p8,
                    horizontal: Sizes.p16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.p12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    onTap: () => ref.read(goRouterProvider).pushNamed(
                          AppRoute.editReport.name,
                          extra: report,
                        ),
                    child: ListTile(
                      leading: ReportStatusIcon(status: report.status),
                      title: Text('${report.title} - Building: ${report.buildingId}'),
                      subtitle: Text(
                          'Date: ${ref.read(dateFormatterProvider).format(report.date)}'),
                      trailing: report.status == ReportStatus.open &&
                              userRole == UserRole.operator
                          ? const Icon(Icons.check_circle)
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: userRole == UserRole.reporter
          ? FloatingActionButton(
              onPressed: () =>
                  ref.read(goRouterProvider).pushNamed(AppRoute.createReport.name),
              child: const Icon(Icons.add),
            )
          : null, // Solo il Reporter può aggiungere nuovi report
    );
  }
}
