import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

final healthServiceProvider = Provider<HealthService>((ref) => HealthService());

class HealthService {
  final Health _health = Health();
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (!_configured) {
      _health.configure();
      _configured = true;
    }
  }

  Future<bool> requestPermissions() async {
    await _ensureConfigured();
    final types = [HealthDataType.DISTANCE_WALKING_RUNNING, HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ];
    
    if (Platform.isAndroid) {
      final activityStatus = await Permission.activityRecognition.request();
      if (activityStatus.isDenied) return false;
      
      final locationStatus = await Permission.location.request();
      if (locationStatus.isDenied) return false;
    }

    try {
      bool? hasPermissions = await _health.hasPermissions(types, permissions: permissions);
      if (hasPermissions != true) {
        hasPermissions = await _health.requestAuthorization(types, permissions: permissions);
      }
      return hasPermissions ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<double> getDistanceWalkedToday() async {
    await _ensureConfigured();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    
    try {
      final types = [HealthDataType.DISTANCE_WALKING_RUNNING];
      final healthData = await _health.getHealthDataFromTypes(startTime: midnight, endTime: now, types: types);
      
      double totalDistance = 0.0;
      for (var d in healthData) {
        final val = double.tryParse(d.value.toString()) ?? 0.0;
        totalDistance += val;
      }
      return totalDistance;
    } catch (e) {
      return 0.0;
    }
  }
}
