

class ReviewResponse {
  final List<Review>? reviews;
  final ReviewSummary? summary;

  ReviewResponse({this.reviews, this.summary});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        reviews: json["reviews"] == null ? null : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        summary: json["summary"] == null ? null : ReviewSummary.fromJson(json["summary"]),
      );
}

class ReviewSummary {
  final double? averageRating;
  final int? totalReviews;

  ReviewSummary({this.averageRating, this.totalReviews});

  factory ReviewSummary.fromJson(Map<String, dynamic> json) => ReviewSummary(
        averageRating: (json["averageRating"] ?? 0.0).toDouble(),
        totalReviews: json["totalReviews"] ?? 0,
      );
}

class Review {
  final String? id;
  final String? customer;
  final String? customerName;
  final double? rating;
  final String? comment;
  final DateTime? createdAt;

  Review({this.id, this.customer, this.customerName, this.rating, this.comment, this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        customer: json["customer"],
        customerName: json["customerName"],
        rating: (json["rating"] ?? 0.0).toDouble(),
        comment: json["comment"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      );
}
