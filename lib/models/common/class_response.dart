class ClassResponse {
  final String statusCode;
  final int userAccessValue;
  final List<ClassData> data;

  ClassResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory ClassResponse.fromJson(Map<String, dynamic> json) {
    return ClassResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<ClassData>.from(
        json['data'].map((item) => ClassData.fromJson(item)),
      ),
    );
  }
}

class ClassData {
  final String classId;
  final String className;

  ClassData({
    required this.classId,
    required this.className,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      classId: json['classid'],
      className: json['classname'],
    );
  }
}
