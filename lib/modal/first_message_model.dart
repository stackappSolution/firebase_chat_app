class FirstMessageModel {
  final String? type;
  final String? createdBy;
  final String? profile;
  final String? groupName;
  final List<dynamic>? members;
  final String? message;
  final String? sender;
  final bool? isGroup;

  FirstMessageModel({
    this.type,
    this.createdBy,
    this.profile,
    this.groupName,
    this.members,
    this.message,
    this.sender,
    this.isGroup,
  });

  // Create a factory constructor to convert JSON to a ChatMessage object.
  factory FirstMessageModel.fromJson(Map<String, dynamic> json) {
    return FirstMessageModel(
      type: json['type'],
      createdBy: json['createdBy'],
      profile: json['profile'],
      groupName: json['groupName'],
      members: json['members'],
      message: json['message'],
      sender: json['sender'],
      isGroup: json['isGroup'],
    );
  }

  // Create a method to convert the ChatMessage object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'createdBy': createdBy,
      'profile': profile,
      'groupName': groupName,
      'members': members,
      'message': message,
      'sender': sender,
      'isGroup': isGroup,
    };
  }
}
