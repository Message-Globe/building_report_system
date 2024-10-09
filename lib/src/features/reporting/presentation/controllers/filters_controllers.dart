import 'package:riverpod_annotation/riverpod_annotation.dart';

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
