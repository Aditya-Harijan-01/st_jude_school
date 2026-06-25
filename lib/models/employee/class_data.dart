class ClassDataResponse {
  final String statusCode;
  final int userAccessValue;
  final List<ClassItem> data;

  ClassDataResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory ClassDataResponse.fromJson(Map<String, dynamic> json) {
    return ClassDataResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ClassItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'user_access_value': userAccessValue,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ClassItem {
  final String classId;
  final String className;

  ClassItem({
    required this.classId,
    required this.className,
  });

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      classId: json['classid'] ?? '',
      className: json['classname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classid': classId,
      'classname': className,
    };
  }
}
