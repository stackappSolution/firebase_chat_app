import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  double multicastId;
  int success;
  int failure;
  int canonicalIds;
  List<Result> results;

  NotificationModel({
    required this.multicastId,
    required this.success,
    required this.failure,
    required this.canonicalIds,
    required this.results,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    multicastId: json["multicast_id"]?.toDouble(),
    success: json["success"],
    failure: json["failure"],
    canonicalIds: json["canonical_ids"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "multicast_id": multicastId,
    "success": success,
    "failure": failure,
    "canonical_ids": canonicalIds,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}


class Result {
  String messageId;

  Result({
    required this.messageId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    messageId: json["message_id"],
  );

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
  };
}
