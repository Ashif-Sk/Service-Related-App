class UserModel {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String imagePath;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> favourite;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.imagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.favourite,
  });

  Map<String,dynamic> toJson (){
    return {
      "userId": userId,
      "name" : name,
      "phone" : phone,
      "email" : email,
      "imagePath" : imagePath,
      "address" : address,
      "latitude" : latitude,
      "longitude" : longitude,
      "favourite" : favourite

    };
  }

  factory UserModel.fromJson (Map<String,dynamic> json){
    return UserModel(
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        imagePath: json["imagePath"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        favourite: List<String>.from(json["favourite"] ?? [])
    );
  }
}
