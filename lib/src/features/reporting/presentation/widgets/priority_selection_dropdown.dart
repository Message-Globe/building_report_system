import 'package:flutter/material.dart';

import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import '../../domain/report.dart';

class PrioritySelectionDropdown extends StatelessWidget {
  final PriorityLevel? selectedPriority;
  final Function(PriorityLevel?) onPrioritySelected;

  const PrioritySelectionDropdown({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<PriorityLevel>(
      value: selectedPriority,
      hint: Text(context.loc.selectPriority.capitalizeFirst()),
      onChanged: (newValue) {
        onPrioritySelected(newValue);
      },
      items: PriorityLevel.values.map<DropdownMenuItem<PriorityLevel>>(
        (PriorityLevel value) {
          return DropdownMenuItem<PriorityLevel>(
            value: value,
            child: Text(value.toLocalizedString(context).capitalizeFirst()),
          );
        },
      ).toList(),
    );
  }
}
