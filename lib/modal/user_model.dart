import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? firstName;
  String? lastName;
  String? id;
  String? phone;
  String? fcmToken;
  String? photoUrl;
  String? about;

  User({
    this.firstName,
    this.lastName,
    this.id,
    this.phone,
    this.fcmToken,
    this.photoUrl,
    this.about,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    lastName: json["lastName"],
    id: json["id"],
    phone: json["phone"],
    fcmToken: json["fcmToken"],
    photoUrl: json["photoUrl"],
    about: json["about"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "id": id,
    "phone": phone,
    "fcmToken": fcmToken,
    "photoUrl": photoUrl,
    "about": about,
  };
}
