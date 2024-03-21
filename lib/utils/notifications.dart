import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _initializeNotificationPlugin() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(String name, String body) async {
  // Create notification details with desired customization
  const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
        'main_channel',
        channelDescription: "todoList",
        importance: Importance.max,
        priority: Priority.max,
        "name",
        largeIcon: DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher',
        )),
  );

  // Show the notification immediately
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (unique for each notification)
    name, // Title
    body, // Body text
    notificationDetails,
  );
}
