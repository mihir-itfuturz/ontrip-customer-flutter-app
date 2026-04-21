class SingleShareCardModel {
  final String id;
  final String name;
  final String mobile;
  final String count;
  final String notes;
  final String businessCardId;
  final String userId;
  final DateTime createdAt;

  SingleShareCardModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.count,
    required this.notes,
    required this.businessCardId,
    required this.userId,
    required this.createdAt,
  });

  factory SingleShareCardModel.fromJson(Map<String, dynamic> json) => SingleShareCardModel(
    id: json["_id"] ?? "",
    name: json["name"] ?? "",
    mobile: json["mobile"] ?? "",
    count: json["count"] ?? "",
    businessCardId: json["businessCardId"],
    userId: json["userId"],
    notes: json["notes"] ?? "",
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "mobile": mobile,
    "count": count,
    "businessCardId": businessCardId,
    "userId": userId,
    "notes": notes,
    "createdAt": createdAt.toIso8601String(),
  };
}
