import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_project/model/response_model.dart';

//*** IMPORTANT PLEASE READ THE FOLLOWING *****/
//1 - We have to getDevice Token
//2 - Then We have to make login request and if the request is success and login token is not null we get Device token and that's for logging for the first time
//3- If We saved login token in shared preferences, We check if the token we saved in shared preferences is not null and then get Device token and this happens in home screen
//4- We have to turn "allowbackup" in Manifest to false to make sure if We uninstalled the app and installed it to not save token in shared preferences and not return token from fcm
//5- Then When user logs out of the app we make sure to clear login token from shared preferences and token from fcm and make sure fcm not generate another token automatically
//NOTE: This CODE IS NOT FOR TESTING, IT'S A REFERENCE TO THE TASK I AM ASKED TO DO

class Login {
  String? _deviceToken;
  Future<String?> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    if (Platform.isIOS) {
      _deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      _deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (_deviceToken != null) {
      print('--------Device Token---------- ${_deviceToken!}');
    }
    return _deviceToken;
  }

  Future<ResponseModel> login(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('dotenv.env[' "LOGIN_URL" ']!'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{"email": email, "password": password}));
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      ResponseModel responseModel = ResponseModel.fromJson(result);
      if (response.statusCode != 200) {
        throw (response);
      }

      if (responseModel.token != null) {
        getDeviceToken();
        String token = responseModel.token;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var saveLogin = prefs.getBool('saveLogin') ?? false;
        if (saveLogin) {
          prefs.setString("token", token);
        }
      } else {}

      if (result.isEmpty) {
        throw ('Something went wrong');
      }

      return responseModel;
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}

signOut() async {
  final response = await http.post(Uri.parse(''), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if (response.statusCode == 200) {
    sharedPreferences.clear();
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
    await FirebaseMessaging.instance.deleteToken();
  } else {
    throw Exception(jsonDecode(response.body)["message"]);
  }
}
