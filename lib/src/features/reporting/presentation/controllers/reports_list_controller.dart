import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import '../../../authentication/data/auth_repository.dart';
import 'filters_controllers.dart';

part 'reports_list_controller.g.dart';

@riverpod
class ReportsListController extends _$ReportsListController {
  @override
  Future<List<Report>> build() async {
    return ref.watch(reportsListFutureProvider.future);
  }

  Future<void> refreshReports() async {
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

  Future<void> addReport({
    required String buildingId,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    required List<String> photoUrls,
  }) async {
    state = const AsyncLoading();

    await AsyncValue.guard(() async {
      final userProfile = ref.read(authRepositoryProvider).currentUser!;
      final newReport = await ref.read(reportsRepositoryProvider).addReport(
            createdBy: userProfile.appUser.uid,
            buildingId: buildingId,
            buildingSpot: buildingSpot,
            priority: priority,
            title: title,
            description: description,
            photoUrls: photoUrls,
          );
      // Aggiungi il nuovo report alla lista esistente
      state = AsyncData([...state.value!, newReport]);
    });
  }

  Future<void> updateReport({
    required Report report,
    required String buildingId,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    List<String>? photoUrls,
    required String maintenanceDescription,
    List<String>? maintenancePhotoUrls,
  }) async {
    state = const AsyncLoading();

    await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).updateReport(
            report: report,
            buildingId: buildingId,
            buildingSpot: buildingSpot,
            priority: priority,
            title: title,
            description: description,
            photoUrls: photoUrls,
            maintenanceDescription: maintenanceDescription,
            maintenancePhotoUrls: maintenancePhotoUrls,
          );

      // Aggiorna il report modificato nella lista esistente
      final updatedReports = state.value!.map((r) {
        return r.id == report.id
            ? report.copyWith(
                buildingId: buildingId,
                buildingSpot: buildingSpot,
                priority: priority,
                title: title,
                description: description,
                photoUrls: photoUrls ?? r.photoUrls,
                maintenanceDescription: maintenanceDescription,
                maintenancePhotoUrls: maintenancePhotoUrls ?? r.maintenancePhotoUrls,
              )
            : r;
      }).toList();

      state = AsyncData(updatedReports);
    });
  }

  Future<void> completeReport({
    required Report report,
    required String maintenanceDescription,
    List<String>? maintenancePhotoUrls,
  }) async {
    state = const AsyncLoading();

    await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).completeReport(report);

      // Aggiorna il report completato nella lista esistente
      final updatedReports = state.value!.map((r) {
        return r.id == report.id
            ? report.copyWith(
                status: ReportStatus.completed,
                maintenanceDescription: maintenanceDescription,
                maintenancePhotoUrls: maintenancePhotoUrls ?? r.maintenancePhotoUrls,
              )
            : r;
      }).toList();

      state = AsyncData(updatedReports);
    });
  }

  Future<void> assignReport({
    required Report report,
    required String operatorId,
  }) async {
    await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).assignReportToOperator(
            report: report,
            operatorId: operatorId,
          );

      // Aggiorna lo stato del report con l'assegnazione
      final updatedReports = state.value!.map((r) {
        return r.id == report.id
            ? report.copyWith(
                assignedTo: operatorId,
                status: ReportStatus.assigned,
              )
            : r;
      }).toList();

      state = AsyncData(updatedReports);
    });
  }

  Future<void> unassignReport(Report report) async {
    await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).unassignReportFromOperator(report);

      // Aggiorna lo stato del report disassegnato
      final updatedReports = state.value!.map((r) {
        return r.id == report.id
            ? report.copyWith(
                assignedTo: '',
                status: ReportStatus.opened,
              )
            : r;
      }).toList();

      state = AsyncData(updatedReports);
    });
  }

  Future<void> deleteReport(Report report) async {
    await AsyncValue.guard(() async {
      await ref.read(reportsRepositoryProvider).deleteReport(report);

      // Rimuovi il report dalla lista
      final updatedReports = state.value!.where((r) => r.id != report.id).toList();

      state = AsyncData(updatedReports);
    });
  }
}
