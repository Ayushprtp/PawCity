import 'package:latlong2/latlong.dart';

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