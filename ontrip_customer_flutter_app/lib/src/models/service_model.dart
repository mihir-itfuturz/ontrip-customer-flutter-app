class ServiceModel {
  final String title;
  final String description;
  final String? image;
  final String id;

  ServiceModel({
    required this.title,
    required this.description,
    required this.image,
    required this.id,
  });

  ServiceModel copyWith({
    String? title,
    String? description,
    String? image,
    String? id,
  }) =>
      ServiceModel(
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        id: id ?? this.id,
      );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        title: json["title"],
        description: json["description"],
        image: json["image"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "image": image,
        "_id": id,
      };
}
