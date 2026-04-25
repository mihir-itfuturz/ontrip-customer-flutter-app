

class ReviewResponse {
  final List<Review>? reviews;
  final String? avgPackageRating;
  final String? avgOverallRating;
  final int? total;

  ReviewResponse({this.reviews, this.avgPackageRating, this.avgOverallRating, this.total});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        reviews: json["reviews"] == null ? null : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        avgPackageRating: json["avgPackageRating"]?.toString(),
        avgOverallRating: json["avgOverallRating"]?.toString(),
        total: json["total"],
      );
}

class Review {
  final String? id;
  final String? customerName;
  final double? packageRating;
  final double? overallRating;
  final String? comment;
  final DateTime? createdAt;

  Review({this.id, this.customerName, this.packageRating, this.overallRating, this.comment, this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        customerName: json["customer"] is Map ? json["customer"]["name"] : (json["customerName"] ?? "User"),
        packageRating: (json["packageRating"] ?? 0.0).toDouble(),
        overallRating: (json["overallRating"] ?? 0.0).toDouble(),
        comment: json["comment"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );
}
