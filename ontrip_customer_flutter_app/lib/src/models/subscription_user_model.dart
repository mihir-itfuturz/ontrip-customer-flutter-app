class SubscriptionUserModel {
  final String id;
  final String name;
  final String basePrice;
  final String discountOnAddOn;
  final String duration;
  final bool isActive;
  final String razorPayKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionUserModel({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.discountOnAddOn,
    required this.duration,
    required this.isActive,
    required this.razorPayKey,
    required this.createdAt,
    required this.updatedAt,
  });

  SubscriptionUserModel copyWith({
    String? id,
    String? name,
    String? basePrice,
    String? discountOnAddOn,
    String? duration,
    bool? isActive,
    String? razorPayKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      SubscriptionUserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        basePrice: basePrice ?? this.basePrice,
        discountOnAddOn: discountOnAddOn ?? this.discountOnAddOn,
        duration: duration ?? this.duration,
        isActive: isActive ?? this.isActive,
        razorPayKey: razorPayKey ?? this.razorPayKey,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SubscriptionUserModel.fromJson(Map<String, dynamic> json) => SubscriptionUserModel(
        id: json["_id"],
        name: json["name"],
        basePrice: json["basePrice"],
        discountOnAddOn: json["discountOnAddOn"],
        duration: json["duration"],
        isActive: json["isActive"],
        razorPayKey: json["razorPayKey"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "basePrice": basePrice,
        "discountOnAddOn": discountOnAddOn,
        "duration": duration,
        "isActive": isActive,
        "razorPayKey": razorPayKey,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
