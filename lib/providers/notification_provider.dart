import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class NotificationProvider extends ChangeNotifier {
  // All notifications will be stored here
  final List<Map<String, dynamic>> _notifications = [];
  int _lastSeenCount = 0; // ✅ Track how many user has seen
  int _lastNotifiedCount = 0;
  List<Map<String, dynamic>> get allNotifications => _notifications;

  bool get hasUnseenNotifications => _notifications.length > _lastSeenCount;

  void markAllSeen() {
    _lastSeenCount = _notifications.length;
    notifyListeners();
  }


  /// Add a new game notification with a timestamp
  void addGameNotification(Map<String, dynamic> notification) {
    final newNotification = {
      ...notification,
      'time': DateTime.now().toIso8601String(), // store real timestamp
    };

    _notifications.insert(0, newNotification);
    _lastNotifiedCount++;
    notifyListeners();
  }

  int get unseenCount => _notifications.length - _lastSeenCount;

  bool get shouldTriggerSound => _notifications.length > _lastNotifiedCount;

  void updateLastNotifiedCount() {
    _lastNotifiedCount = _notifications.length;
  }

  /// Delete a notification at global index
  void removeNotificationByTime(String time) {
    _notifications.removeWhere((n) => n['time'] == time);
    notifyListeners();
  }


  /// Returns a map grouped by 'Today', 'Yesterday', 'Earlier'
  Map<String, List<Map<String, dynamic>>> get groupedNotifications {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    for (var notification in _notifications) {
      final notifTime = DateTime.tryParse(notification['time']);
      if (notifTime == null) continue;

      final notifDate = DateFormat('yyyy-MM-dd').format(notifTime);

      if (notifDate == today) {
        grouped['Today']!.add(notification);
      } else if (notifDate == yesterday) {
        grouped['Yesterday']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    return grouped;
  }

  bool isUnseenNotification(Map<String, dynamic> notification) {
    final index = _notifications.indexWhere((n) => n['time'] == notification['time']);
    return index >= 0 && index < (_notifications.length - _lastSeenCount);
  }

}

String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} hr ago';
  if (diff.inDays == 1) return 'Yesterday';
  return '${diff.inDays} days ago';
}

