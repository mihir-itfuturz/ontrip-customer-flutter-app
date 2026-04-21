class MessageModel {
  String? whatsApp;
  String? email;

  MessageModel({
    this.whatsApp,
    this.email,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        whatsApp: json["whatsApp"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "whatsApp": whatsApp,
        "email": email,
      };
}
