import 'package:stacked/stacked.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'booking', 'payment', 'reminder', 'general'
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

class NotificationViewModel extends BaseViewModel {
  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  bool get hasNotifications => _notifications.isNotEmpty;

  void initialize() {
    setBusy(true);
    // TODO: Fetch notifications from API or local storage
    // For now, using empty list as mentioned by user
    _notifications = [];
    setBusy(false);
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // TODO: Update read status in backend/storage
      notifyListeners();
    }
  }

  void markAllAsRead() {
    // TODO: Update all notifications as read in backend/storage
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    // TODO: Delete from backend/storage
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    // TODO: Clear all from backend/storage
    notifyListeners();
  }
}
