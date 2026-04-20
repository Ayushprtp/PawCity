import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/app_notification.dart';
import 'package:pawcity/repositories/notification_repository.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider =
    FutureProvider<List<AppNotification>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.fetchNotifications();
});

final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.fetchUnreadCount();
});
