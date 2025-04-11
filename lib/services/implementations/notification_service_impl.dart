import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/services/interfaces/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  @override
  Future<void> listenNotifications() async {
    FirebaseMessaging.onMessage.listen(_showFlutterNotification);
    await getToken();
    debugPrint('start listening');
  }

  void _showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    debugPrint(notification?.body ?? "");
  }

  @override
  Future<String> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint(token);

    return token ?? '';
  }
}
