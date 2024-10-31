import '../../../authentication/data/auth_repository.dart';
import '../../data/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/report.dart';
import 'reports_list_controller.dart';

part 'report_dismissible_tile_controller.g.dart';

@riverpod
class ReportDismissibleTileController extends _$ReportDismissibleTileController {
  @override
  FutureOr<void> build() {}

  // Gestisci l'assegnazione del report
  FutureOr<void> assignReport({
    required Report report,
    required String operatorId,
  }) async {
    // Mostra il caricamento solo per la tile corrente
    state = const AsyncLoading();

    final currentUser = ref.read(authRepositoryProvider).currentUser!;

    state = await AsyncValue.guard(
      () async {
        // Chiama il backend per assegnare il report
        await ref.read(reportsRepositoryProvider).assignReportToOperator(
              currentUser: currentUser,
              reportId: report.id,
            );

        // Notifica il controller della lista che il report è stato aggiornato
        ref.read(reportsListControllerProvider.notifier).updateReportInList(
              report.copyWith(
                assignedTo: operatorId,
                status: ReportStatus.assigned,
              ),
            );

        // Una volta completato, rimuovi lo stato di caricamento
        return;
      },
    );
  }

  // Gestisci la disassegnazione del report
  FutureOr<void> unassignReport(Report report) async {
    // Mostra il caricamento solo per la tile corrente
    state = const AsyncLoading();

    final currentUser = ref.read(authRepositoryProvider).currentUser!;

    state = await AsyncValue.guard(
      () async {
        // Chiama il backend per disassegnare il report
        await ref.read(reportsRepositoryProvider).unassignReportFromOperator(
              currentUser: currentUser,
              reportId: report.id,
            );

        // Notifica il controller della lista che il report è stato aggiornato
        ref.read(reportsListControllerProvider.notifier).updateReportInList(
              report.copyWith(
                assignedTo: '', // Nessun operatore assegnato
                status: ReportStatus.opened, // Cambia lo stato a 'opened'
              ),
            );

        // Una volta completato, rimuovi lo stato di caricamento
        return;
      },
    );
  }

  // Gestisci l'eliminazione del report
  FutureOr<void> deleteReport(Report report) async {
    // Mostra il caricamento solo per la tile corrente
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        // Chiama il backend per eliminare il report
        await ref.read(reportsRepositoryProvider).deleteReport(report.id);

        // Notifica il controller della lista che il report è stato rimosso
        ref.read(reportsListControllerProvider.notifier).updateReportInList(
              report.copyWith(
                status: ReportStatus.deleted, // Cambia lo stato a 'deleted'
              ),
            );

        // Una volta completato, rimuovi lo stato di caricamento
        return;
      },
    );
  }
  // TODO: check why missing animation after dismissing
}
