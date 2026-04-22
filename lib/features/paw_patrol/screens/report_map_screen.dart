import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

/// Report Map — shows paw patrol reports on an interactive OSM map.
class ReportMapScreen extends StatelessWidget {
  const ReportMapScreen({super.key});

  // Sample report locations (replace with real data from Supabase)
  static const _sampleReports = [
    _ReportPin(
      position: LatLng(28.6240, 77.2100),
      severity: _Severity.critical,
      label: 'Injured stray near Connaught Place',
    ),
    _ReportPin(
      position: LatLng(28.6180, 77.2150),
      severity: _Severity.high,
      label: 'Abandoned puppy at Janpath',
    ),
    _ReportPin(
      position: LatLng(28.6100, 77.2050),
      severity: _Severity.medium,
      label: 'Stray cats colony — needs food',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Report Map',
      currentNavIndex: 1,
      body: Column(
        children: [
          // ─── Legend ───
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(AppColors.severityCritical, 'Critical'),
                const SizedBox(width: AppSizes.lg),
                _legendDot(AppColors.severityHigh, 'High'),
                const SizedBox(width: AppSizes.lg),
                _legendDot(AppColors.severityMedium, 'Medium'),
              ],
            ),
          ),
          // ─── Map ───
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(28.6139, 77.2090),
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.pawcity.app',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: _sampleReports.map((report) {
                      return Marker(
                        point: report.position,
                        width: 32,
                        height: 32,
                        child: Tooltip(
                          message: report.label,
                          child: Container(
                            decoration: BoxDecoration(
                              color: report.color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.warning_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ──────────────── Models ────────────────

enum _Severity { critical, high, medium }

class _ReportPin {
  const _ReportPin({
    required this.position,
    required this.severity,
    required this.label,
  });

  final LatLng position;
  final _Severity severity;
  final String label;

  Color get color => switch (severity) {
        _Severity.critical => AppColors.severityCritical,
        _Severity.high => AppColors.severityHigh,
        _Severity.medium => AppColors.severityMedium,
      };
}