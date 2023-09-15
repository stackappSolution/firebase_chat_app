// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

MessageModel messageFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  String? message;
  bool? isSender;
  final messageTimestamp;
  bool? messageStatus;
  String? messageType;
  String? sender;

  MessageModel({
    this.messageStatus,
    this.message,
    this.isSender,
    this.messageTimestamp,
    this.messageType,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messageStatus: json['messageStatus'],
        message: json["message"],
        isSender: json["isSender"],
        messageTimestamp: json["messageTimestamp"],
        messageType: json["messageType"],
        sender: json["sender"],
      );

  Map<String, dynamic> toJson() => {
        "messageStatus": messageStatus,
        "message": message,
        "isSender": isSender,
        "messageTimestamp": messageTimestamp,
        "messageType": messageType,
        "sender": sender,
      };
}
