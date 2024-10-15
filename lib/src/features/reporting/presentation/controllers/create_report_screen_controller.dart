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
    required String title,
    required String description,
    required List<String> photoUrls,
  }) async {
    state = const AsyncValue.loading();

    try {
      final userProfile = ref.watch(authStateProvider).asData!.value!;
      final reportsRepository = ref.read(reportsRepositoryProvider);

      await reportsRepository.addReport(
        userId: userProfile.appUser.uid,
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
