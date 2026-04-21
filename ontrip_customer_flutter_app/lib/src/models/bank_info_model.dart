class BankInfoModel {
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? branch;
  final String? paymentGateWayLink;

  BankInfoModel({
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.branch,
    this.paymentGateWayLink,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
        accountHolderName: json["accountHolderName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branch: json["branch"],
        paymentGateWayLink: json["paymentGateWayLink"],
      );

  Map<String, dynamic> toJson() => {
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branch": branch,
        "paymentGateWayLink": paymentGateWayLink,
      };
}
