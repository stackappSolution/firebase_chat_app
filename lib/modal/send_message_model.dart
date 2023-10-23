class SendMessageModel {
  final String? type;
  final List? members;
  final String? message;
  final String? sender;
  final String? text;
  final bool? isGroup;
  final String? emoji;
  final String? messageId;
  final String? createdBy;
  final String? groupName;
  final String? profile;
  final String? thumb;
  final String? repliedText;

  SendMessageModel({
    this.type,
    this.members,
    this.message,
    this.sender,
    this.isGroup,
    this.text,
    this.emoji,
    this.messageId,
    this.createdBy,
    this.groupName,
    this.profile,
    this.thumb,
    this.repliedText
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
        emoji: json['emoji'],
        messageId: json['messageId'],
        createdBy: json['createdBy'],
        groupName: json['groupName'],
        profile: json['profile'],
        thumb: json['thumb'],
        repliedText: json['repliedText']
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
      'emoji': emoji,
      'messageId': messageId,
      'createdBy': createdBy,
      'groupName': groupName,
      'profile': profile,
      'thumb': thumb,
      'repliedText':repliedText
    };
  }
}