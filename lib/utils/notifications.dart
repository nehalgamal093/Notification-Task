import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//To make notification pop up on the screen.
//If you clicked the button show notification in home screen, It will show the pop up notification.

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

  await flutterLocalNotificationsPlugin.show(
    0,
    name,
    body,
    notificationDetails,
  );
}
