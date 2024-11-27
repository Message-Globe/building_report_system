import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/building.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import 'reports_list_controller.dart';

part 'edit_report_screen_controller.g.dart';

@riverpod
class EditReportScreenController extends _$EditReportScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> updateReport({
    required Report report,
    String? category,
    // String? title,
    String? description,
    String? resolveBy,
    Building? building,
    String? buildingAreaId,
    PriorityLevel? priority,
    List<String>? photosUrls,
    List<String>? newPhotos,
    String? maintenanceDescription,
    bool? escalatedToAdmin,
    bool? areaNotAvailable,
    List<String>? maintenancePhotoUrls,
    List<String>? newMaintenancePhotos,
  }) async {
    state = const AsyncLoading();

    final currentUser = ref.read(authRepositoryProvider).currentUser!;

    state = await AsyncValue.guard(() async {
      // Effettua la chiamata al backend per aggiornare il report
      final updatedReport = await ref.read(reportsRepositoryProvider).updateReport(
            currentUser: currentUser,
            category: category,
            reportId: report.id,
            building: building,
            buildingAreaId: buildingAreaId,
            priority: priority,
            // title: title,
            description: description,
            resolveBy: resolveBy,
            photosUrls: photosUrls,
            newPhotos: newPhotos,
            maintenanceDescription: maintenanceDescription,
            escalatedToAdmin: escalatedToAdmin,
            areaNotAvailable: areaNotAvailable,
            maintenancePhotoUrls: maintenancePhotoUrls,
            newMaintenancePhotos: newMaintenancePhotos,
          );

      // Aggiorna il controller della lista dei reports
      ref.read(reportsListControllerProvider.notifier).updateReportInList(updatedReport);

      // Quando la chiamata al backend è completata, puoi chiudere la schermata di edit
      return;
    });
  }

  Future<void> completeReport({
    required Report report,
    required String maintenanceDescription,
    required List<String> maintenancePhotoUrls,
  }) async {
    state = const AsyncLoading();

    final currentUser = ref.read(authRepositoryProvider).currentUser!;

    state = await AsyncValue.guard(() async {
      // Effettua la chiamata al backend per completare il report
      await ref.read(reportsRepositoryProvider).completeReport(
            currentUser: currentUser,
            reportId: report.id,
            maintenanceDescription: maintenanceDescription,
            maintenancePhotosUrls: maintenancePhotoUrls,
          );

      // Aggiorna il controller della lista con il report completato
      ref.read(reportsListControllerProvider.notifier).updateReportInList(
            report.copyWith(
              status: ReportStatus.closed,
              maintenanceDescription: maintenanceDescription,
              maintenancePhotoUrls: maintenancePhotoUrls,
            ),
          );

      // Una volta completata l'operazione, rimuovi lo stato di caricamento
      return;
    });
  }
}
