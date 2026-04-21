class ProfileImageModel {
  final String? profileImage;
  final String? coverImage;

  ProfileImageModel({
    this.profileImage,
    this.coverImage,
  });

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) => ProfileImageModel(
        profileImage: json["profileImage"],
        coverImage: json["coverImage"],
      );

  Map<String, dynamic> toJson() => {
        "profileImage": profileImage,
        "coverImage": coverImage,
      };
}
