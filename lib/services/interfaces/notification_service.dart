abstract class NotificationService {
  Future<void> listenNotifications();
  Future<String> getToken();
}
