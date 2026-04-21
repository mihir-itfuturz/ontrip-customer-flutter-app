class ScannedCardModel {
  final List<ScanCardModel> docs;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final dynamic prevPage;
  final dynamic nextPage;

  ScannedCardModel({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory ScannedCardModel.fromJson(Map<String, dynamic> json) => ScannedCardModel(
        docs: json["docs"] == null ? <ScanCardModel>[] : List<ScanCardModel>.from(json["docs"]!.map((x) => ScanCardModel.fromJson(x))),
        totalDocs: int.tryParse(json["totalDocs"]) ?? 0,
        limit: int.tryParse(json["limit"]) ?? 10,
        totalPages: int.tryParse(json["totalPages"]) ?? 0,
        page: int.tryParse(json["page"]) ?? 0,
        pagingCounter: int.tryParse(json["pagingCounter"]) ?? 0,
        hasPrevPage: json["hasPrevPage"] ?? false,
        hasNextPage: json["hasNextPage"] ?? false,
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class ScanCardModel {
  final String? id;
  final String name;
  final String mobile;
  final String companyEmailId;
  final String companyName;
  final String businessMobile;
  final String address;
  final String businessKeyword;
  final String keywords;
  final String notes;
  final String website;
  final String businessCardId;
  final String? frontImage;
  final String? backImage;
  final String? businessType;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScanCardModel({
    this.id,
    required this.name,
    required this.mobile,
    required this.companyEmailId,
    required this.companyName,
    required this.businessMobile,
    required this.address,
    required this.keywords,
    required this.notes,
    required this.businessCardId,
    required this.website,
    required this.businessKeyword,
    this.frontImage,
    this.backImage,
    this.businessType,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory ScanCardModel.fromJson(Map<String, dynamic> json) => ScanCardModel(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        mobile: json["mobile"] ?? "",
        companyEmailId: json["companyEmailId"] ?? "",
        companyName: json["companyName"] ?? "",
        businessMobile: json["businessMobile"] ?? "",
        address: json["address"] ?? "",
        keywords: json["keywords"] ?? "",
        notes: json["notes"] ?? "",
        website: json["website"] ?? "",
        businessKeyword: json["businessKeyword"] ?? "",
        businessCardId: json["businessCardId"] ?? "",
        frontImage: json["frontImage"],
        backImage: json["backImage"],
        businessType: json["businessType"],
        userId: json["userId"] ?? "",
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mobile": mobile,
        "companyEmailId": companyEmailId,
        "companyName": companyName,
        "businessMobile": businessMobile,
        "address": address,
        "keywords": keywords,
        "notes": notes,
        "website": website,
        "businessKeyword": businessKeyword,
        "businessCardId": businessCardId,
        "userId": userId,
        "frontImage": frontImage,
        "backImage": backImage,
        "businessType": businessType,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
