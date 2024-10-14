import 'package:building_report_system/src/features/reporting/data/reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/domain/user_profile.dart';

part 'create_report_screen_controller.g.dart';

@riverpod
class CreateReportScreenController extends _$CreateReportScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> addReport({
    required UserProfile userProfile,
    required String buildingId,
    required String title,
    required String description,
    required List<String> photoUrls,
  }) async {
    state = const AsyncValue.loading();
    try {
      final reportsRepository = ref.read(reportsRepositoryProvider);
      await reportsRepository.addReport(
        userProfile: userProfile,
        buildingId: buildingId,
        title: title,
        description: description,
        photoUrls: photoUrls,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
