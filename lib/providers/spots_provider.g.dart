// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spots_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spotsRepositoryHash() => r'545159084a9560bd700d0cf67392270ca68ad5ce';

/// See also [spotsRepository].
@ProviderFor(spotsRepository)
final spotsRepositoryProvider = AutoDisposeProvider<SpotsRepository>.internal(
  spotsRepository,
  name: r'spotsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$spotsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SpotsRepositoryRef = AutoDisposeProviderRef<SpotsRepository>;
String _$nearbySpotsHash() => r'b2e6e79ffaa8e22f3cc008ad651ab3a2d1a6f442';

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

/// See also [nearbySpots].
@ProviderFor(nearbySpots)
const nearbySpotsProvider = NearbySpotsFamily();

/// See also [nearbySpots].
class NearbySpotsFamily extends Family<AsyncValue<List<Spot>>> {
  /// See also [nearbySpots].
  const NearbySpotsFamily();

  /// See also [nearbySpots].
  NearbySpotsProvider call({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    SpotCategory? category,
  }) {
    return NearbySpotsProvider(
      lat: lat,
      lng: lng,
      radiusMeters: radiusMeters,
      category: category,
    );
  }

  @override
  NearbySpotsProvider getProviderOverride(
    covariant NearbySpotsProvider provider,
  ) {
    return call(
      lat: provider.lat,
      lng: provider.lng,
      radiusMeters: provider.radiusMeters,
      category: provider.category,
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
  String? get name => r'nearbySpotsProvider';
}

/// See also [nearbySpots].
class NearbySpotsProvider extends AutoDisposeFutureProvider<List<Spot>> {
  /// See also [nearbySpots].
  NearbySpotsProvider({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    SpotCategory? category,
  }) : this._internal(
          (ref) => nearbySpots(
            ref as NearbySpotsRef,
            lat: lat,
            lng: lng,
            radiusMeters: radiusMeters,
            category: category,
          ),
          from: nearbySpotsProvider,
          name: r'nearbySpotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbySpotsHash,
          dependencies: NearbySpotsFamily._dependencies,
          allTransitiveDependencies:
              NearbySpotsFamily._allTransitiveDependencies,
          lat: lat,
          lng: lng,
          radiusMeters: radiusMeters,
          category: category,
        );

  NearbySpotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lat,
    required this.lng,
    required this.radiusMeters,
    required this.category,
  }) : super.internal();

  final double lat;
  final double lng;
  final int radiusMeters;
  final SpotCategory? category;

  @override
  Override overrideWith(
    FutureOr<List<Spot>> Function(NearbySpotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbySpotsProvider._internal(
        (ref) => create(ref as NearbySpotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lat: lat,
        lng: lng,
        radiusMeters: radiusMeters,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Spot>> createElement() {
    return _NearbySpotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbySpotsProvider &&
        other.lat == lat &&
        other.lng == lng &&
        other.radiusMeters == radiusMeters &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, lng.hashCode);
    hash = _SystemHash.combine(hash, radiusMeters.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NearbySpotsRef on AutoDisposeFutureProviderRef<List<Spot>> {
  /// The parameter `lat` of this provider.
  double get lat;

  /// The parameter `lng` of this provider.
  double get lng;

  /// The parameter `radiusMeters` of this provider.
  int get radiusMeters;

  /// The parameter `category` of this provider.
  SpotCategory? get category;
}

class _NearbySpotsProviderElement
    extends AutoDisposeFutureProviderElement<List<Spot>> with NearbySpotsRef {
  _NearbySpotsProviderElement(super.provider);

  @override
  double get lat => (origin as NearbySpotsProvider).lat;
  @override
  double get lng => (origin as NearbySpotsProvider).lng;
  @override
  int get radiusMeters => (origin as NearbySpotsProvider).radiusMeters;
  @override
  SpotCategory? get category => (origin as NearbySpotsProvider).category;
}

String _$spotsHash() => r'8ad3495e9732caff838d6ee7da50f4f3625e91af';

/// See also [Spots].
@ProviderFor(Spots)
final spotsProvider =
    AutoDisposeAsyncNotifierProvider<Spots, List<Spot>>.internal(
  Spots.new,
  name: r'spotsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$spotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Spots = AutoDisposeAsyncNotifier<List<Spot>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
