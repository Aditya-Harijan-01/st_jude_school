class TeacherMarkEntryResponse {
  final String statusCode;
  final int userAccessValue;
  final List<TeacherMarkEntryData> data;

  TeacherMarkEntryResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory TeacherMarkEntryResponse.fromJson(Map<String, dynamic> json) {
    return TeacherMarkEntryResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TeacherMarkEntryData.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'user_access_value': userAccessValue,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  List<TeacherMarkEntryData> get teachingStaff =>
      data.toList();
}

class TeacherMarkEntryData {
  final String empId;
  final String empName;
  final String categoryId;
  final String categoryName;

  TeacherMarkEntryData({
    required this.empId,
    required this.empName,
    required this.categoryId,
    required this.categoryName,
  });

  factory TeacherMarkEntryData.fromJson(Map<String, dynamic> json) {
    return TeacherMarkEntryData(
      empId: json['empid'] ?? '',
      empName: json['emp_name'] ?? '',
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empid': empId,
      'emp_name': empName,
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }

  // bool get isTeachingStaff => categoryId == "17";
}