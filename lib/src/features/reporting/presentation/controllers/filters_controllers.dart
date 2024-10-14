import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filters_controllers.g.dart';

@riverpod
class ShowworkedFilter extends _$ShowworkedFilter {
  @override
  bool build() {
    return false;
  }

  void update(bool newState) {
    state = newState;
  }
}

@riverpod
class ShowDeletedFilter extends _$ShowDeletedFilter {
  @override
  bool build() {
    return false;
  }

  void update(bool newState) {
    state = newState;
  }
}

@riverpod
class ReverseOrderFilter extends _$ReverseOrderFilter {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

@riverpod
class SelectedBuildingFilter extends _$SelectedBuildingFilter {
  @override
  String? build() {
    return null;
  }

  void update(String? buildingId) {
    state = buildingId;
  }
}
