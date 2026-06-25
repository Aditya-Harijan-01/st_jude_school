class ClassWiseStudentListResponse {
  final String statusCode;
  final int userAccessValue;
  final List<ClassWiseStudent> data;

  ClassWiseStudentListResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory ClassWiseStudentListResponse.fromJson(Map<String, dynamic> json) {
    return ClassWiseStudentListResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ClassWiseStudent.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'user_access_value': userAccessValue,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ClassWiseStudent {
  final String sid;
  final String regno;
  final String studentName;
  final String rollno;
  final String phoneNo;

  ClassWiseStudent({
    required this.sid,
    required this.regno,
    required this.studentName,
    required this.rollno,
    required this.phoneNo,
  });

  factory ClassWiseStudent.fromJson(Map<String, dynamic> json) {
    return ClassWiseStudent(
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      studentName: json['student_name'] ?? '',
      rollno: json['rollno'] ?? '',
      phoneNo: json['phone_no'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'regno': regno,
      'student_name': studentName,
      'rollno': rollno,
      'phone_no': phoneNo,
    };
  }
}
