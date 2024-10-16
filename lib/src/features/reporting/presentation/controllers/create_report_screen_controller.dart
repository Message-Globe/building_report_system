import 'package:building_report_system/src/features/reporting/domain/report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/data/auth_repository.dart';
import '../../data/reports_repository.dart';

part 'create_report_screen_controller.g.dart';

@riverpod
class CreateReportScreenController extends _$CreateReportScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> addReport({
    required String buildingId,
    required String buildingSpot,
    required PriorityLevel priority,
    required String title,
    required String description,
    required List<String> photoUrls,
  }) async {
    state = const AsyncValue.loading();
    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final reportsRepository = ref.read(reportsRepositoryProvider);
    state = await AsyncValue.guard(
      () => reportsRepository.addReport(
        userId: userProfile.appUser.uid,
        buildingId: buildingId,
        buildingSpot: buildingSpot,
        priority: priority,
        title: title,
        description: description,
        photoUrls: photoUrls,
      ),
    );
  }
}
