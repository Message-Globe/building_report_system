import 'package:building_report_system/src/common_widgets/async_value_widget.dart';
import 'package:building_report_system/src/constants/app_sizes.dart';
import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';
import 'package:building_report_system/src/features/reporting/data/fake_reports_repository.dart';
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

class ReportsListScreen extends ConsumerWidget {
  final UserRole userRole;
  final List<String> buildingsIds;

  const ReportsListScreen({
    super.key,
    required this.userRole,
    required this.buildingsIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.read(dateFormatterProvider);
    final showCompleted = ref.watch(showCompletedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reverseOrder = ref.watch(reverseOrderFilterProvider);
    final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    final reportsListValue = ref.watch(
      reportsListFutureProvider(
        showCompleted: showCompleted,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: selectedBuilding, // Aggiungi filtro edificio
      ),
    );

    ref.listen(
      reportsListFutureProvider(
        showCompleted: showCompleted,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: selectedBuilding, // Ascolta i cambiamenti del filtro edificio
      ),
      (_, next) => next.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
        actions: [
          const ReverseOrderButton(),
          FiltersButton(buildingsIds: buildingsIds),
        ],
      ),
      drawer: const AppDrawer(),
      body: AsyncValueWidget(
        value: reportsListValue,
        data: (reports) => RefreshIndicator(
          onRefresh: () async => ref.refresh(
            reportsListFutureProvider(
              showCompleted: showCompleted,
              showDeleted: showDeleted,
              reverseOrder: reverseOrder,
              buildingId: selectedBuilding,
            ),
          ),
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: Sizes.p8, horizontal: Sizes.p16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                  onTap: () {
                    // Navigate to detailed view
                  },
                  child: ListTile(
                    leading: ReportStatusIcon(status: report.status),
                    title: Text('${report.title} - Building: ${report.buildingId}'),
                    subtitle: Text('Date: ${dateFormatter.format(report.date)}'),
                    trailing: report.status == ReportStatus.active &&
                            userRole == UserRole.operator
                        ? const Icon(Icons.check_circle) // Operator can mark as complete
                        : null,
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
