import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? firstName;
  String? lastName;
  String? id;
  String? phone;
  String? fcmToken;
  String? photoUrl;

  UserModel({
    this.firstName,
    this.lastName,
    this.id,
    this.phone,
    this.fcmToken,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
