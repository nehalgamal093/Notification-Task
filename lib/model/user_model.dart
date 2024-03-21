class UserModel {
  String email;
  String role;
  String id;
  UserModel({required this.email, required this.role, required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['email'], role: json['role'], id: json['_id']);
  }
}
