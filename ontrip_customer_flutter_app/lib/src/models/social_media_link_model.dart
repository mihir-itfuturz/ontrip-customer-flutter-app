class SocialMediaLinkModel {
  final String? facebook;
  final String? google;
  final String? twitter;
  final String? linkedIn;
  final String? instagram;
  final String? youtube;

  SocialMediaLinkModel({
    this.facebook,
    this.google,
    this.twitter,
    this.linkedIn,
    this.instagram,
    this.youtube,
  });

  factory SocialMediaLinkModel.fromJson(Map<String, dynamic> json) => SocialMediaLinkModel(
        facebook: json["facebook"],
        google: json["google"],
        twitter: json["twitter"],
        linkedIn: json["linkedIn"],
        instagram: json["instagram"],
        youtube: json["youtube"],
      );

  Map<String, dynamic> toJson() => {
        "facebook": facebook,
        "google": google,
        "twitter": twitter,
        "linkedIn": linkedIn,
        "instagram": instagram,
        "youtube": youtube,
      };
}
