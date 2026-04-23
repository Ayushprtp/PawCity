import 'package:latlong2/latlong.dart';

class GeocodingResult {
  const GeocodingResult({required this.label, this.position});
  final String label;
  final LatLng? position;

  @override
  String toString() => label;
}