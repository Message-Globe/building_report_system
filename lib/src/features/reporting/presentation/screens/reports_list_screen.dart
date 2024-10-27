import '../controllers/reports_list_controller.dart';
import '../../../../utils/async_value_ui.dart';
import '../../../../utils/context_extensions.dart';

import '../widgets/report_dismissible_tile.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/async_value_widget.dart';
import '../../../../routing/app_router.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/user_profile.dart';
import '../widgets/app_drawer.dart';
import '../widgets/filters_button.dart';
import '../widgets/reverse_order_button.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(authRepositoryProvider).currentUser!;
    final userRole = userProfile.role;
    final reportsListValue = ref.watch(reportsListControllerProvider);

    ref.listen(
      reportsListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.reportList),
        actions: const <Widget>[
          ReverseOrderButton(),
          FiltersButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: AsyncValueWidget(
        value: reportsListValue,
        data: (reports) => RefreshIndicator(
          onRefresh: ref.read(reportsListControllerProvider.notifier).refreshReports,
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return ReportDismissibleTile(
                report: report,
                userProfile: userProfile,
              );
            },
          ),
        ),
      ),
      floatingActionButton: userRole == UserRole.reporter
          ? FloatingActionButton(
              onPressed: () => context.goNamed(AppRoute.createReport.name),
              child: const Icon(Icons.add),
            )
          : null, // Solo il Reporter può aggiungere nuovi report
    );
  }
}
