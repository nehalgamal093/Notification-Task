import 'package:task_project/model/user_model.dart';

class ResponseModel {
  UserModel user;
  String token;
  String message;
  String id;
  ResponseModel(
      {required this.user,
      required this.token,
      required this.message,
      required this.id});
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        user: UserModel.fromJson(
          json['user'],
        ),
        token: json['token'],
        message: json['message'],
        id: json['_id']);
  }
}
