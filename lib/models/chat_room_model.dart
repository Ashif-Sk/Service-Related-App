class ChatRoomModel{
  final String chatRoomId;
  final String userId;
  final String receiverId;
  final String profileImage;
  final String receiverName;
  final String lastMessage;
  final bool isTyping;
  final DateTime timeStamp;

  ChatRoomModel({
    required this.chatRoomId,
    required this.userId,
    required this.receiverId,
    required this.receiverName,
    required this.profileImage,
    required this.lastMessage,
    required this.timeStamp,
     this.isTyping = false,
  });

  Map<String,dynamic> toJson (){
    return {
      "chatRoomId" : chatRoomId,
      "userId": userId,
      "receiverId" : receiverId,
      "lastMessage" : lastMessage,
      "receiverName" : receiverName,
      "profileImage" : profileImage,
      "timeStamp" : timeStamp.toIso8601String(),
      "isTyping" : isTyping,
    };
  }

  factory ChatRoomModel.fromJson (Map<String,dynamic> json){
    return ChatRoomModel(
      chatRoomId: json["chatRoomId"],
      userId: json["userId"],
      receiverId: json["receiverId"],
      receiverName: json["receiverName"],
      profileImage: json["profileImage"],
      lastMessage: json["lastMessage"],
      timeStamp: DateTime.parse(json["timeStamp"]),
      isTyping: json["isTyping"],
    );
  }
}