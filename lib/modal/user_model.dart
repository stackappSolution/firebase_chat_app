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
  String? about;
  List<String>? blockedNumbers;
  String? pin;

  UserModel({
    this.pin,
    this.firstName,
    this.lastName,
    this.id,
    this.phone,
    this.fcmToken,
    this.photoUrl,
    this.about,
    this.blockedNumbers
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        phone: json["phone"],
        fcmToken: json["fcmToken"],
        photoUrl: json["photoUrl"],
        about: json["about"],
    blockedNumbers: json["blockedNumbers"],
        pin: json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "id": id,
        "phone": phone,
        "fcmToken": fcmToken,
        "photoUrl": photoUrl,
        "about": about,
        "blockedNumbers": blockedNumbers,
        "pin": pin,
      };
}
