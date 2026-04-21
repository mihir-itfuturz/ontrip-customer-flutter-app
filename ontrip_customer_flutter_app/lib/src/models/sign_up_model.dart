class SignUpModel {
  final String token;
  final bool isVerified;
  final String businessCardCount;

  SignUpModel({
    required this.token,
    required this.isVerified,
    required this.businessCardCount,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        token: json["token"],
        isVerified: json["isVerified"] ?? false,
        businessCardCount: json["businessCardCount"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "isVerified": isVerified,
        "businessCardCount": businessCardCount,
      };
}
