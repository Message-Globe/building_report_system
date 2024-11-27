import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/reports_repository.dart';

part 'building_area_selection_list_controller.g.dart';

@riverpod
class BuildingAreaSelectionListController extends _$BuildingAreaSelectionListController {
  int _currentPage = 1;

  @override
  Future<BuildingAreaState> build(String buildingId) async {
    return _fetchAndInitialize(buildingId);
  }

  Future<BuildingAreaState> _fetchAndInitialize(String buildingId) async {
    try {
      final areas = await ref
          .read(reportsRepositoryProvider)
          .fetchBuildingAreas(buildingId: buildingId, page: _currentPage);
      final hasMore = areas.isNotEmpty;
      _currentPage++;
      return BuildingAreaState(areas: areas, hasMore: hasMore);
    } catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }

  Future<void> fetchMoreAreas(String buildingId) async {
    final currentState = state.asData?.value;

    if (currentState == null || !currentState.hasMore) {
      return;
    }

    try {
      final areas = await ref
          .read(reportsRepositoryProvider)
          .fetchBuildingAreas(buildingId: buildingId, page: _currentPage);

      final hasMore = areas.isNotEmpty;

      state = state.whenData(
        (current) => BuildingAreaState(
          areas: [...current.areas, ...areas],
          hasMore: hasMore,
        ),
      );

      _currentPage++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class BuildingAreaState {
  final List<Map<String, String>> areas;
  final bool hasMore;

  BuildingAreaState({required this.areas, required this.hasMore});
}
