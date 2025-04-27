class ReviewModel {
  final String reviewId;
  final String contractorId;
  final String reviewText;
  final double rating;
  final String userId;
  final String userProfileImage;
  final String userName;
  final DateTime reviewDate;

  ReviewModel({
    required this.reviewId,
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
      "reviewId": reviewId,
      "contractorId" : contractorId,
      "reviewText" : reviewText,
      "rating" : rating,
      "userId" : userId,
      "userProfileImage" : userProfileImage,
      "userName" : userName,
      "reviewDate" : reviewDate.toIso8601String(),
    };
  }

  factory ReviewModel.fromJson (Map<String,dynamic> json){
    return ReviewModel(
        reviewId: json["reviewId"],
        contractorId: json["contractorId"],
        reviewText: json["reviewText"],
        rating: json["rating"],
        userId: json["userId"],
        userProfileImage: json["userProfileImage"],
        userName: json["userName"],
        reviewDate: DateTime.parse(json["reviewDate"]),
    );
  }
}
