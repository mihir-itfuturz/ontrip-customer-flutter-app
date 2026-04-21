class TaskModel {
  final List<SingleTaskModel> today;
  final List<SingleTaskModel> tomorrow;
  final List<SingleTaskModel> someday;
  final List<SingleTaskModel> customDate;

  TaskModel({
    required this.today,
    required this.tomorrow,
    required this.someday,
    required this.customDate,
  });

  TaskModel copyWith({
    String? id,
    List<SingleTaskModel>? today,
    List<SingleTaskModel>? tomorrow,
    List<SingleTaskModel>? someday,
    List<SingleTaskModel>? customDate,
  }) =>
      TaskModel(
        today: today ?? this.today,
        tomorrow: tomorrow ?? this.tomorrow,
        someday: someday ?? this.someday,
        customDate: customDate ?? this.customDate,
      );

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        today: List<SingleTaskModel>.from(json["today"].map((x) => SingleTaskModel.fromJson(x))),
        tomorrow: List<SingleTaskModel>.from(json["tomorrow"].map((x) => SingleTaskModel.fromJson(x))),
        someday: List<SingleTaskModel>.from(json["someday"].map((x) => SingleTaskModel.fromJson(x))),
        customDate: List<SingleTaskModel>.from(json["customDate"].map((x) => SingleTaskModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "today": List<dynamic>.from(today.map((x) => x.toJson())),
        "tomorrow": List<dynamic>.from(tomorrow.map((x) => x.toJson())),
        "someday": List<dynamic>.from(someday.map((x) => x.toJson())),
        "customDate": List<dynamic>.from(customDate.map((x) => x.toJson())),
      };
}

class SingleTaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? taskDate;
  final String calendarIntegration;

  SingleTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.taskDate,
    required this.calendarIntegration,
  });

  SingleTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? taskDate,
    String? calendarIntegration,
  }) =>
      SingleTaskModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        taskDate: taskDate ?? this.taskDate,
        calendarIntegration: calendarIntegration ?? this.calendarIntegration,
      );

  factory SingleTaskModel.fromJson(Map<String, dynamic> json) => SingleTaskModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        taskDate: json["taskDate"] != null ? DateTime.tryParse(json["taskDate"]) : null,
        calendarIntegration: json["calendarIntegration"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "taskDate": taskDate?.toIso8601String(),
        "calendarIntegration": calendarIntegration,
      };
}
