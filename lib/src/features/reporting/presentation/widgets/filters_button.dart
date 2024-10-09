import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/filters_controllers.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({super.key});

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
          builder: (context, ref, child) {
            bool tempShowCompleted = ref.watch(showCompletedFilterProvider);
            bool tempShowDeleted = ref.watch(showDeletedFilterProvider);

            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  title: const Text('Filter Reports'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        title: const Text('Show Completed Reports'),
                        value: tempShowCompleted,
                        onChanged: (value) {
                          setDialogState(() {
                            tempShowCompleted = value ?? false;
                          });
                        },
                      ),
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(showCompletedFilterProvider.notifier)
                            .update(tempShowCompleted);
                        ref
                            .read(showDeletedFilterProvider.notifier)
                            .update(tempShowDeleted);
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
