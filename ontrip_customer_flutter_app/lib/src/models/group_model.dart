class GroupModel {
  final String id;
  final String totalTasks;
  final String groupName;
  final bool isDefault;

  GroupModel({
    required this.id,
    required this.totalTasks,
    required this.groupName,
    required this.isDefault,
  });

  GroupModel copyWith({
    String? id,
    String? totalTasks,
    String? groupName,
    bool? isDefault,
  }) =>
      GroupModel(
        id: id ?? this.id,
        totalTasks: totalTasks ?? this.totalTasks,
        groupName: groupName ?? this.groupName,
        isDefault: isDefault ?? this.isDefault,
      );

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json["_id"],
        totalTasks: json["totalTasks"],
        groupName: json["groupName"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "totalTasks": totalTasks,
        "groupName": groupName,
        "isDefault": isDefault,
      };
}
