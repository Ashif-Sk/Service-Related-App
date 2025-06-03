class ChatRoomModel{
  final String chatRoomId;
  List<String> users;
  final String lastMessage;
  final bool isTyping;
  final DateTime timeStamp;

  ChatRoomModel({
    required this.chatRoomId,
    required this.users,
    required this.lastMessage,
    required this.timeStamp,
     this.isTyping = false,
  });

  Map<String,dynamic> toJson (){
    return {
      "chatRoomId" : chatRoomId,
      "users": users,
      "lastMessage" : lastMessage,
      "timeStamp" : timeStamp.toIso8601String(),
      "isTyping" : isTyping,
    };
  }

  factory ChatRoomModel.fromJson (Map<String,dynamic> json){
    return ChatRoomModel(
      chatRoomId: json["chatRoomId"],
      users: json["users"],
      lastMessage: json["lastMessage"],
      timeStamp: DateTime.parse(json["timeStamp"]),
      isTyping: json["isTyping"],
    );
  }
}