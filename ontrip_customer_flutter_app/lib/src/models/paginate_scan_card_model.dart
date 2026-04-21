import 'scan_card_model.dart';

class PaginateScanCardModel {
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final List<ScanCardModel> docs;
  final dynamic prevPage;
  final dynamic nextPage;

  PaginateScanCardModel({
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.docs,
    required this.prevPage,
    required this.nextPage,
  });

  factory PaginateScanCardModel.fromJson(Map<String, dynamic> json) => PaginateScanCardModel(
        totalDocs: int.tryParse(json["totalDocs"]) ?? 0,
        limit: int.tryParse(json["limit"]) ?? 0,
        totalPages: int.tryParse(json["totalPages"]) ?? 0,
        page: int.tryParse(json["page"]) ?? 0,
        pagingCounter: int.tryParse(json["pagingCounter"]) ?? 0,
        hasPrevPage: json["hasPrevPage"] ?? false,
        hasNextPage: json["hasNextPage"] ?? false,
        docs: json["docs"] == null ? <ScanCardModel>[] : List<ScanCardModel>.from(json["docs"]!.map((x) => ScanCardModel.fromJson(x))),
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
      };
}
