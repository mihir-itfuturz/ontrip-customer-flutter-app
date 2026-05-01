class APIResponse {
  final dynamic message;
  final dynamic data;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final int? status;
  final bool? success;
  final Map<String, dynamic>?
  fullResponse; // Store full response for access to success field

  APIResponse({
    this.message,
    this.data,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.status,
    this.success,
    this.fullResponse,
  });

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    int? parseStatus(dynamic s) {
      if (s == null) return null;
      if (s is int) return s;
      if (s is String) return int.tryParse(s);
      return null;
    }

    return APIResponse(
      message: json['message'],
      data: json['data'] ?? json['result'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      status: parseStatus(json['status']),
      success: json['success'],
      fullResponse: json, // Store full response
    );
  }
}
