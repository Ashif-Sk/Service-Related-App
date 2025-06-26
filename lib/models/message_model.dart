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
      "timeStamp" : timeStamp.toIso8601String(),
      "message" : message,
    };
  }

  factory MessageModel.fromJson (Map<String,dynamic> json){
    return MessageModel(
      senderId: json["senderId"],
      messageType: json["messageType"],
      timeStamp: DateTime.parse(json["timeStamp"]),
      message: json["message"],
    );
  }
}