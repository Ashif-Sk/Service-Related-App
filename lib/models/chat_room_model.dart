
import 'package:cloud_firestore/cloud_firestore.dart';

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
      "timeStamp" : Timestamp.fromDate(timeStamp),
      "isTyping" : isTyping,
    };
  }

  factory ChatRoomModel.fromJson (Map<String,dynamic> json){
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e.toString()).toList(), // Cast users correctly
      lastMessage: json['lastMessage'] as String,
      isTyping: json['isTyping'] as bool,
      timeStamp: json['timeStamp'] is Timestamp
          ? (json['timeStamp'] as Timestamp).toDate()  // Convert Timestamp to DateTime
          : DateTime.now(),
    );
  }
}