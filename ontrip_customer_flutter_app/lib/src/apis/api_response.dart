class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;

  ApiResponse({required this.status, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(status: json['status'] ?? 0, message: json['message'] ?? '', data: json['data']);
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message, 'data': data};
}
