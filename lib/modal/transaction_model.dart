import 'dart:convert';

TransactionsModel transactionFromJson(String str) =>
    TransactionsModel.fromJson(json.decode(str));

String transactionToJson(TransactionsModel data) => json.encode(data.toJson());

class TransactionsModel {
  String? userId;
  String? paymentId;
  String? status;
  double? amount;
  String? time;

  TransactionsModel({
    this.userId,
    this.paymentId,
    this.status,
    this.amount,
    this.time,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
        userId: json["userId"],
        paymentId: json["paymentId"],
        status: json["status"],
        amount: json["amount"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "paymentId": paymentId,
        "status": status,
        "amount": amount,
        "time": time,
      };
}
