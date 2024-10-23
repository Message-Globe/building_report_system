import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
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
      hint: Text(context.loc.selectPriority),
      onChanged: (newValue) {
        onPrioritySelected(newValue);
      },
      items: PriorityLevel.values.map<DropdownMenuItem<PriorityLevel>>(
        (PriorityLevel value) {
          return DropdownMenuItem<PriorityLevel>(
            value: value,
            child: Text(value.name),
          );
        },
      ).toList(),
    );
  }
}
