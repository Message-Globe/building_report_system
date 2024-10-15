import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import '../controllers/filters_controllers.dart';
import '../../../authentication/data/auth_repository.dart';

part 'reports_list_screen_controller.g.dart';

@riverpod
class ReportsListScreenController extends _$ReportsListScreenController {
  @override
  Future<List<Report>> build() {
    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final showCompleted = ref.watch(showworkedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reverseOrder = ref.watch(reverseOrderFilterProvider);
    final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    return ref.watch(reportsRepositoryProvider).fetchReportsList(
          showCompleted: showCompleted,
          showDeleted: showDeleted,
          reverseOrder: reverseOrder,
          userProfile: userProfile,
          buildingId: selectedBuilding,
        );
  }

  Future<void> refreshReports() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
