class SendMessageModel {
  final String? type;
  final List? members;
  final String? message;
  final String? sender;
  final String? text;
  final bool? isGroup;

  SendMessageModel({
    this.type,
    this.members,
    this.message,
    this.sender,
    this.isGroup,
    this.text,
  });

  // Create a factory constructor to convert JSON to a Message object.
  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      type: json['type'],
      members: json['members'],
      message: json['message'],
      sender: json['sender'],
      text: json['text'],
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
      'text': text,
      'isGroup': isGroup,
    };
  }
}
