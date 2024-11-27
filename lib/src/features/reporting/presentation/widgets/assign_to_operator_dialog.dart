import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/report.dart';
import '../controllers/maintenance_team_selection_controller.dart';

class AssignToOperatorDialog extends ConsumerStatefulWidget {
  final Report report;

  const AssignToOperatorDialog({super.key, required this.report});

  @override
  ConsumerState<AssignToOperatorDialog> createState() => _AssignToOperatorDialogState();
}

class _AssignToOperatorDialogState extends ConsumerState<AssignToOperatorDialog> {
  String? selectedOperator;

  @override
  Widget build(BuildContext context) {
    final maintainers =
        ref.watch(maintenanceTeamSelectionControllerProvider(widget.report.id));

    return AlertDialog(
      title: Text(context.loc.selectOperator.capitalizeFirst()),
      content: maintainers.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, st) => Text(context.loc.errorOccurred.capitalizeFirst()),
        data: (maintainers) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedOperator,
                hint: Text(context.loc.selectOperator.capitalizeFirst()),
                items: maintainers.map((maintainer) {
                  return DropdownMenuItem<String>(
                    value: maintainer['id'],
                    child: Text(maintainer['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOperator = value; // Aggiorna lo stato
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.cancel.capitalizeFirst()),
        ),
        TextButton(
          onPressed: () {
            if (selectedOperator != null) {
              Navigator.of(context).pop(selectedOperator);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(context.loc.selectOperatorBeforeAssigning.capitalizeFirst()),
                ),
              );
            }
          },
          child: Text(context.loc.assign.capitalizeFirst()),
        ),
      ],
    );
  }
}
