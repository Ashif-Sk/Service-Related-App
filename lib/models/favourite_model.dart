class FavouriteModel{
  final String contractorId;
  final String serviceId;
  final String imagePath;
  final int price;
  final String name;
  final double rating;
  final String address;

  FavouriteModel({
    required this.contractorId,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.address,
  });

  Map<String,dynamic> toJson (){
    return {
      "contractorId": contractorId,
      "serviceId": serviceId,
      "name" : name,
      "price" : price,
      "rating" : rating,
      "imagePath" : imagePath,
      "address" : address,
    };
  }

  factory FavouriteModel.fromJson (Map<String,dynamic> json){
    return FavouriteModel(
        contractorId: json["contractorId"],
        serviceId: json["serviceId"],
        name: json["name"],
        price: json["price"],
        rating: json["rating"],
        imagePath: json["imagePath"],
        address: json["address"],
    );
  }
}