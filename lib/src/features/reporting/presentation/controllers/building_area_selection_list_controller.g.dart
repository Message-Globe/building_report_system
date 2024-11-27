// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_area_selection_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buildingAreaSelectionListControllerHash() =>
    r'bd074aa10a416b6560d25ef80e38868f1f5b70d9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BuildingAreaSelectionListController
    extends BuildlessAutoDisposeAsyncNotifier<BuildingAreaState> {
  late final String buildingId;

  FutureOr<BuildingAreaState> build(
    String buildingId,
  );
}

/// See also [BuildingAreaSelectionListController].
@ProviderFor(BuildingAreaSelectionListController)
const buildingAreaSelectionListControllerProvider =
    BuildingAreaSelectionListControllerFamily();

/// See also [BuildingAreaSelectionListController].
class BuildingAreaSelectionListControllerFamily
    extends Family<AsyncValue<BuildingAreaState>> {
  /// See also [BuildingAreaSelectionListController].
  const BuildingAreaSelectionListControllerFamily();

  /// See also [BuildingAreaSelectionListController].
  BuildingAreaSelectionListControllerProvider call(
    String buildingId,
  ) {
    return BuildingAreaSelectionListControllerProvider(
      buildingId,
    );
  }

  @override
  BuildingAreaSelectionListControllerProvider getProviderOverride(
    covariant BuildingAreaSelectionListControllerProvider provider,
  ) {
    return call(
      provider.buildingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'buildingAreaSelectionListControllerProvider';
}

/// See also [BuildingAreaSelectionListController].
class BuildingAreaSelectionListControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        BuildingAreaSelectionListController, BuildingAreaState> {
  /// See also [BuildingAreaSelectionListController].
  BuildingAreaSelectionListControllerProvider(
    String buildingId,
  ) : this._internal(
          () => BuildingAreaSelectionListController()..buildingId = buildingId,
          from: buildingAreaSelectionListControllerProvider,
          name: r'buildingAreaSelectionListControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$buildingAreaSelectionListControllerHash,
          dependencies: BuildingAreaSelectionListControllerFamily._dependencies,
          allTransitiveDependencies: BuildingAreaSelectionListControllerFamily
              ._allTransitiveDependencies,
          buildingId: buildingId,
        );

  BuildingAreaSelectionListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.buildingId,
  }) : super.internal();

  final String buildingId;

  @override
  FutureOr<BuildingAreaState> runNotifierBuild(
    covariant BuildingAreaSelectionListController notifier,
  ) {
    return notifier.build(
      buildingId,
    );
  }

  @override
  Override overrideWith(BuildingAreaSelectionListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BuildingAreaSelectionListControllerProvider._internal(
        () => create()..buildingId = buildingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        buildingId: buildingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BuildingAreaSelectionListController,
      BuildingAreaState> createElement() {
    return _BuildingAreaSelectionListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BuildingAreaSelectionListControllerProvider &&
        other.buildingId == buildingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, buildingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BuildingAreaSelectionListControllerRef
    on AutoDisposeAsyncNotifierProviderRef<BuildingAreaState> {
  /// The parameter `buildingId` of this provider.
  String get buildingId;
}

class _BuildingAreaSelectionListControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        BuildingAreaSelectionListController,
        BuildingAreaState> with BuildingAreaSelectionListControllerRef {
  _BuildingAreaSelectionListControllerProviderElement(super.provider);

  @override
  String get buildingId =>
      (origin as BuildingAreaSelectionListControllerProvider).buildingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
