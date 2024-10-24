import 'package:riverpod_annotation/riverpod_annotation.dart';

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

    state = await AsyncValue.guard(() async {
      // Effettua la chiamata al backend per aggiornare il report
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

      // Aggiorna il controller della lista dei reports
      ref.read(reportsListControllerProvider.notifier).updateReportInList(
            report.copyWith(
              buildingId: buildingId,
              buildingSpot: buildingSpot,
              priority: priority,
              title: title,
              description: description,
              photoUrls: photoUrls ?? report.photoUrls,
              maintenanceDescription: maintenanceDescription,
              maintenancePhotoUrls: maintenancePhotoUrls ?? report.maintenancePhotoUrls,
            ),
          );

      // Quando la chiamata al backend è completata, puoi chiudere la schermata di edit
      return;
    });
  }

  Future<void> completeReport({
    required Report report,
    required String maintenanceDescription,
    List<String>? maintenancePhotoUrls,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // Effettua la chiamata al backend per completare il report
      await ref.read(reportsRepositoryProvider).completeReport(
            report.copyWith(
              maintenanceDescription: maintenanceDescription,
              maintenancePhotoUrls: maintenancePhotoUrls ?? [],
            ),
          );

      // Aggiorna il controller della lista con il report completato
      ref.read(reportsListControllerProvider.notifier).updateReportInList(
            report.copyWith(
              status: ReportStatus.completed,
              maintenanceDescription: maintenanceDescription,
              maintenancePhotoUrls: maintenancePhotoUrls ?? report.maintenancePhotoUrls,
            ),
          );

      // Una volta completata l'operazione, rimuovi lo stato di caricamento
      return;
    });
  }
}
