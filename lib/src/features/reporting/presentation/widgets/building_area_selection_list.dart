import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/building_area_selection_list_controller.dart';

class BuildingAreaSelectionList extends ConsumerWidget {
  final String buildingId;
  final ValueChanged<Map<String, String>> onSelected;

  const BuildingAreaSelectionList({
    required this.buildingId,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(buildingAreaSelectionListControllerProvider(buildingId));
    final controller =
        ref.read(buildingAreaSelectionListControllerProvider(buildingId).notifier);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          Center(child: Text(context.loc.errorLoadingAreas.capitalizeFirst())),
      data: (data) => ListView.builder(
        itemCount: data.areas.length + (data.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == data.areas.length) {
            controller.fetchMoreAreas(buildingId);
            return const Center(child: CircularProgressIndicator());
          }
          final area = data.areas[index];
          return ListTile(
            title: Text(area['name']!),
            onTap: () => onSelected(area),
          );
        },
      ),
    );
  }
}
