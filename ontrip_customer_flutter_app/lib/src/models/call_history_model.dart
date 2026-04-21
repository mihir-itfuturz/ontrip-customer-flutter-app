class CallHistoryModel {
  final String phoneNumber;
  final String callerName;
  final DateTime callTime;
  final String callType;
  final int durationSeconds;

  CallHistoryModel({required this.phoneNumber, required this.callerName, required this.callTime, required this.callType, this.durationSeconds = 0});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber, 'callerName': callerName, 'callTime': callTime.toIso8601String(), 'callType': callType, 'durationSeconds': durationSeconds};

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) => CallHistoryModel(
    phoneNumber: json['phoneNumber'] ?? '',
    callerName: json['callerName'] ?? '',
    callTime: DateTime.parse(json['callTime']),
    callType: json['callType'] ?? 'incoming',
    durationSeconds: json['durationSeconds'] ?? 0,
  );
}
