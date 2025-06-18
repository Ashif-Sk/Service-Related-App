import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorModel {
  final String contractorId;
  final String serviceId;
  final String name;
  final String phone;
  final String businessName;
  final String subcategory;
  final String cost;
  final String pricingModel;
  final String address;
  final double latitude;
  final double longitude;
  final String experience;
  final String option;
  final String description;
  final String profileImage;
  final List<String> imagePaths;
  final double rating;
  final double totalRatings;
  final DateTime timeStamp;

  ContractorModel({
    required this.contractorId,
    required this.serviceId,
    required this.name,
    required this.phone,
    required this.businessName,
    required this.subcategory,
    required this.cost,
    required this.pricingModel,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.experience,
    required this.option,
    required this.description,
    required this.profileImage,
    required this.imagePaths,
    required this.rating,
    required this.totalRatings,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "contractorId": contractorId,
      "serviceId": serviceId,
      "name": name,
      "phone": phone,
      "businessName": businessName,
      "subcategory": subcategory,
      "cost": cost,
      "pricingModel": pricingModel,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "experience": experience,
      "option": option,
      "description": description,
      "profileImage": profileImage,
      "imagePaths": imagePaths,
      "rating": rating,
      "totalRatings": totalRatings,
      "timeStamp": Timestamp.fromDate(timeStamp),
    };
  }

  factory ContractorModel.fromJson(Map<String, dynamic> json) {
    return ContractorModel(
      contractorId: json["contractorId"],
      serviceId: json["serviceId"],
      name: json["name"],
      phone: json["phone"],
      businessName: json["businessName"],
      subcategory: json["subcategory"],
      cost: json["cost"],
      pricingModel: json["pricingModel"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      experience: json["experience"],
      option: json["option"],
      description: json["description"],
      profileImage: json["profileImage"],
      imagePaths: List<String>.from(json["imagePaths"]),
      rating: json["rating"],
      totalRatings: json["totalRatings"],
      timeStamp: json['timeStamp'] is Timestamp
          ? (json['timeStamp'] as Timestamp).toDate()  // Convert Timestamp to DateTime
          : DateTime.now(),
    );
  }
}
