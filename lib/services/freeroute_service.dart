import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// FreeRoute API service — free routing, geocoding & isochrones
/// powered by OpenStreetMap data.
///
/// Base URL: https://api.maps.freeroute.org
/// Auth: X-API-Key header
class FreeRouteService {
  FreeRouteService._();
  static final instance = FreeRouteService._();

  static const _baseUrl = 'https://api.maps.freeroute.org';
  static const _apiKey =
      'fro_d96422feaf61dcf13c98f3b5a8e757c559bbc5c781e18e41a0cbed2ea6d05cd3';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
      };

  // ───────────────────────── Directions ─────────────────────────

  /// Get directions between two or more points.
  ///
  /// [profile] can be: `driving-car`, `foot-walking`, `cycling-regular`
  /// Returns decoded GeoJSON geometry + summary (distance in m, duration in s).
  Future<DirectionsResult?> getDirections({
    required List<LatLng> waypoints,
    String profile = 'driving-car',
  }) async {
    if (waypoints.length < 2) return null;

    final body = jsonEncode({
      'coordinates':
          waypoints.map((p) => [p.longitude, p.latitude]).toList(),
    });

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/v1/directions/$profile'),
        headers: _headers,
        body: body,
      );

      if (res.statusCode != 200) {
        debugPrint('FreeRoute directions error ${res.statusCode}: ${res.body}');
        return null;
      }

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = json['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      final summary = route['summary'] as Map<String, dynamic>?;

      // Decode the polyline geometry
      final geometry = route['geometry'] as String?;
      List<LatLng> polyline = [];
      if (geometry != null) {
        polyline = _decodePolyline(geometry);
      }

      return DirectionsResult(
        polylinePoints: polyline,
        distanceMeters: (summary?['distance'] as num?)?.toDouble() ?? 0,
        durationSeconds: (summary?['duration'] as num?)?.toDouble() ?? 0,
      );
    } catch (e) {
      debugPrint('FreeRoute directions exception: $e');
      return null;
    }
  }

  // ───────────────────────── Geocoding ──────────────────────────

  /// Forward geocode: search places by query string.
  Future<List<GeocodingResult>> geocodeSearch(
    String query, {
    int limit = 5,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/v1/geocode/search').replace(
        queryParameters: {'q': query, 'limit': limit.toString()},
      );

      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>? ?? [];

      return features.map((f) {
        final props = f['properties'] as Map<String, dynamic>? ?? {};
        final coords = (f['geometry']?['coordinates'] as List<dynamic>?) ?? [];
        return GeocodingResult(
          label: props['label'] as String? ?? props['name'] as String? ?? '',
          position: coords.length >= 2
              ? LatLng(
                  (coords[1] as num).toDouble(),
                  (coords[0] as num).toDouble(),
                )
              : null,
        );
      }).toList();
    } catch (e) {
      debugPrint('FreeRoute geocode search exception: $e');
      return [];
    }
  }

  /// Reverse geocode: coordinates → address.
  Future<String?> reverseGeocode(LatLng position) async {
    try {
      final uri = Uri.parse('$_baseUrl/v1/geocode/reverse').replace(
        queryParameters: {
          'lon': position.longitude.toString(),
          'lat': position.latitude.toString(),
        },
      );

      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return null;

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>? ?? [];
      if (features.isEmpty) return null;

      final props =
          features.first['properties'] as Map<String, dynamic>? ?? {};
      return props['label'] as String? ?? props['name'] as String?;
    } catch (e) {
      debugPrint('FreeRoute reverse geocode exception: $e');
      return null;
    }
  }

  // ───────────────────────── Isochrones ─────────────────────────

  /// Calculate reachable area within given time (seconds) or distance (meters).
  Future<List<List<LatLng>>> getIsochrones({
    required LatLng origin,
    required List<int> ranges,
    String rangeType = 'time',
    String profile = 'driving-car',
  }) async {
    try {
      final body = jsonEncode({
        'locations': [
          [origin.longitude, origin.latitude]
        ],
        'range': ranges,
        'range_type': rangeType,
      });

      final res = await http.post(
        Uri.parse('$_baseUrl/v1/isochrones'),
        headers: _headers,
        body: body,
      );

      if (res.statusCode != 200) return [];

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>? ?? [];

      return features.map((f) {
        final coords =
            (f['geometry']?['coordinates']?[0] as List<dynamic>?) ?? [];
        return coords
            .map((c) => LatLng(
                  (c[1] as num).toDouble(),
                  (c[0] as num).toDouble(),
                ))
            .toList();
      }).toList();
    } catch (e) {
      debugPrint('FreeRoute isochrones exception: $e');
      return [];
    }
  }

  // ────────────────────── Polyline Decode ───────────────────────

  /// Decode an encoded polyline string (precision 5) into LatLng points.
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      result = 0;
      shift = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }
}

// ═══════════════════════════ Models ═══════════════════════════

class DirectionsResult {
  const DirectionsResult({
    required this.polylinePoints,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> polylinePoints;
  final double distanceMeters;
  final double durationSeconds;

  String get distanceText {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toInt()} m';
  }

  String get durationText {
    final mins = (durationSeconds / 60).ceil();
    if (mins >= 60) {
      final h = mins ~/ 60;
      final m = mins % 60;
      return '${h}h ${m}m';
    }
    return '$mins min';
  }
}

class GeocodingResult {
  const GeocodingResult({required this.label, this.position});
  final String label;
  final LatLng? position;

  @override
  String toString() => label;
}
