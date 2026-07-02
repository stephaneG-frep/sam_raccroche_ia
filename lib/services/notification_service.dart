import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  Future<void> showIncomingAlert(String number, String action) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'call_alerts',
        'Alertes appels',
        channelDescription: 'Notifications anti-demarchage',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(1001, 'Sam Raccroche IA', '$number : $action', details);
  }
}
