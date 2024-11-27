// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_team_selection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$maintenanceTeamSelectionControllerHash() =>
    r'ad32a1e6614a6461ac9de39097da5d465d72ba14';

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

abstract class _$MaintenanceTeamSelectionController
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, String>>> {
  late final String reportId;

  FutureOr<List<Map<String, String>>> build(
    String reportId,
  );
}

/// See also [MaintenanceTeamSelectionController].
@ProviderFor(MaintenanceTeamSelectionController)
const maintenanceTeamSelectionControllerProvider =
    MaintenanceTeamSelectionControllerFamily();

/// See also [MaintenanceTeamSelectionController].
class MaintenanceTeamSelectionControllerFamily
    extends Family<AsyncValue<List<Map<String, String>>>> {
  /// See also [MaintenanceTeamSelectionController].
  const MaintenanceTeamSelectionControllerFamily();

  /// See also [MaintenanceTeamSelectionController].
  MaintenanceTeamSelectionControllerProvider call(
    String reportId,
  ) {
    return MaintenanceTeamSelectionControllerProvider(
      reportId,
    );
  }

  @override
  MaintenanceTeamSelectionControllerProvider getProviderOverride(
    covariant MaintenanceTeamSelectionControllerProvider provider,
  ) {
    return call(
      provider.reportId,
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
  String? get name => r'maintenanceTeamSelectionControllerProvider';
}

/// See also [MaintenanceTeamSelectionController].
class MaintenanceTeamSelectionControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        MaintenanceTeamSelectionController, List<Map<String, String>>> {
  /// See also [MaintenanceTeamSelectionController].
  MaintenanceTeamSelectionControllerProvider(
    String reportId,
  ) : this._internal(
          () => MaintenanceTeamSelectionController()..reportId = reportId,
          from: maintenanceTeamSelectionControllerProvider,
          name: r'maintenanceTeamSelectionControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maintenanceTeamSelectionControllerHash,
          dependencies: MaintenanceTeamSelectionControllerFamily._dependencies,
          allTransitiveDependencies: MaintenanceTeamSelectionControllerFamily
              ._allTransitiveDependencies,
          reportId: reportId,
        );

  MaintenanceTeamSelectionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.reportId,
  }) : super.internal();

  final String reportId;

  @override
  FutureOr<List<Map<String, String>>> runNotifierBuild(
    covariant MaintenanceTeamSelectionController notifier,
  ) {
    return notifier.build(
      reportId,
    );
  }

  @override
  Override overrideWith(MaintenanceTeamSelectionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MaintenanceTeamSelectionControllerProvider._internal(
        () => create()..reportId = reportId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        reportId: reportId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MaintenanceTeamSelectionController,
      List<Map<String, String>>> createElement() {
    return _MaintenanceTeamSelectionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenanceTeamSelectionControllerProvider &&
        other.reportId == reportId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reportId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MaintenanceTeamSelectionControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, String>>> {
  /// The parameter `reportId` of this provider.
  String get reportId;
}

class _MaintenanceTeamSelectionControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        MaintenanceTeamSelectionController,
        List<Map<String, String>>> with MaintenanceTeamSelectionControllerRef {
  _MaintenanceTeamSelectionControllerProviderElement(super.provider);

  @override
  String get reportId =>
      (origin as MaintenanceTeamSelectionControllerProvider).reportId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
