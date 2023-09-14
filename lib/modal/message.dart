// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  String? message;
  bool isSender;
  var messageTimestamp;
  bool isPlaying;
  bool messageStatus;
  String? messageType;
  String? sender;

  Message({
    this.messageStatus = false,
    this.message,
    this.isSender = false,
    this.messageTimestamp,
    this.messageType,
    this.sender,
    this.isPlaying = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
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
