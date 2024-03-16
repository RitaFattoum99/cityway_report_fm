// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int status;
  UserData data;
  String message;

  User({
    required this.status,
    required this.data,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        data: UserData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class UserData {
  int? id;
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  String? token;

  UserData({
    this.id,
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
    this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      token: json["token"],
      password: json["password"],
      confirmPassword: json["password_confirmation"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "token": token,
        "password": password,
        "password_confirmation": confirmPassword,
      };
}
