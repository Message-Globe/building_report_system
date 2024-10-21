import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/filters_controllers.dart';
import 'building_selection_dropdown.dart';

class FiltersButton extends ConsumerWidget {
  const FiltersButton({super.key});

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

            return StatefulBuilder(
              builder: (context, setDialogState) {
                final userProfile = ref.watch(authRepositoryProvider).currentUser!;

                return AlertDialog(
                  title: const Text('Filter Reports'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildingSelectionDropdown(
                        buildingIds: userProfile.buildingsIds,
                        selectedBuilding: tempSelectedBuilding,
                        onBuildingSelected: (newValue) {
                          setDialogState(() {
                            tempSelectedBuilding = newValue;
                          });
                        },
                        showAllBuildings: true,
                      ),
                      // Checkbox per "Show completed Reports"
                      CheckboxListTile(
                        title: const Text('Show completed Reports'),
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
                        Navigator.of(context).pop();
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
                        Navigator.of(context).pop();
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
