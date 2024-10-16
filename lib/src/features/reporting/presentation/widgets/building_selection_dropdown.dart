import 'package:flutter/material.dart';

class BuildingSelectionDropdown extends StatelessWidget {
  final List<String> buildingIds;
  final String? selectedBuilding;
  final Function(String?) onBuildingSelected;
  final bool showAllBuildings;

  const BuildingSelectionDropdown({
    super.key,
    required this.buildingIds,
    required this.selectedBuilding,
    required this.onBuildingSelected,
    this.showAllBuildings = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedBuilding,
      hint: const Text('Select Building'),
      onChanged: (newValue) {
        onBuildingSelected(newValue);
      },
      items: [
        if (showAllBuildings)
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All Buildings'),
          ),
        ...buildingIds.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ),
      ],
    );
  }
}
