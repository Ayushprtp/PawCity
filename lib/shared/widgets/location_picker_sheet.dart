import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/services/freeroute_service.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

/// A full-screen map picker that returns a LatLng + address string.
///
/// Usage:
/// ```dart
/// final result = await LocationPickerSheet.show(context);
/// if (result != null) {
///   print(result.position);  // LatLng
///   print(result.address);   // String?
/// }
/// ```
class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({super.key, this.initialPosition});

  final LatLng? initialPosition;

  /// Shows the picker as a full-screen modal and returns the chosen location.
  static Future<LocationPickerResult?> show(
    BuildContext context, {
    LatLng? initialPosition,
  }) {
    return Navigator.of(context).push<LocationPickerResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            LocationPickerSheet(initialPosition: initialPosition),
      ),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _pickedLocation = const LatLng(28.6139, 77.2090); // Default: Delhi
  String? _address;
  bool _loadingAddress = false;
  bool _loadingLocation = true;

  List<GeocodingResult> _searchResults = [];
  bool _showSearchResults = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _pickedLocation = widget.initialPosition!;
      _loadingLocation = false;
      _reverseGeocode(_pickedLocation);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
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
        _pickedLocation = LatLng(pos.latitude, pos.longitude);
        _loadingLocation = false;
      });
      _mapController.move(_pickedLocation, 15);
      _reverseGeocode(_pickedLocation);
    } catch (_) {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _loadingAddress = true);
    final address = await FreeRouteService.instance.reverseGeocode(pos);
    if (mounted) {
      setState(() {
        _address = address;
        _loadingAddress = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
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
      _pickedLocation = result.position!;
      _address = result.label;
      _showSearchResults = false;
      _searchController.text = result.label;
    });
    _mapController.move(_pickedLocation, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop(LocationPickerResult(
                position: _pickedLocation,
                address: _address,
              ));
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Confirm'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ─── Map ───
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation,
              initialZoom: 15,
              onTap: (_, latlng) {
                setState(() {
                  _pickedLocation = latlng;
                  _showSearchResults = false;
                });
                _reverseGeocode(latlng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pawcity.app',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: context.colors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ─── Search bar ───
          Positioned(
            top: AppSizes.md,
            left: AppSizes.lg,
            right: AppSizes.lg,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 12,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for a place...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg, vertical: AppSizes.md),
                    ),
                  ),
                ),

                // Search results dropdown
                if (_showSearchResults)
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.xs),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 12,
                            offset: Offset(0, 4)),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(AppSizes.sm),
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final result = _searchResults[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.place_rounded,
                              size: 18, color: context.colors.primary),
                          title: Text(result.label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                          onTap: () => _selectSearchResult(result),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // ─── Bottom info bar ───
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                color: context.colors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 16,
                      offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: context.colors.primary, size: 20),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _loadingAddress
                          ? const Text('Getting address...',
                              style: TextStyle(
                                  color: context.colors.onSurfaceVariant,
                                  fontSize: 13))
                          : Text(
                              _address ?? 'Tap on the map to select a location',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                    ),
                  ]),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    '${_pickedLocation.latitude.toStringAsFixed(5)}, ${_pickedLocation.longitude.toStringAsFixed(5)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.colors.outline,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // ─── My location FAB ───
          Positioned(
            bottom: 120,
            right: AppSizes.lg,
            child: FloatingActionButton.small(
              heroTag: 'picker_my_loc',
              backgroundColor: context.colors.surfaceContainerLowest,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location_rounded,
                  color: context.colors.secondary),
            ),
          ),

          // Loading overlay
          if (_loadingLocation)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x44FFFFFF),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

/// The result returned from [LocationPickerSheet.show].
class LocationPickerResult {
  const LocationPickerResult({required this.position, this.address});
  final LatLng position;
  final String? address;
}
