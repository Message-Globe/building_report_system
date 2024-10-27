import 'package:building_report_system/src/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../authentication/domain/building.dart';

class BuildingSelectionDropdown extends StatelessWidget {
  final List<Building> buildings;
  final Building? selectedBuilding;
  final Function(Building?) onBuildingSelected;
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
    return DropdownButton<Building>(
      value: selectedBuilding,
      hint: Text(context.loc.selectBuilding),
      onChanged: (newValue) {
        onBuildingSelected(newValue);
      },
      items: [
        if (showAllBuildings)
          DropdownMenuItem<Building>(
            value: null,
            child: Text(context.loc.allBuildings),
          ),
        ...buildings.map<DropdownMenuItem<Building>>(
          (Building building) {
            return DropdownMenuItem<Building>(
              value: building,
              child: Text(building.name),
            );
          },
        ),
      ],
    );
  }
}
