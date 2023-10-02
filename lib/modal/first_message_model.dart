class SendMessageModel {
  final String? type;
  final List<dynamic>? members;
  final String? message;
  final String? sender;
  final String? text;
  final String? thumb;
  final bool? isGroup;
  final String? createdBy;
  final String? profile;
  final String? groupName;

  SendMessageModel({
    this.type,
    this.members,
    this.message,
    this.sender,
    this.isGroup,
    this.text,
    this.thumb,
    this.createdBy,
    this.profile,
    this.groupName,
  });

  // Create a factory constructor to convert JSON to a Message object.
  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      type: json['type'],
      members: json['members'],
      message: json['message'],
      sender: json['sender'],
      text: json['text'],
      thumb: json['thumb'],
      isGroup: json['isGroup'],
      createdBy: json['createdBy'],
      profile: json['profile'],
      groupName: json['groupName'],
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
      'thumb': thumb,
      'isGroup': isGroup,
      'createdBy': createdBy,
      'profile': profile,
      'groupName': groupName,
    };
  }
}
