class BusinessSubscriptionModel {
  final String? paymentId;
  final String? paymentReference;
  final DateTime? joinDate;
  final DateTime? endDate;

  BusinessSubscriptionModel({
    this.paymentId,
    this.paymentReference,
    this.joinDate,
    this.endDate,
  });

  factory BusinessSubscriptionModel.fromJson(Map<String, dynamic> json) => BusinessSubscriptionModel(
        paymentId: json["paymentId"],
        paymentReference: json["paymentReference"],
        joinDate: json["joinDate"] == null ? null : DateTime.parse(json["joinDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "paymentReference": paymentReference,
        "joinDate": joinDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      };
}
