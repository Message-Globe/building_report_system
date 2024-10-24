import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import '../../../authentication/data/auth_repository.dart';
import 'filters_controllers.dart';

part 'reports_list_controller.g.dart';

@riverpod
class ReportsListController extends _$ReportsListController {
  @override
  FutureOr<List<Report>> build() async {
    return ref.watch(reportsListFutureProvider.future);
  }

  FutureOr<void> refreshReports() async {
    final reportsRepository = ref.watch(reportsRepositoryProvider);
    final userProfile = ref.watch(authRepositoryProvider).currentUser!;

    final showCompleted = ref.watch(showworkedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reverseOrder = ref.watch(reverseOrderFilterProvider);
    final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    state = await AsyncValue.guard(
      () => reportsRepository.fetchReportsList(
        showCompleted: showCompleted,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        userProfile: userProfile,
        buildingId: selectedBuilding,
      ),
    );
  }

  // TODO: fix filters. they need to be local

  // Metodo per aggiungere un nuovo report alla lista
  void addReportToList(Report newReport) {
    final updatedReports = [...state.value!, newReport];
    state = AsyncData(updatedReports);
  }

  // Metodo per aggiornare lo stato di un singolo report nella lista
  void updateReportInList(Report updatedReport) {
    final updatedReports = state.value!.map((report) {
      return report.id == updatedReport.id ? updatedReport : report;
    }).toList();

    state = AsyncData(updatedReports);
  }
}
