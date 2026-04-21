import 'dart:convert';

OfficeModel officeModelFromJson(String str) => OfficeModel.fromJson(json.decode(str));

String officeModelToJson(OfficeModel data) => json.encode(data.toJson());

class OfficeModel {
  String id;
  String name;
  String address;
  String lat;
  String long;
  String radius;
  String businessCardId;
  bool isActive;
  bool isDeleted;

  OfficeModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.radius,
    required this.businessCardId,
    required this.isActive,
    required this.isDeleted,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
    id: json["_id"],
    name: json["name"],
    address: json["address"],
    lat: json["lat"],
    long: json["long"],
    radius: json["radius"],
    businessCardId: json["businessCardId"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "address": address,
    "lat": lat,
    "long": long,
    "radius": radius,
    "businessCardId": businessCardId,
    "isActive": isActive,
    "isDeleted": isDeleted,
  };
}
