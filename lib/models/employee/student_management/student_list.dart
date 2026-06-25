class Student {
  final String sid;
  final String regno;
  final String studentName;
  final String rollNo;
  final String fromYear;
  final String toYear;

  Student({
    required this.sid,
    required this.regno,
    required this.studentName,
    required this.rollNo,
    required this.fromYear,
    required this.toYear,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      studentName: json['student_name'] ?? '',
      rollNo: json['roll_no'] ?? '',
      fromYear: json['fromyear'] ?? '',
      toYear: json['toyear'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'regno': regno,
      'student_name': studentName,
      'roll_no': rollNo,
      'fromyear': fromYear,
      'toyear': toYear,
    };
  }

  @override
  String toString() {
    return 'Student{sid: $sid, regno: $regno, studentName: $studentName, rollNo: $rollNo, fromYear: $fromYear, toYear: $toYear}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.sid == sid &&
        other.regno == regno &&
        other.studentName == studentName &&
        other.rollNo == rollNo &&
        other.fromYear == fromYear &&
        other.toYear == toYear;
  }

  @override
  int get hashCode {
    return sid.hashCode ^
    regno.hashCode ^
    studentName.hashCode ^
    rollNo.hashCode ^
    fromYear.hashCode ^
    toYear.hashCode;
  }
}

class StudentListResponse {
  final String statusCode;
  final List<Student> data;

  StudentListResponse({
    required this.statusCode,
    required this.data,
  });

  factory StudentListResponse.fromJson(Map<String, dynamic> json) {
    return StudentListResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Student.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((student) => student.toJson()).toList(),
    };
  }

  bool get isSuccess => statusCode.toLowerCase() == 'success';

  @override
  String toString() {
    return 'StudentListResponse{statusCode: $statusCode, data: ${data.length} students}';
  }
}