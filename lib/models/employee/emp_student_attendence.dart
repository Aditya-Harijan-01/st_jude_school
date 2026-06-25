import 'dart:developer';

class SessionDate {
  final String fyStartDate;
  final String fyEndDate;

  SessionDate({
    required this.fyStartDate,
    required this.fyEndDate,
  });

  factory SessionDate.fromJson(Map<String, dynamic> json) {
    return SessionDate(
      fyStartDate: json['fy_start_date']?.toString() ?? '',
      fyEndDate: json['fy_end_date']?.toString() ?? '',
    );
  }

  // Helper method to get start date as DateTime
  DateTime get startDate {
    try {
      // API returns dates in dd-MM-yyyy format (with hyphens)
      String dateStr = fyStartDate;

      // Handle both hyphen and slash formats for backward compatibility
      List<String> parts;
      if (dateStr.contains('-')) {
        parts = dateStr.split('-');
      } else if (dateStr.contains('/')) {
        parts = dateStr.split('/');
      } else {
        throw FormatException('Invalid date format: $dateStr');
      }

      if (parts.length == 3) {
        // parts[0] = day, parts[1] = month, parts[2] = year
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      log('Error parsing start date: $fyStartDate, error: $e');
    }
    // Fallback to current date if parsing fails
    return DateTime.now();
  }

  // Helper method to get end date as DateTime
  DateTime get endDate {
    try {
      // API returns dates in dd-MM-yyyy format (with hyphens)
      String dateStr = fyEndDate;

      // Handle both hyphen and slash formats for backward compatibility
      List<String> parts;
      if (dateStr.contains('-')) {
        parts = dateStr.split('-');
      } else if (dateStr.contains('/')) {
        parts = dateStr.split('/');
      } else {
        throw FormatException('Invalid date format: $dateStr');
      }

      if (parts.length == 3) {
        // parts[0] = day, parts[1] = month, parts[2] = year
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      log('Error parsing end date: $fyEndDate, error: $e');
    }
    // Fallback to current date if parsing fails
    return DateTime.now();
  }

  // Helper method to check if a date is within this session
  bool isDateInSession(DateTime date) {
    final start = startDate;
    final end = endDate;
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  // Helper method to get formatted start date for display
  String get formattedStartDate {
    try {
      final date = startDate;
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return fyStartDate;
    }
  }

  // Helper method to get formatted end date for display
  String get formattedEndDate {
    try {
      final date = endDate;
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return fyEndDate;
    }
  }

  @override
  String toString() {
    return 'SessionDate(start: $fyStartDate, end: $fyEndDate)';
  }
}

class AttendanceClass {
  final String classDisplay;
  final String className;
  final String streamName;
  final String sectionName;
  final String attendanceStatus;
  final String totalStudent;
  final String totalPresent;
  final String totalAbsent;
  final String isDayentry;
  final String fontColor;

  AttendanceClass({
    required this.classDisplay,
    required this.className,
    required this.streamName,
    required this.sectionName,
    required this.attendanceStatus,
    required this.totalStudent,
    required this.totalPresent,
    required this.totalAbsent,
    required this.isDayentry,
    required this.fontColor,
  });

  factory AttendanceClass.fromJson(Map<String, dynamic> json) {
    return AttendanceClass(
      classDisplay: json['class_display']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      streamName: json['stream_name']?.toString() ?? '',
      sectionName: json['section_name']?.toString() ?? '',
      attendanceStatus: json['attendance_status']?.toString() ?? '',
      totalStudent: json['total_student']?.toString() ?? '',
      totalPresent: json['total_present']?.toString() ?? '',
      totalAbsent: json['total_absent']?.toString() ?? '',
      isDayentry: json['is_dayentry']?.toString() ?? '',
      fontColor: json['font_color']?.toString() ?? '',
    );
  }

  bool get isClickable => fontColor == '#00cc44';
  bool get isRestricted => fontColor == '#ff1a1a';
}

class StudentAttendance {
  final String sid;
  final String regno;
  final String rollno;
  final String studentName;
  final String otherRemarks;
  String attendanceType;
  final String rollOrder;
  final String attendanceDate;
  final int isFirst;
  final int isTc;
  final String isDisabled;
  String isChecked;

  StudentAttendance({
    required this.sid,
    required this.regno,
    required this.rollno,
    required this.studentName,
    required this.otherRemarks,
    required this.attendanceType,
    required this.rollOrder,
    required this.attendanceDate,
    required this.isFirst,
    required this.isTc,
    required this.isDisabled,
    required this.isChecked,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      sid: json['sid']?.toString() ?? '',
      regno: json['regno']?.toString() ?? '',
      rollno: json['rollno']?.toString() ?? '',
      studentName: json['student_name']?.toString() ?? '',
      otherRemarks: json['other_remarks']?.toString() ?? '',
      attendanceType: json['attendance_type']?.toString() ?? '0',
      rollOrder: json['roll_order']?.toString() ?? '',
      attendanceDate: json['attendance_date']?.toString() ?? '',
      isFirst: json['is_first'] ?? 0,
      isTc: json['is_tc'] ?? 0,
      isDisabled: json['is_desabled']?.toString() ?? 'No',
      isChecked: json['is_checked']?.toString() ?? 'No',
    );
  }

  bool get isPresent => attendanceType == '1';
  bool get canMarkAttendance => isTc == 0;
  bool get isTransferCertificate => isTc == 1;

  void toggleAttendance() {
    if (canMarkAttendance) {
      attendanceType = attendanceType == '1' ? '0' : '1';
      isChecked = attendanceType == '1' ? 'Yes' : 'No';
    }
  }
}

class ClassListResponse {
  final String statusCode;
  final int userAccessValue;
  final List<AttendanceClass> data;

  ClassListResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory ClassListResponse.fromJson(Map<String, dynamic> json) {
    return ClassListResponse(
      statusCode: json['statusCode']?.toString() ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => AttendanceClass.fromJson(item))
          .toList() ?? [],
    );
  }

  bool get hasAccess => userAccessValue == 0 || userAccessValue == 1;
  bool get isRestricted => userAccessValue == 100;
}

class StudentsResponse {
  final String statusCode;
  final String message;
  final List<StudentAttendance> data;

  StudentsResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    return StudentsResponse(
      statusCode: json['statusCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List?)
          ?.map((item) => StudentAttendance.fromJson(item))
          .toList() ?? [],
    );
  }
}

class AttendanceUpdateResponse {
  final String statusCode;
  final String message;

  AttendanceUpdateResponse({
    required this.statusCode,
    required this.message,
  });

  factory AttendanceUpdateResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceUpdateResponse(
      statusCode: json['statusCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  bool get isSuccess => statusCode.toLowerCase() == 'success';
}
