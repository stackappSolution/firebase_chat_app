// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String firstName;
  String lastName;
  String id;
  String phone;
  String fcmToken;
  String photoUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.phone,
    required this.fcmToken,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    lastName: json["lastName"],
    id: json["id"],
    phone: json["phone"],
    fcmToken: json["fcmToken"],
    photoUrl: json["photoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "id": id,
    "phone": phone,
    "fcmToken": fcmToken,
    "photoUrl": photoUrl,
  };
}
