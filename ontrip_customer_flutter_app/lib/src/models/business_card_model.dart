import '../../app_export.dart';

class BusinessCardModel {
  String id;
  String name;
  ImageModel image;
  List<SocialMediaModel> personalSocialMedia;
  List<SocialMediaModel> companySocialMedia;
  DocumentModel document;
  String theme;
  String role;
  String company;
  String companyAddress;
  String keyword;
  String aboutCompany;
  dynamic businessCategoryId;
  List<SubscriptionModel> subscription;
  MessageModel message;
  BankModel bank;
  String userId;
  String v;
  DateTime createdAt;
  DateTime updatedAt;

  BusinessCardModel({
    required this.id,
    required this.name,
    required this.image,
    required this.personalSocialMedia,
    required this.companySocialMedia,
    required this.document,
    required this.theme,
    required this.role,
    required this.company,
    required this.companyAddress,
    required this.aboutCompany,
    required this.businessCategoryId,
    required this.subscription,
    required this.message,
    required this.bank,
    required this.userId,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.keyword,
  });

  factory BusinessCardModel.fromJson(Map<String, dynamic> json) => BusinessCardModel(
    id: json["_id"],
    name: json["name"],
    image: ImageModel.fromJson(json["image"]),
    personalSocialMedia: List<SocialMediaModel>.from(json["personalSocialMedia"].map((x) => SocialMediaModel.fromJson(x))),
    companySocialMedia: List<SocialMediaModel>.from(json["companySocialMedia"].map((x) => SocialMediaModel.fromJson(x))),
    document: DocumentModel.fromJson(json["document"]),
    theme: json["theme"],
    role: json["role"] ?? "admin",
    company: json["company"],
    companyAddress: json["companyAddress"],
    aboutCompany: json["aboutCompany"],
    businessCategoryId: json["businessCategoryId"],
    subscription: List<SubscriptionModel>.from(json["subscription"].map((x) => SubscriptionModel.fromJson(x))),
    message: MessageModel.fromJson(json["message"]),
    bank: BankModel.fromJson(json["bank"]),
    userId: json["userId"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    keyword: json["keyword"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image.toJson(),
    "personalSocialMedia": List<dynamic>.from(personalSocialMedia.map((x) => x.toJson())),
    "companySocialMedia": List<dynamic>.from(companySocialMedia.map((x) => x.toJson())),
    "document": document.toJson(),
    "theme": theme,
    "role": role,
    "company": company,
    "keyword": keyword,
    "companyAddress": companyAddress,
    "aboutCompany": aboutCompany,
    "businessCategoryId": businessCategoryId,
    "subscription": List<dynamic>.from(subscription.map((x) => x.toJson())),
    "message": message.toJson(),
    "bank": bank.toJson(),
    "userId": userId,
    "__v": v,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class BankModel {
  String accountHolderName;
  String accountNumber;
  String ifscCode;
  String branch;
  String paymentGateWayLink;

  BankModel({required this.accountHolderName, required this.accountNumber, required this.ifscCode, required this.branch, required this.paymentGateWayLink});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      accountHolderName: json["accountHolderName"],
      accountNumber: json["accountNumber"],
      ifscCode: json["ifscCode"],
      branch: json["branch"],
      paymentGateWayLink: json["paymentGateWayLink"],
    );
  }

  Map<String, dynamic> toJson() => {"accountHolderName": accountHolderName, "accountNumber": accountNumber, "ifscCode": ifscCode, "branch": branch, "paymentGateWayLink": paymentGateWayLink};
}

class SocialMediaModel {
  String image;
  String name;
  String link;
  bool visibility;
  bool isDefault;
  String id;

  SocialMediaModel({required this.image, required this.name, required this.link, required this.visibility, required this.isDefault, required this.id});

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(image: json["image"], name: json["name"], link: json["link"], visibility: json["visibility"], isDefault: json["isDefault"], id: json["_id"]);
  }

  Map<String, dynamic> toJson() => {"image": image, "name": name, "link": link, "visibility": visibility, "isDefault": isDefault, "_id": id};
}

class DocumentModel {
  String gstNo;
  String companyPan;
  String personalPan;
  String brochure;

  DocumentModel({required this.gstNo, required this.companyPan, required this.personalPan, required this.brochure});

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(gstNo: json["gstNo"], companyPan: json["companyPAN"], personalPan: json["personalPAN"], brochure: json["brochure"]);

  Map<String, dynamic> toJson() => {"gstNo": gstNo, "companyPAN": companyPan, "personalPAN": personalPan, "brochure": brochure};
}

class ImageModel {
  String profileImage;
  String coverImage;

  ImageModel({required this.profileImage, required this.coverImage});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(profileImage: json["profileImage"], coverImage: json["coverImage"]);

  Map<String, dynamic> toJson() => {"profileImage": profileImage, "coverImage": coverImage};
}

class SubscriptionModel {
  String product;
  String paidAmount;
  String paymentId;
  String paymentReference;
  DateTime joinDate;
  DateTime endDate;
  String id;
  bool? isActive;
  bool? isExpired;

  SubscriptionModel({
    required this.product,
    required this.paidAmount,
    required this.paymentId,
    required this.paymentReference,
    required this.joinDate,
    required this.endDate,
    required this.id,
    required this.isActive,
    required this.isExpired,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    product: json["product"],
    paidAmount: json["paidAmount"],
    paymentId: json["paymentId"],
    paymentReference: json["paymentReference"],
    joinDate: DateTime.parse(json["joinDate"]),
    endDate: DateTime.parse(json["endDate"]),
    id: json["_id"],
    isActive: json["isActive"],
    isExpired: json["isExpired"],
  );

  Map<String, dynamic> toJson() => {
    "product": product,
    "paidAmount": paidAmount,
    "paymentId": paymentId,
    "paymentReference": paymentReference,
    "joinDate": joinDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "_id": id,
    "isActive": isActive,
    "isExpired": isExpired,
  };
}
