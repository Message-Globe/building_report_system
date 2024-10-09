// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_reports_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportsRepositoryHash() => r'ddd742f97f4f741cfa3066e341be3fd6bfb3721f';

/// See also [reportsRepository].
@ProviderFor(reportsRepository)
final reportsRepositoryProvider =
    AutoDisposeProvider<FakeReportsRepository>.internal(
  reportsRepository,
  name: r'reportsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReportsRepositoryRef = AutoDisposeProviderRef<FakeReportsRepository>;
String _$reportsListFutureHash() => r'5fa9185dc8dd5d92f3cffd3fd44dce0ea06a9476';

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
    bool showCompleted = false,
    bool showDeleted = false,
    bool reverseOrder = false,
  }) {
    return ReportsListFutureProvider(
      showCompleted: showCompleted,
      showDeleted: showDeleted,
      reverseOrder: reverseOrder,
    );
  }

  @override
  ReportsListFutureProvider getProviderOverride(
    covariant ReportsListFutureProvider provider,
  ) {
    return call(
      showCompleted: provider.showCompleted,
      showDeleted: provider.showDeleted,
      reverseOrder: provider.reverseOrder,
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
    bool showCompleted = false,
    bool showDeleted = false,
    bool reverseOrder = false,
  }) : this._internal(
          (ref) => reportsListFuture(
            ref as ReportsListFutureRef,
            showCompleted: showCompleted,
            showDeleted: showDeleted,
            reverseOrder: reverseOrder,
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
          showCompleted: showCompleted,
          showDeleted: showDeleted,
          reverseOrder: reverseOrder,
        );

  ReportsListFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.showCompleted,
    required this.showDeleted,
    required this.reverseOrder,
  }) : super.internal();

  final bool showCompleted;
  final bool showDeleted;
  final bool reverseOrder;

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
        showCompleted: showCompleted,
        showDeleted: showDeleted,
        reverseOrder: reverseOrder,
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
        other.showCompleted == showCompleted &&
        other.showDeleted == showDeleted &&
        other.reverseOrder == reverseOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, showCompleted.hashCode);
    hash = _SystemHash.combine(hash, showDeleted.hashCode);
    hash = _SystemHash.combine(hash, reverseOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsListFutureRef on AutoDisposeFutureProviderRef<List<Report>> {
  /// The parameter `showCompleted` of this provider.
  bool get showCompleted;

  /// The parameter `showDeleted` of this provider.
  bool get showDeleted;

  /// The parameter `reverseOrder` of this provider.
  bool get reverseOrder;
}

class _ReportsListFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<Report>>
    with ReportsListFutureRef {
  _ReportsListFutureProviderElement(super.provider);

  @override
  bool get showCompleted => (origin as ReportsListFutureProvider).showCompleted;
  @override
  bool get showDeleted => (origin as ReportsListFutureProvider).showDeleted;
  @override
  bool get reverseOrder => (origin as ReportsListFutureProvider).reverseOrder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
