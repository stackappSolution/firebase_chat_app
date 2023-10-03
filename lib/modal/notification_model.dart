import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  String? message;
  String? sender;
  String? senderName;
  String? receiver;
  String? receiverName;
  String? time;

  NotificationModel({
    this.message,
    this.sender,
    this.senderName,
    this.receiver,
    this.receiverName,
    this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String timestamp = json["time"];
    String dateTime = timestamp;

    String formattedTime = dateTime;

    return NotificationModel(
      message: json["message"],
      sender: json["sender"],
      senderName: json["senderName"],
      receiver: json["receiver"],
      receiverName: json["receiverName"],
      time: formattedTime,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "sender": sender,
    "senderName": senderName,
    "receiver": receiver,
    "receiverName": receiverName,
    "time": time,
  };
}
