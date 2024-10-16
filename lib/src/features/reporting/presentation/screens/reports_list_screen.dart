import 'package:building_report_system/src/features/reporting/presentation/widgets/report_dismissible_tile.dart.dart';
import 'package:building_report_system/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/async_value_widget.dart';
import '../../../../routing/app_router.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../data/reports_repository.dart';
import '../controllers/filters_controllers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/filters_button.dart';
import '../widgets/reverse_order_button.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider);
    final reportsListValue = ref.watch(reportsListStreamProvider);

    ref.listen(
      reportsListStreamProvider,
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
          onRefresh: () async {
            // TODO: check here if it can be changed
            final userProfile = ref.read(authStateProvider).asData!.value!;
            final showCompleted = ref.read(showworkedFilterProvider);
            final showDeleted = ref.read(showDeletedFilterProvider);
            final reverseOrder = ref.read(reverseOrderFilterProvider);
            final selectedBuilding = ref.read(selectedBuildingFilterProvider);

            // Forza un aggiornamento leggendo direttamente dalla repository
            await ref.read(reportsRepositoryProvider).fetchReportsList(
                  showCompleted: showCompleted,
                  showDeleted: showDeleted,
                  reverseOrder: reverseOrder,
                  userProfile: userProfile,
                  buildingId: selectedBuilding,
                );
          },
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return ReportDismissibleTile(
                report: report,
                userRole: userRole,
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
