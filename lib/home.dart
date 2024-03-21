import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_project/main.dart';
import 'package:task_project/services/login.dart';
import 'package:task_project/utils/notifications.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? token;
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
  }

  getDeviceToken() {
    if (token != null) {
      Login().getDeviceToken();
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              showNotification('Test', 'Test Body');
            },
            child: const Text('Show Notification')),
      ),
    );
  }
}
