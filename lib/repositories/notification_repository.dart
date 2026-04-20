import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/app_notification.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  NotificationRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);
      return (response as List)
          .cast<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();
    } catch (_) {
      throw const NetworkException('Unable to load notifications.');
    }
  }

  Future<int> fetchUnreadCount() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);
      return (response as List).length;
    } catch (_) {
      return 0;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
    } catch (_) {
      throw const NetworkException('Unable to mark notification as read.');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _client.auth.currentUser!.id;
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (_) {
      throw const NetworkException('Unable to mark notifications as read.');
    }
  }
}
