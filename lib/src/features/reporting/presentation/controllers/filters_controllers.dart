import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/domain/building.dart';

part 'filters_controllers.g.dart';

@riverpod
class ShowCompletedFilter extends _$ShowCompletedFilter {
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
  Building? build() {
    return null;
  }

  void update(Building? building) {
    state = building;
  }
}
