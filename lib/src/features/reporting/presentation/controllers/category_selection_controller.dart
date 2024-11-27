import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/reports_repository.dart';

part 'category_selection_controller.g.dart';

@riverpod
class CategorySelectionController extends _$CategorySelectionController {
  @override
  Future<List<String>> build() async {
    try {
      return await ref.read(reportsRepositoryProvider).fetchReportCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
