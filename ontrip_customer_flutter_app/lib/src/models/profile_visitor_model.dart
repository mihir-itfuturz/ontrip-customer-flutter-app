class ProfileVisitorModel {
  final String name;
  final String email;
  final String mobile;
  final String? message;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileVisitorModel({
    required this.name,
    required this.email,
    required this.mobile,
    this.message,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  ProfileVisitorModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? message,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProfileVisitorModel(
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        message: message ?? this.message,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ProfileVisitorModel.fromJson(Map<String, dynamic> json) => ProfileVisitorModel(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        message: json["message"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "message": message,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
