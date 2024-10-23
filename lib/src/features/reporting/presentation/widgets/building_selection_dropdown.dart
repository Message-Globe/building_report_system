import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';

class BuildingSelectionDropdown extends StatelessWidget {
  final List<String> buildings;
  final String? selectedBuilding;
  final Function(String?) onBuildingSelected;
  final bool showAllBuildings;

  const BuildingSelectionDropdown({
    super.key,
    required this.buildings,
    required this.selectedBuilding,
    required this.onBuildingSelected,
    this.showAllBuildings = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedBuilding,
      hint: Text(context.loc.selectBuilding),
      onChanged: (newValue) {
        onBuildingSelected(newValue);
      },
      items: [
        if (showAllBuildings)
          DropdownMenuItem<String>(
            value: null,
            child: Text(context.loc.allBuildings),
          ),
        ...buildings.map<DropdownMenuItem<String>>(
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
