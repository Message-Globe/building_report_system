import 'package:building_report_system/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/filters_controllers.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/building_filter_dropdown.dart';

class FiltersButton extends StatelessWidget {
  final List<String> buildingsIds;

  const FiltersButton({
    super.key,
    required this.buildingsIds,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        _showFilterOptions(context);
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (_, ref, __) {
            // Usa variabili temporanee per i filtri
            bool tempShowCompleted = ref.watch(showCompletedFilterProvider);
            bool tempShowDeleted = ref.watch(showDeletedFilterProvider);
            String? tempSelectedBuilding = ref.watch(selectedBuildingFilterProvider);

            final goRouter = ref.read(goRouterProvider);

            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  title: const Text('Filter Reports'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildingFilterDropdown(
                        buildingIds: buildingsIds,
                        selectedBuilding: tempSelectedBuilding,
                        onBuildingSelected: (newValue) {
                          setDialogState(() {
                            tempSelectedBuilding = newValue;
                          });
                        },
                      ),
                      // Checkbox per "Show Completed Reports"
                      CheckboxListTile(
                        title: const Text('Show Completed Reports'),
                        value: tempShowCompleted,
                        onChanged: (value) {
                          setDialogState(() {
                            tempShowCompleted = value ?? false;
                          });
                        },
                      ),
                      // Checkbox per "Show Deleted Reports"
                      CheckboxListTile(
                        title: const Text('Show Deleted Reports'),
                        value: tempShowDeleted,
                        onChanged: (value) {
                          setDialogState(() {
                            tempShowDeleted = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        goRouter.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Applica i filtri solo quando si preme "Apply"
                        ref
                            .read(showCompletedFilterProvider.notifier)
                            .update(tempShowCompleted);
                        ref
                            .read(showDeletedFilterProvider.notifier)
                            .update(tempShowDeleted);
                        ref
                            .read(selectedBuildingFilterProvider.notifier)
                            .update(tempSelectedBuilding);
                        goRouter.pop();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
