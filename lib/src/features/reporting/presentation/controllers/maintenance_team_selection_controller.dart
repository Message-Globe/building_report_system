import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/reports_repository.dart';

part 'maintenance_team_selection_controller.g.dart';

@riverpod
class MaintenanceTeamSelectionController extends _$MaintenanceTeamSelectionController {
  @override
  Future<List<Map<String, String>>> build(String reportId) async {
    try {
      return await ref.read(reportsRepositoryProvider).fetchMaintenanceTeams(reportId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
