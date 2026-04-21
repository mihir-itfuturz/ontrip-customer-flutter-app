class MyProductModel {
  final String name;
  final String description;
  final List<String> images;
  final String id;

  MyProductModel({
    required this.name,
    required this.description,
    required this.images,
    required this.id,
  });

  MyProductModel copyWith({
    String? name,
    String? description,
    List<String>? images,
    String? id,
  }) =>
      MyProductModel(
        name: name ?? this.name,
        description: description ?? this.description,
        images: images ?? this.images,
        id: id ?? this.id,
      );

  factory MyProductModel.fromJson(Map<String, dynamic> json) => MyProductModel(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        images: json['images'] != null ? List<String>.from(json['images'].map((e) => e)) : <String>[],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'images': List<dynamic>.from(images.map((e) => e)),
      };
}
