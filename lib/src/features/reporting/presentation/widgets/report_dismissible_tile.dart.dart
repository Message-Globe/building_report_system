import 'package:building_report_system/src/features/reporting/presentation/widgets/report_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_sizes.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../domain/report.dart';
import '../controllers/report_dismissible_tile_controller.dart';
import '../../../../common_widgets/alert_dialogs.dart'; // Importa la tua funzione di dialogo

class ReportDismissibleTile extends ConsumerWidget {
  final Report report;
  final UserRole? userRole;

  const ReportDismissibleTile({
    super.key,
    required this.report,
    required this.userRole,
  });

  Future<bool> _handleDismissAction(
    BuildContext context,
    WidgetRef ref,
    Report report,
  ) async {
    if (userRole == UserRole.reporter) {
      final confirm = await showAlertDialog(
        context: context,
        title: 'Confirm Delete',
        content: 'Are you sure you want to delete this report?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Delete',
      );

      if (confirm == true) {
        await ref
            .read(reportDismissibleTileControllerProvider.notifier)
            .deleteReport(report);
      }

      return confirm ?? false;
    } else if (report.status == ReportStatus.open) {
      final confirm = await showAlertDialog(
        context: context,
        title: 'Confirm Assignation',
        content: 'Are you sure you want to assign this report to you?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Assign',
      );

      if (confirm == true) {
        await ref
            .read(reportDismissibleTileControllerProvider.notifier)
            .assignReport(report);
      }

      return confirm ?? false;
    } else {
      final confirm = await showAlertDialog(
        context: context,
        title: 'Confirm Unassignation',
        content: 'Are you sure you want to unassign this report from you?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Unassign',
      );

      if (confirm == true) {
        await ref
            .read(reportDismissibleTileControllerProvider.notifier)
            .unassignReport(report);
      }

      return confirm ?? false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(reportDismissibleTileControllerProvider).isLoading;

    return Dismissible(
      key: ValueKey(report),
      direction: (userRole == UserRole.reporter && report.status == ReportStatus.open) ||
              (userRole == UserRole.operator &&
                  report.status != ReportStatus.completed &&
                  report.status != ReportStatus.deleted)
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Stack(
        children: <Widget>[
          Container(
            color: userRole == UserRole.reporter ? Colors.red : Colors.amber,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Icon(
              userRole == UserRole.reporter ? Icons.delete : Icons.handyman,
              color: Colors.white,
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
      confirmDismiss: (direction) => _handleDismissAction(context, ref, report),
      child: ReportTile(report: report),
    );
  }
}
