class GroupCategoryResponse {
  final String statusCode;
  final List<GroupCategory> data;

  GroupCategoryResponse({
    required this.statusCode,
    required this.data,
  });

  factory GroupCategoryResponse.fromJson(Map<String, dynamic> json) {
    return GroupCategoryResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => GroupCategory.fromJson(item))
          .toList() ??
      [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class GroupCategory {
  final String groupId;
  final String groupName;

  GroupCategory({
    required this.groupId,
    required this.groupName,
  });

  factory GroupCategory.fromJson(Map<String, dynamic> json) {
    return GroupCategory(
      groupId: json['group_id'] ?? '',
      groupName: json['group_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
    };
  }
}
