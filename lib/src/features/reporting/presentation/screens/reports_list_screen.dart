import 'package:building_report_system/src/common_widgets/async_value_widget.dart';
import 'package:building_report_system/src/constants/app_sizes.dart';
import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/filters_controllers.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/app_drawer.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/filters_button.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/report_status_icon.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/reverse_order_button.dart';
import 'package:building_report_system/src/routing/app_router.dart';
import 'package:building_report_system/src/utils/async_value_ui.dart';
import 'package:building_report_system/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/data/auth_repository.dart';
import '../../data/reports_repository.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final dateFormatter = ref.read(dateFormatterProvider);
    final showworked = ref.watch(showworkedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reverseOrder = ref.watch(reverseOrderFilterProvider);
    final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    final reportsListValue = ref.watch(
      reportsListStreamProvider(
        showworked: showworked,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: selectedBuilding,
      ),
    );

    ref.listen(
      reportsListStreamProvider(
        showworked: showworked,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: selectedBuilding,
      ),
      (_, next) => next.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Report List'),
            if (userProfile.role == UserRole.operator)
              Consumer(
                builder: (_, ref, __) {
                  final openReportsCount = ref.watch(openReportsCountProvider);

                  return openReportsCount.when(
                    data: (count) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Chip(
                        backgroundColor: Colors.red,
                        label: Text(
                          '$count open',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, stack) => const SizedBox(),
                  );
                },
              ),
          ],
        ),
        actions: [
          const ReverseOrderButton(),
          FiltersButton(buildingsIds: userProfile.buildingsIds),
        ],
      ),
      drawer: const AppDrawer(),
      body: AsyncValueWidget(
        value: reportsListValue,
        data: (reports) => RefreshIndicator(
          onRefresh: () async => ref.refresh(
            reportsListStreamProvider(
              showworked: showworked,
              showDeleted: showDeleted,
              reverseOrder: reverseOrder,
              buildingId: selectedBuilding,
            ),
          ),
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Dismissible(
                key: ValueKey(report),
                direction: userProfile.role == UserRole.reporter &&
                        report.status == ReportStatus.open
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) {
                  return _confirmDeleteReport(context, ref, report);
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
                      subtitle: Text('Date: ${dateFormatter.format(report.date)}'),
                      trailing: report.status == ReportStatus.open &&
                              userProfile.role == UserRole.operator
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
      floatingActionButton: userProfile.role == UserRole.reporter
          ? FloatingActionButton(
              onPressed: () =>
                  ref.read(goRouterProvider).pushNamed(AppRoute.createReport.name),
              child: const Icon(Icons.add),
            )
          : null, // Solo il Reporter può aggiungere nuovi report
    );
  }
}
