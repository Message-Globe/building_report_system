import 'package:building_report_system/src/features/authentication/domain/user_profile.dart';
import 'package:building_report_system/src/features/reporting/domain/report.dart';

abstract class ReportsRepository {
  /// Recupera la lista dei report, con filtri per:
  /// - [showCompleted]: mostra report completati
  /// - [showDeleted]: mostra report eliminati
  /// - [reverseOrder]: ordine inverso per data
  /// - [userProfile]: il profilo dell'utente corrente, utilizzato per filtrare i report in base al ruolo
  /// - [buildingId]: opzionale, filtra per edificio specifico
  Future<List<Report>> fetchReportsList({
    required bool showCompleted,
    required bool showDeleted,
    required bool reverseOrder,
    required UserProfile userProfile, // Profilo utente obbligatorio
    String? buildingId, // Filtro opzionale per edificio
  });
}
