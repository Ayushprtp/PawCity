import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/paw_patrol_report.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PawPatrolRepository {
  PawPatrolRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<PawPatrolReport>> fetchReports({
    ReportStatus? status,
    String? city,
  }) async {
    try {
      var query = _client
          .from('paw_patrol_reports')
          .select('*, profiles!paw_patrol_reports_reporter_id_fkey(display_name, avatar_url)')
          .eq('is_flagged', false);

      if (status != null) {
        query = query.eq('status', status.dbValue);
      }
      if (city != null && city.trim().isNotEmpty) {
        query = query.ilike('city', city.trim());
      }

      final response = await query.order('created_at', ascending: false);
      return (response as List).map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        final profile = map.remove('profiles') as Map<String, dynamic>?;
        if (profile != null) {
          map['reporter_name'] = profile['display_name'];
          map['reporter_avatar_url'] = profile['avatar_url'];
        }
        return PawPatrolReport.fromJson(map);
      }).toList();
    } catch (_) {
      throw const NetworkException('Unable to load reports.');
    }
  }

  Future<PawPatrolReport> fetchReport(String reportId) async {
    try {
      final response = await _client
          .from('paw_patrol_reports')
          .select('*, profiles!paw_patrol_reports_reporter_id_fkey(display_name, avatar_url)')
          .eq('id', reportId)
          .single();
      final map = Map<String, dynamic>.from(response);
      final profile = map.remove('profiles') as Map<String, dynamic>?;
      if (profile != null) {
        map['reporter_name'] = profile['display_name'];
        map['reporter_avatar_url'] = profile['avatar_url'];
      }
      return PawPatrolReport.fromJson(map);
    } catch (_) {
      throw const NetworkException('Unable to load report details.');
    }
  }

  Future<PawPatrolReport> createReport({
    required ReportCategory category,
    required ReportSeverity severity,
    required String title,
    required String description,
    required double lat,
    required double lng,
    required String city,
    String? address,
    List<String>? photoUrls,
    List<String>? videoUrls,
    int? animalCount,
    String? animalDescription,
    bool isAnonymous = false,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final data = <String, dynamic>{
        'reporter_id': userId,
        'category': category.dbValue,
        'severity': severity.name,
        'title': title,
        'description': description,
        'lat': lat,
        'lng': lng,
        'city': city,
        'is_anonymous': isAnonymous,
        if (address != null) 'address': address,
        if (photoUrls != null) 'photo_urls': photoUrls,
        if (videoUrls != null) 'video_urls': videoUrls,
        if (animalCount != null) 'animal_count': animalCount,
        if (animalDescription != null) 'animal_description': animalDescription,
      };

      final response = await _client
          .from('paw_patrol_reports')
          .insert(data)
          .select()
          .single();
      return PawPatrolReport.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to submit report.');
    }
  }

  Future<void> upvoteReport(String reportId) async {
    try {
      await _client.rpc('increment_upvotes', params: {'report_id': reportId});
    } catch (_) {
      // Fallback: direct increment
      try {
        final current = await _client
            .from('paw_patrol_reports')
            .select('upvotes')
            .eq('id', reportId)
            .single();
        await _client.from('paw_patrol_reports').update(
          {'upvotes': (current['upvotes'] as int? ?? 0) + 1},
        ).eq('id', reportId);
      } catch (_) {
        throw const NetworkException('Unable to upvote report.');
      }
    }
  }
}
