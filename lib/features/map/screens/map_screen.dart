import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/repositories/spots_repository.dart';
import 'package:pawcity/services/freeroute_service.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

final _spotsProvider = FutureProvider<List<Spot>>((ref) async {
  return SpotsRepository().fetchSpots();
});

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  String _selectedCategory = 'All';
  LatLng _currentLocation = const LatLng(28.6139, 77.2090); // Default: Delhi
  bool _locationLoaded = false;
  bool _loadingLocation = true;

  Spot? _selectedSpot;
  DirectionsResult? _directionsResult;
  bool _loadingDirections = false;

  final TextEditingController _searchController = TextEditingController();
  List<GeocodingResult> _searchResults = [];
  bool _showSearchResults = false;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loadingLocation = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _loadingLocation = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        _locationLoaded = true;
        _loadingLocation = false;
      });
      _mapController.move(_currentLocation, 14);
    } catch (_) {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _getDirectionsTo(Spot spot) async {
    setState(() {
      _selectedSpot = spot;
      _loadingDirections = true;
      _directionsResult = null;
    });

    final result = await FreeRouteService.instance.getDirections(
      waypoints: [
        _currentLocation,
        LatLng(spot.lat, spot.lng),
      ],
    );

    setState(() {
      _directionsResult = result;
      _loadingDirections = false;
    });

    if (result != null && result.polylinePoints.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(result.polylinePoints);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
      );
    }
  }

  void _clearDirections() {
    setState(() {
      _selectedSpot = null;
      _directionsResult = null;
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await FreeRouteService.instance.geocodeSearch(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _showSearchResults = results.isNotEmpty;
        });
      }
    });
  }

  void _selectSearchResult(GeocodingResult result) {
    if (result.position == null) return;
    setState(() {
      _showSearchResults = false;
      _searchController.clear();
      _currentLocation = result.position!;
    });
    _mapController.move(result.position!, 16);
  }

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(_spotsProvider);
    final categories = [
      _CatDef('All', Icons.apps_rounded, context.colors.secondary),
      _CatDef('Park', Icons.park_rounded, context.colors.park),
      _CatDef('Vet', Icons.local_hospital_rounded, context.colors.vet),
      _CatDef('Restaurant', Icons.restaurant_rounded, context.colors.restaurant),
      _CatDef('Grooming', Icons.content_cut_rounded, context.colors.grooming),
      _CatDef('Pet Store', Icons.store_rounded, context.colors.petStore),
      _CatDef('Boarding', Icons.home_rounded, context.colors.boarding),
    ];

    return PawScaffold(
      title: 'Paws Explore',
      currentNavIndex: 2,
      showBottomNav: true,
      showBackButton: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
            child: _buildSearchBar(context),
          ),
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = categories[i];
                final isSelected = _selectedCategory == c.label;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedCategory = c.label;
                    _clearDirections();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? c.color : context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      border: Border.all(
                        color: isSelected ? c.color : context.colors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: c.color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icon, size: 16, color: isSelected ? Colors.white : c.color),
                        const SizedBox(width: 6),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : context.colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation,
                      initialZoom: 13,
                      onTap: (_, __) => _clearDirections(),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.pawcity.app',
                        maxZoom: 19,
                      ),
                      if (_directionsResult != null &&
                          _directionsResult!.polylinePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _directionsResult!.polylinePoints,
                              color: context.colors.primary,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                      spotsAsync.when(
                        loading: () => const MarkerLayer(markers: []),
                        error: (_, __) => const MarkerLayer(markers: []),
                        data: (spots) {
                          final filtered = _selectedCategory == 'All'
                              ? spots
                              : spots
                                  .where((s) => s.category.label == _selectedCategory)
                                  .toList();
                          return MarkerLayer(
                            markers: [
                              if (_locationLoaded)
                                Marker(
                                  point: _currentLocation,
                                  width: 24,
                                  height: 24,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.colors.secondary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6)],
                                    ),
                                  ),
                                ),
                              ...filtered.map(
                                (spot) => Marker(
                                  point: LatLng(spot.lat, spot.lng),
                                  width: 36,
                                  height: 42,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedSpot = spot),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _selectedSpot?.id == spot.id
                                            ? context.colors.primary
                                            : _catColor(spot.category),
                                        shape: BoxShape.circle,
                                        boxShadow: AppEffects.softShadow,
                                      ),
                                      child: Icon(
                                        _catIcon(spot.category),
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (_showSearchResults)
                  Positioned(
                    top: 0,
                    left: AppSizes.md,
                    right: AppSizes.md,
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      constraints: const BoxConstraints(maxHeight: 240),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        boxShadow: AppEffects.softShadow,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(AppSizes.sm),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final r = _searchResults[i];
                          return ListTile(
                            dense: true,
                            leading: Icon(Icons.place_rounded, size: 18, color: context.colors.primary),
                            title: Text(r.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            onTap: () => _selectSearchResult(r),
                          );
                        },
                      ),
                    ),
                  ),
                if (_loadingLocation)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x44FFFFFF),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (_locationLoaded)
                  Positioned(
                    bottom: _selectedSpot != null ? 180 : 24,
                    right: 16,
                    child: FloatingActionButton.small(
                      heroTag: 'recenter',
                      backgroundColor: context.colors.surfaceContainerLowest,
                      onPressed: () => _mapController.move(_currentLocation, 14),
                      child: Icon(Icons.my_location_rounded, color: context.colors.secondary, size: 20),
                    ),
                  ),
                if (_selectedSpot != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildSpotDetailsPanel(_selectedSpot!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Search for parks, clinics, grooming...',
          hintStyle: TextStyle(fontSize: 14, color: context.colors.outline),
          prefixIcon: Icon(Icons.search_rounded, size: 20, color: context.colors.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                      _showSearchResults = false;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSpotDetailsPanel(Spot spot) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 200) {
          _clearDirections();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xl),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.md),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _catColor(spot.category).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: Center(
                    child: Icon(
                      _catIcon(spot.category),
                      color: _catColor(spot.category),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _catColor(spot.category).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              spot.category.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _catColor(spot.category),
                              ),
                            ),
                          ),
                          if (spot.rating > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              spot.rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _clearDirections,
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            if (spot.address != null) ...[
              const SizedBox(height: AppSizes.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: context.colors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      spot.address!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _loadingDirections ? null : () => _getDirectionsTo(spot),
                    icon: _loadingDirections
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.directions_rounded),
                    label: Text(_directionsResult != null ? 'Recalculate' : 'Get Directions'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                  ),
                ),
              ],
            ),
            if (_directionsResult != null) ...[
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: context.colors.primary.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.directions_walk_rounded, color: context.colors.primary),
                    const SizedBox(width: AppSizes.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_directionsResult!.distanceText} (${_directionsResult!.durationText})',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.colors.primary,
                          ),
                        ),
                        Text(
                          'Estimated arrival time: ${DateTime.now().add(const Duration(minutes: 15)).hour}:${DateTime.now().add(const Duration(minutes: 15)).minute}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _catColor(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => context.colors.restaurant,
        SpotCategory.park => context.colors.park,
        SpotCategory.vet => context.colors.vet,
        SpotCategory.grooming => context.colors.grooming,
        SpotCategory.boarding => context.colors.boarding,
        SpotCategory.petStore => context.colors.petStore,
        _ => context.colors.secondary,
      };

  IconData _catIcon(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => Icons.restaurant_rounded,
        SpotCategory.park => Icons.park_rounded,
        SpotCategory.vet => Icons.local_hospital_rounded,
        SpotCategory.grooming => Icons.content_cut_rounded,
        SpotCategory.boarding => Icons.home_rounded,
        SpotCategory.petStore => Icons.store_rounded,
        _ => Icons.place_rounded,
      };
}

class _CatDef {
  const _CatDef(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}
