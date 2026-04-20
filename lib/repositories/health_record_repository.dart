import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/health_record.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthRecordRepository {
  HealthRecordRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<HealthRecord>> fetchRecordsForPet(String petId) async {
    try {
      final response = await _client
          .from('health_records')
          .select()
          .eq('pet_id', petId)
          .order('date', ascending: false);
      return (response as List)
          .cast<Map<String, dynamic>>()
          .map(HealthRecord.fromJson)
          .toList();
    } catch (_) {
      throw const NetworkException('Unable to load health records.');
    }
  }

  Future<HealthRecord> createRecord({
    required String petId,
    required String recordType,
    required String title,
    String? description,
    String? vetName,
    required DateTime date,
    DateTime? nextDueDate,
    String? documentUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        'pet_id': petId,
        'record_type': recordType,
        'title': title,
        'date': date.toIso8601String().split('T').first,
        if (description != null) 'description': description,
        if (vetName != null) 'vet_name': vetName,
        if (nextDueDate != null)
          'next_due_date': nextDueDate.toIso8601String().split('T').first,
        if (documentUrl != null) 'document_url': documentUrl,
      };

      final response =
          await _client.from('health_records').insert(data).select().single();
      return HealthRecord.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to add health record.');
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _client.from('health_records').delete().eq('id', recordId);
    } catch (_) {
      throw const NetworkException('Unable to delete health record.');
    }
  }
}
