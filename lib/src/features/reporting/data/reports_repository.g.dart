// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportsRepositoryHash() => r'b0cb6cda154c6a96e64ce629f5c3c2ccc8e4e395';

/// See also [reportsRepository].
@ProviderFor(reportsRepository)
final reportsRepositoryProvider =
    AutoDisposeProvider<ReportsRepository>.internal(
  reportsRepository,
  name: r'reportsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReportsRepositoryRef = AutoDisposeProviderRef<ReportsRepository>;
String _$reportsListFutureHash() => r'da1d2d515e53b198fc06771a8427ed2208b2664c';

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

/// See also [reportsListFuture].
@ProviderFor(reportsListFuture)
const reportsListFutureProvider = ReportsListFutureFamily();

/// See also [reportsListFuture].
class ReportsListFutureFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [reportsListFuture].
  const ReportsListFutureFamily();

  /// See also [reportsListFuture].
  ReportsListFutureProvider call({
    bool showworked = false,
    bool showDeleted = false,
    bool reverseOrder = false,
    String? buildingId,
  }) {
    return ReportsListFutureProvider(
      showworked: showworked,
      showDeleted: showDeleted,
      reverseOrder: reverseOrder,
      buildingId: buildingId,
    );
  }

  @override
  ReportsListFutureProvider getProviderOverride(
    covariant ReportsListFutureProvider provider,
  ) {
    return call(
      showworked: provider.showworked,
      showDeleted: provider.showDeleted,
      reverseOrder: provider.reverseOrder,
      buildingId: provider.buildingId,
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
  String? get name => r'reportsListFutureProvider';
}

/// See also [reportsListFuture].
class ReportsListFutureProvider
    extends AutoDisposeFutureProvider<List<Report>> {
  /// See also [reportsListFuture].
  ReportsListFutureProvider({
    bool showworked = false,
    bool showDeleted = false,
    bool reverseOrder = false,
    String? buildingId,
  }) : this._internal(
          (ref) => reportsListFuture(
            ref as ReportsListFutureRef,
            showworked: showworked,
            showDeleted: showDeleted,
            reverseOrder: reverseOrder,
            buildingId: buildingId,
          ),
          from: reportsListFutureProvider,
          name: r'reportsListFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsListFutureHash,
          dependencies: ReportsListFutureFamily._dependencies,
          allTransitiveDependencies:
              ReportsListFutureFamily._allTransitiveDependencies,
          showworked: showworked,
          showDeleted: showDeleted,
          reverseOrder: reverseOrder,
          buildingId: buildingId,
        );

  ReportsListFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.showworked,
    required this.showDeleted,
    required this.reverseOrder,
    required this.buildingId,
  }) : super.internal();

  final bool showworked;
  final bool showDeleted;
  final bool reverseOrder;
  final String? buildingId;

  @override
  Override overrideWith(
    FutureOr<List<Report>> Function(ReportsListFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsListFutureProvider._internal(
        (ref) => create(ref as ReportsListFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        showworked: showworked,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: buildingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Report>> createElement() {
    return _ReportsListFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsListFutureProvider &&
        other.showworked == showworked &&
        other.showDeleted == showDeleted &&
        other.reverseOrder == reverseOrder &&
        other.buildingId == buildingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, showworked.hashCode);
    hash = _SystemHash.combine(hash, showDeleted.hashCode);
    hash = _SystemHash.combine(hash, reverseOrder.hashCode);
    hash = _SystemHash.combine(hash, buildingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsListFutureRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `showworked` of this provider.
  bool get showworked;

  /// The parameter `showDeleted` of this provider.
  bool get showDeleted;

  /// The parameter `reverseOrder` of this provider.
  bool get reverseOrder;

  /// The parameter `buildingId` of this provider.
  String? get buildingId;
}

class _ReportsListFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with ReportsListFutureRef {
  _ReportsListFutureProviderElement(super.provider);

  @override
  bool get showworked => (origin as ReportsListFutureProvider).showworked;
  @override
  bool get showDeleted => (origin as ReportsListFutureProvider).showDeleted;
  @override
  bool get reverseOrder => (origin as ReportsListFutureProvider).reverseOrder;
  @override
  String? get buildingId => (origin as ReportsListFutureProvider).buildingId;
}

String _$reportsListStreamHash() => r'9e674c3fa450ee4b59ec327ec0e5bf95d2f0bef5';

/// See also [reportsListStream].
@ProviderFor(reportsListStream)
const reportsListStreamProvider = ReportsListStreamFamily();

/// See also [reportsListStream].
class ReportsListStreamFamily extends Family<AsyncValue<List<Report>>> {
  /// See also [reportsListStream].
  const ReportsListStreamFamily();

  /// See also [reportsListStream].
  ReportsListStreamProvider call({
    bool showworked = false,
    bool showDeleted = false,
    bool reverseOrder = false,
    String? buildingId,
  }) {
    return ReportsListStreamProvider(
      showworked: showworked,
      showDeleted: showDeleted,
      reverseOrder: reverseOrder,
      buildingId: buildingId,
    );
  }

  @override
  ReportsListStreamProvider getProviderOverride(
    covariant ReportsListStreamProvider provider,
  ) {
    return call(
      showworked: provider.showworked,
      showDeleted: provider.showDeleted,
      reverseOrder: provider.reverseOrder,
      buildingId: provider.buildingId,
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
  String? get name => r'reportsListStreamProvider';
}

/// See also [reportsListStream].
class ReportsListStreamProvider
    extends AutoDisposeStreamProvider<List<Report>> {
  /// See also [reportsListStream].
  ReportsListStreamProvider({
    bool showworked = false,
    bool showDeleted = false,
    bool reverseOrder = false,
    String? buildingId,
  }) : this._internal(
          (ref) => reportsListStream(
            ref as ReportsListStreamRef,
            showworked: showworked,
            showDeleted: showDeleted,
            reverseOrder: reverseOrder,
            buildingId: buildingId,
          ),
          from: reportsListStreamProvider,
          name: r'reportsListStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsListStreamHash,
          dependencies: ReportsListStreamFamily._dependencies,
          allTransitiveDependencies:
              ReportsListStreamFamily._allTransitiveDependencies,
          showworked: showworked,
          showDeleted: showDeleted,
          reverseOrder: reverseOrder,
          buildingId: buildingId,
        );

  ReportsListStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.showworked,
    required this.showDeleted,
    required this.reverseOrder,
    required this.buildingId,
  }) : super.internal();

  final bool showworked;
  final bool showDeleted;
  final bool reverseOrder;
  final String? buildingId;

  @override
  Override overrideWith(
    Stream<List<Report>> Function(ReportsListStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsListStreamProvider._internal(
        (ref) => create(ref as ReportsListStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        showworked: showworked,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
        buildingId: buildingId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Report>> createElement() {
    return _ReportsListStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsListStreamProvider &&
        other.showworked == showworked &&
        other.showDeleted == showDeleted &&
        other.reverseOrder == reverseOrder &&
        other.buildingId == buildingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, showworked.hashCode);
    hash = _SystemHash.combine(hash, showDeleted.hashCode);
    hash = _SystemHash.combine(hash, reverseOrder.hashCode);
    hash = _SystemHash.combine(hash, buildingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsListStreamRef on AutoDisposeStreamProviderRef<List<Report>> {
  /// The parameter `showworked` of this provider.
  bool get showworked;

  /// The parameter `showDeleted` of this provider.
  bool get showDeleted;

  /// The parameter `reverseOrder` of this provider.
  bool get reverseOrder;

  /// The parameter `buildingId` of this provider.
  String? get buildingId;
}

class _ReportsListStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Report>>
    with ReportsListStreamRef {
  _ReportsListStreamProviderElement(super.provider);

  @override
  bool get showworked => (origin as ReportsListStreamProvider).showworked;
  @override
  bool get showDeleted => (origin as ReportsListStreamProvider).showDeleted;
  @override
  bool get reverseOrder => (origin as ReportsListStreamProvider).reverseOrder;
  @override
  String? get buildingId => (origin as ReportsListStreamProvider).buildingId;
}

String _$openReportsCountHash() => r'3381314b989ac98eab5bfaf8f5fad591505ba229';

/// See also [openReportsCount].
@ProviderFor(openReportsCount)
final openReportsCountProvider = AutoDisposeFutureProvider<int>.internal(
  openReportsCount,
  name: r'openReportsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$openReportsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OpenReportsCountRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
