import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/domain/building.dart';
import '../../data/reports_repository.dart';
import '../../domain/report.dart';
import 'filters_controllers.dart';

part 'reports_list_controller.g.dart';

@riverpod
class ReportsListController extends _$ReportsListController {
  late List<Report> _allReports = [];

  @override
  FutureOr<List<Report>> build() async {
    if (_allReports.isEmpty) {
      _allReports = await ref.watch(reportsListFutureProvider.future);
    }
    return _applyLocalFilters();
  }

  bool _filterByBuilding(Report report, Building? selectedBuilding) {
    return selectedBuilding == null || report.building.id == selectedBuilding.id;
  }

  bool _filterByStatus(Report report, bool showCompleted, bool showDeleted) {
    switch (report.status) {
      case ReportStatus.completed:
        return showCompleted;
      case ReportStatus.deleted:
        return showDeleted;
      default:
        return true;
    }
  }

  List<Report> _applyLocalFilters() {
    final showCompleted = ref.watch(showCompletedFilterProvider);
    final showDeleted = ref.watch(showDeletedFilterProvider);
    final reverseOrder = ref.watch(reverseOrderFilterProvider);
    final selectedBuilding = ref.watch(selectedBuildingFilterProvider);

    List<Report> filteredReports = _allReports
        .where((report) => _filterByBuilding(report, selectedBuilding))
        .where((report) => _filterByStatus(report, showCompleted, showDeleted))
        .toList();

    // Ordina i report per data di creazione
    filteredReports.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Inverte l'ordine se il filtro reverseOrder è attivo
    if (reverseOrder) {
      filteredReports = filteredReports.reversed.toList();
    }

    state = AsyncData(filteredReports);
    return filteredReports;
  }

// Metodo per refreshare la lista dei report richiamando il backend
  Future<void> refreshReports() async {
    // Ottieni la repository dei report
    final reportsRepository = ref.watch(reportsRepositoryProvider);

    // Imposta lo stato in AsyncLoading per indicare il caricamento
    state = const AsyncLoading();

    // Carica i report dal backend e aggiorna lo stato
    state = await AsyncValue.guard(() async {
      // Recupera i nuovi report dal backend
      _allReports = await reportsRepository.fetchReportsList();

      // Applica i filtri aggiornati e ritorna la lista filtrata
      return _applyLocalFilters();
    });
  }

  // Metodo per aggiungere un nuovo report alla lista
  void addReportToList(Report newReport) {
    _allReports = [..._allReports, newReport];
    _applyLocalFilters(); // Applica i filtri per aggiornare lo stato
  }

// Metodo per aggiornare lo stato di un singolo report nella lista
  void updateReportInList(Report updatedReport) {
    _allReports = _allReports.map((report) {
      return report.id == updatedReport.id ? updatedReport : report;
    }).toList();

    _applyLocalFilters(); // Applica i filtri per aggiornare lo stato
  }
}
