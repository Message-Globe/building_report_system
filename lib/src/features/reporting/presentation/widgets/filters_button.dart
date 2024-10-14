import 'package:building_report_system/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/filters_controllers.dart';
import 'package:building_report_system/src/features/reporting/presentation/widgets/building_filter_dropdown.dart';

class FiltersButton extends ConsumerWidget {
  final List<String> buildingsIds;

  const FiltersButton({
    super.key,
    required this.buildingsIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controlla se ci sono filtri attivi
    final bool showWorked = ref.watch(showworkedFilterProvider);
    final bool showDeleted = ref.watch(showDeletedFilterProvider);
    final String? selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    // Se uno dei filtri è attivo, mostra il badge
    bool isFilterActive = showWorked || showDeleted || selectedBuilding != null;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            _showFilterOptions(context, ref);
          },
        ),
        if (isFilterActive)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (_, ref, __) {
            // Usa variabili temporanee per i filtri
            bool tempShowworked = ref.watch(showworkedFilterProvider);
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
                      // Checkbox per "Show worked Reports"
                      CheckboxListTile(
                        title: const Text('Show worked Reports'),
                        value: tempShowworked,
                        onChanged: (value) {
                          setDialogState(() {
                            tempShowworked = value ?? false;
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
                        // Reset di tutti i filtri
                        setDialogState(() {
                          tempShowworked = false;
                          tempShowDeleted = false;
                          tempSelectedBuilding = null;
                        });
                      },
                      child: const Text('Clear'),
                    ),
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
                            .read(showworkedFilterProvider.notifier)
                            .update(tempShowworked);
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
