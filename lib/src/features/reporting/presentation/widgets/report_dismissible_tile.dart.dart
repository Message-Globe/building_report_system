import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/alert_dialogs.dart'; // Importa la tua funzione di dialogo
import '../../../../constants/app_sizes.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../domain/report.dart';
import '../controllers/report_dismissible_tile_controller.dart';
import 'assign_to_operator_dialog.dart';
import 'report_tile.dart';

class ReportDismissibleTile extends ConsumerWidget {
  final Report report;
  final UserProfile userProfile;

  const ReportDismissibleTile({
    super.key,
    required this.report,
    required this.userProfile,
  });

  Future<bool> _handleDismissAction(
    BuildContext context,
    WidgetRef ref,
    Report report,
  ) async {
    final userRole = userProfile.role;
    final isMaintenanceLead = userProfile.isMaintenanceLead;

    if (userRole == UserRole.reporter) {
      final confirm = await showAlertDialog(
        context: context,
        title: context.loc.confirmDelete.capitalizeFirst(),
        content: context.loc.confirmDeleteReport.capitalizeFirst(),
        cancelActionText: context.loc.cancel.capitalizeFirst(),
        defaultActionText: context.loc.delete.capitalizeFirst(),
      );

      if (confirm == true) {
        await ref
            .read(reportDismissibleTileControllerProvider.notifier)
            .deleteReport(report);
      }

      return confirm ?? false;
    } else if (report.status == ReportStatus.opened) {
      if (isMaintenanceLead) {
        // Mostra il dialog con il dropdown per selezionare il manutentore
        final selectedOperatorId = await showDialog<String>(
          context: context,
          builder: (context) => AssignToOperatorDialog(report: report),
        );

        if (selectedOperatorId != null) {
          await ref
              .read(reportDismissibleTileControllerProvider.notifier)
              .assignReport(report: report, operatorId: selectedOperatorId);
          return true;
        }
        return false;
      } else {
        // Assegna il report a se stesso
        final confirm = await showAlertDialog(
          context: context,
          title: context.loc.confirmAssignation.capitalizeFirst(),
          content: context.loc.confirmAssignReport.capitalizeFirst(),
          cancelActionText: context.loc.cancel.capitalizeFirst(),
          defaultActionText: context.loc.assign.capitalizeFirst(),
        );

        if (confirm == true) {
          await ref
              .read(reportDismissibleTileControllerProvider.notifier)
              .assignReport(report: report, operatorId: userProfile.appUser.uid);
        }

        return confirm ?? false;
      }
    } else {
      final confirm = await showAlertDialog(
        context: context,
        title: context.loc.confirmUnassignation.capitalizeFirst(),
        content: context.loc.confirmUnassignReport.capitalizeFirst(),
        cancelActionText: context.loc.cancel.capitalizeFirst(),
        defaultActionText: context.loc.unassign.capitalizeFirst(),
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
    final userRole = userProfile.role;
    final isLoading = ref.watch(reportDismissibleTileControllerProvider).isLoading;
    final isMaintenanceLead = userProfile.isMaintenanceLead;
    final canAssignReport = userRole == UserRole.operator &&
        report.status != ReportStatus.closed &&
        report.status != ReportStatus.deleted &&
        (report.assignedTo == '' ||
            (report.assignedTo == userProfile.appUser.uid && !isMaintenanceLead));

    return Dismissible(
      key: ValueKey(report),
      direction:
          (userRole == UserRole.reporter && report.status == ReportStatus.opened) ||
                  canAssignReport
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
