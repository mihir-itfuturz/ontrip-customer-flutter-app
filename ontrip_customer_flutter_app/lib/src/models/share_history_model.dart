import 'single_share_card_model.dart';

class ShareHistoryModel {
  final List<SingleShareCardModel> docs;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final dynamic prevPage;
  final dynamic nextPage;

  ShareHistoryModel({
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

  factory ShareHistoryModel.fromJson(Map<String, dynamic> json) => ShareHistoryModel(
        docs: json["docs"] == null ? <SingleShareCardModel>[] : List<SingleShareCardModel>.from(json["docs"]!.map((x) => SingleShareCardModel.fromJson(x))),
        totalDocs: int.tryParse(json["totalDocs"]) ?? 0,
        limit: int.tryParse(json["limit"]) ?? 10,
        totalPages: int.tryParse(json["totalPages"]) ?? 1,
        page: int.tryParse(json["page"]) ?? 1,
        pagingCounter: int.tryParse(json["pagingCounter"]) ?? 1,
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
