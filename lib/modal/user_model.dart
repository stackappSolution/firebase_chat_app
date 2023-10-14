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
  String? pin;
  List? blockedNumbers;
  String? wallpaper;
  String? colorCode;
  String? bubbleColor;

  UserModel({
    this.pin,
    this.firstName,
    this.lastName,
    this.id,
    this.phone,
    this.fcmToken,
    this.photoUrl,
    this.about,
    this.blockedNumbers,
    this.wallpaper,
    this.colorCode,
    this.bubbleColor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        phone: json["phone"],
        fcmToken: json["fcmToken"],
        photoUrl: json["photoUrl"],
        about: json["about"],
        pin: json["pin"],
    blockedNumbers: json["blockedNumbers"],
    wallpaper:  json["wallpaper"],
    colorCode:  json["colorCode"],
    bubbleColor:  json["bubbleColor"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "id": id,
        "phone": phone,
        "fcmToken": fcmToken,
        "photoUrl": photoUrl,
        "about": about,
        "pin": pin,
        "blockedNumbers": blockedNumbers,
        "wallpaper": wallpaper,
        "colorCode": colorCode,
        "bubbleColor": bubbleColor,
      };
}
