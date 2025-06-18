import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String contractorId;
  final String reviewText;
  final double rating;
  final String userId;
  final String userProfileImage;
  final String userName;
  final DateTime reviewDate;

  ReviewModel({
    required this.contractorId,
    required this.reviewText,
    required this.rating,
    required this.userId,
    required this.userProfileImage,
    required this.userName,
    required this.reviewDate,
  });

  Map<String,dynamic> toJson (){
    return {
      "contractorId" : contractorId,
      "reviewText" : reviewText,
      "rating" : rating,
      "userId" : userId,
      "userProfileImage" : userProfileImage,
      "userName" : userName,
      "reviewDate" : Timestamp.fromDate(reviewDate),
    };
  }

  factory ReviewModel.fromJson (Map<String,dynamic> json){
    return ReviewModel(
        contractorId: json["contractorId"],
        reviewText: json["reviewText"],
        rating: json["rating"],
        userId: json["userId"],
        userProfileImage: json["userProfileImage"],
        userName: json["userName"],
        reviewDate: json['timeStamp'] is Timestamp
            ? (json['timeStamp'] as Timestamp).toDate()  // Convert Timestamp to DateTime
            : DateTime.now(),
    );
  }
}
