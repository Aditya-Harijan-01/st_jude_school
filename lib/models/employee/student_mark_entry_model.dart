class StudentMarkEntryResponse {
  final String statusCode;
  final int userAccessValue;
  final List<StudentMarkEntryData> data;

  StudentMarkEntryResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory StudentMarkEntryResponse.fromJson(Map<String, dynamic> json) {
    return StudentMarkEntryResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StudentMarkEntryData.fromJson(e))
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
}

class StudentMarkEntryData {
  final String empId;
  final String sid;
  final String regno;
  final String studentName;
  final String rollNo;
  final int markId;
  final String mark;
  final String isNumberOnly;
  final String isDisabled;
  final String allowDelete;
  final String fromYear;
  final String toYear;

  StudentMarkEntryData({
    required this.empId,
    required this.sid,
    required this.regno,
    required this.studentName,
    required this.rollNo,
    required this.markId,
    required this.mark,
    required this.isNumberOnly,
    required this.isDisabled,
    required this.allowDelete,
    required this.fromYear,
    required this.toYear,
  });

  factory StudentMarkEntryData.fromJson(Map<String, dynamic> json) {
    return StudentMarkEntryData(
      empId: json['empid'] ?? '',
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      studentName: json['student_name'] ?? '',
      rollNo: json['roll_no'] ?? '',
      markId: json['mark_id'] ?? 0,
      mark: json['mark'] ?? '',
      isNumberOnly: json['is_number_only'] ?? '',
      isDisabled: json['is_disabled'] ?? '',
      allowDelete: json['allow_delete'] ?? '',
      fromYear: json['fromyear'] ?? '',
      toYear: json['toyear'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empid': empId,
      'sid': sid,
      'regno': regno,
      'student_name': studentName,
      'roll_no': rollNo,
      'mark_id': markId,
      'mark': mark,
      'is_number_only': isNumberOnly,
      'is_disabled': isDisabled,
      'allow_delete': allowDelete,
      'fromyear': fromYear,
      'toyear': toYear,
    };
  }
}