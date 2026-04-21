class BusinessDocumentModel {
  final String? gstNo;
  final String? companyPan;
  final String? personalPan;

  BusinessDocumentModel({
    this.gstNo,
    this.companyPan,
    this.personalPan,
  });

  factory BusinessDocumentModel.fromJson(Map<String, dynamic> json) => BusinessDocumentModel(
        gstNo: json["gstNo"],
        companyPan: json["companyPAN"],
        personalPan: json["personalPAN"],
      );

  Map<String, dynamic> toJson() => {
        "gstNo": gstNo,
        "companyPAN": companyPan,
        "personalPAN": personalPan,
      };
}
