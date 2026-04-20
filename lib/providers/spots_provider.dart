import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/repositories/spots_repository.dart';

part 'spots_provider.g.dart';

@riverpod
SpotsRepository spotsRepository(SpotsRepositoryRef ref) {
  return SpotsRepository();
}

@riverpod
class Spots extends _$Spots {
  @override
  Future<List<Spot>> build() async {
    final repository = ref.watch(spotsRepositoryProvider);
    return repository.fetchSpots();
  }

  Future<void> refreshAll() async {
    final repository = ref.read(spotsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(repository.fetchSpots);
  }

  Future<void> applyFilters({
    SpotCategory? category,
    String? city,
    String? query,
  }) async {
    final repository = ref.read(spotsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repository.fetchSpots(
        category: category,
        city: city,
        query: query,
      ),
    );
  }
}

@riverpod
Future<List<Spot>> nearbySpots(
  NearbySpotsRef ref, {
  required double lat,
  required double lng,
  int radiusMeters = 5000,
  SpotCategory? category,
}) async {
  final repository = ref.watch(spotsRepositoryProvider);
  return repository.fetchNearbySpots(
    lat: lat,
    lng: lng,
    radiusMeters: radiusMeters,
    category: category,
  );
}
