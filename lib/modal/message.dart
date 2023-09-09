// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  String message;
  bool isSender;
  var messageTimestamp;
  String messageType;
  String sender;

  Message({
    required this.message,
    required this.isSender,
    required this.messageTimestamp,
    required this.messageType,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    message: json["message"],
    isSender: json["isSender"],
    messageTimestamp: json["messageTimestamp"],
    messageType: json["messageType"],
    sender: json["sender"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "isSender": isSender,
    "messageTimestamp": messageTimestamp,
    "messageType": messageType,
    "sender": sender,
  };
}
