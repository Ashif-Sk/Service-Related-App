import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  final String senderId;
  final String message;
  final DateTime timeStamp;
  final String messageType;

  MessageModel({
    required this.senderId,
    required this.messageType,
    required this.timeStamp,
    required this.message,
  });

  Map<String,dynamic> toJson (){
    return {
      "senderId": senderId,
      "messageType" : messageType,
      "timeStamp" : Timestamp.fromDate(timeStamp),
      "message" : message,
    };
  }

  factory MessageModel.fromJson (Map<String,dynamic> json){
    return MessageModel(
      senderId: json["senderId"],
      messageType: json["messageType"],
      timeStamp: json["timeStamp"] is Timestamp ? (json["timeStamp"] as Timestamp).toDate():DateTime.now(),
      message: json["message"],
    );
  }
}