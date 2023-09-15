class SendMessageModel {
  final String? type;
  final List? members;
  final String? message;
  final String? sender;
  final bool? isGroup;

  SendMessageModel({
    this.type,
    this.members,
    this.message,
    this.sender,
    this.isGroup,
  });

  // Create a factory constructor to convert JSON to a Message object.
  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      type: json['type'],
      members: json['members'],
      message: json['message'],
      sender: json['sender'],
      isGroup: json['isGroup'],
    );
  }

  // Create a method to convert the Message object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'members': members,
      'message': message,
      'sender': sender,
      'isGroup': isGroup,
    };
  }
}
