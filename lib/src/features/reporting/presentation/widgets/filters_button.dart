import '../../../../l10n/string_extensions.dart';

import '../../../authentication/data/auth_repository.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/domain/building.dart';
import '../controllers/filters_controllers.dart';
import 'building_selection_dropdown.dart';

class FiltersButton extends ConsumerWidget {
  const FiltersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controlla se ci sono filtri attivi
    final bool showWorked = ref.watch(showCompletedFilterProvider);
    final bool showDeleted = ref.watch(showDeletedFilterProvider);
    final Building? selectedBuilding = ref.watch(selectedBuildingFilterProvider);

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
            bool tempShowWorked = ref.watch(showCompletedFilterProvider);
            bool tempShowDeleted = ref.watch(showDeletedFilterProvider);
            Building? tempSelectedBuilding = ref.watch(selectedBuildingFilterProvider);

            return StatefulBuilder(
              builder: (context, setDialogState) {
                final userProfile = ref.watch(authRepositoryProvider).currentUser!;

                return AlertDialog(
                  title: Text(context.loc.filterReports.capitalizeFirst()),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildingSelectionDropdown(
                        buildings: userProfile.assignedBuildings,
                        selectedBuilding: tempSelectedBuilding,
                        onBuildingSelected: (newBuilding) {
                          setDialogState(() {
                            tempSelectedBuilding = newBuilding;
                          });
                        },
                        showAllBuildings: true,
                      ),
                      // Checkbox per "Show closed Reports"
                      CheckboxListTile(
                        title: Text(context.loc.showCompletedReports.capitalizeFirst()),
                        value: tempShowWorked,
                        onChanged: (value) {
                          setDialogState(() {
                            tempShowWorked = value ?? false;
                          });
                        },
                      ),
                      // Checkbox per "Show Deleted Reports"
                      CheckboxListTile(
                        title: Text(context.loc.showDeletedReports.capitalizeFirst()),
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
                          tempShowWorked = false;
                          tempShowDeleted = false;
                          tempSelectedBuilding = null;
                        });
                      },
                      child: Text(context.loc.clear.capitalizeFirst()),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(context.loc.cancel.capitalizeFirst()),
                    ),
                    TextButton(
                      onPressed: () {
                        // Applica i filtri solo quando si preme "Apply"
                        ref
                            .read(showCompletedFilterProvider.notifier)
                            .update(tempShowWorked);
                        ref
                            .read(showDeletedFilterProvider.notifier)
                            .update(tempShowDeleted);
                        ref
                            .read(selectedBuildingFilterProvider.notifier)
                            .update(tempSelectedBuilding);
                        Navigator.of(context).pop();
                      },
                      child: Text(context.loc.apply.capitalizeFirst()),
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
