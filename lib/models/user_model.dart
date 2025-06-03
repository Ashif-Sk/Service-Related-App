class UserModel {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String imagePath;
  final String gender;
  final String address;
  final double latitude;
  final double longitude;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.imagePath,
    required this.gender,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String,dynamic> toJson (){
    return {
      "userId": userId,
      "name" : name,
      "phone" : phone,
      "email" : email,
      "imagePath" : imagePath,
      "gender" : gender,
      "address" : address,
      "latitude" : latitude,
      "longitude" : longitude
    };
  }

  factory UserModel.fromJson (Map<String,dynamic> json){
    return UserModel(
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        imagePath: json["imagePath"],
        gender: json["gender"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"]
    );
  }
}
