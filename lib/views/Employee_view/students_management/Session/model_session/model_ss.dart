class SessionResponseSeconday {
  final String statusCode;
  final String? message;
  final SessionMainData? data;
  final dynamic data1;

  SessionResponseSeconday({
    required this.statusCode,
    this.message,
    this.data,
    this.data1,
  });

  factory SessionResponseSeconday.fromJson(Map<String, dynamic> json) {
    return SessionResponseSeconday(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: json['data'] != null
          ? SessionMainData.fromJson(json['data'])
          : null,
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'data': data?.toJson(),
    'data1': data1,
  };
}

class SessionMainData {
  final StudentInfoSecondary? studentInfo;
  final List<SessionDataSecondary> sessionInfo;

  SessionMainData({
    this.studentInfo,
    required this.sessionInfo,
  });

  factory SessionMainData.fromJson(Map<String, dynamic> json) {
    return SessionMainData(
      studentInfo: json['student_info'] != null
          ? StudentInfoSecondary.fromJson(json['student_info'])
          : StudentInfoSecondary.fromJson(json['employeeInfo']),
      sessionInfo:json['session_info'] != null
          ? (json['session_info'] as List<dynamic>? ?? [])
          .map((e) => SessionDataSecondary.fromJson(e))
          .toList()
          :
      (json['sessionModelEmployee'] as List<dynamic>? ?? [])
          .map((e) => SessionDataSecondary.fromJson(e))
          .toList(),

    );
  }

  Map<String, dynamic> toJson() => {
    'student_info': studentInfo?.toJson(),
    'session_info': sessionInfo.map((e) => e.toJson()).toList(),
  };
}

class StudentInfoSecondary {
  final String name;
  final String designation;
  StudentInfoSecondary({required this.name, required this.designation});

  factory StudentInfoSecondary.fromJson(Map<String, dynamic> json) {
    return StudentInfoSecondary(name: json['name'] ?? '', designation: json['designation'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class SessionDataSecondary {
  final String fromYear;
  final String toYear;
  final String className;
  final String section;
  final String stream;

  SessionDataSecondary({
    required this.fromYear,
    required this.toYear,
    required this.className,
    required this.section,
    required this.stream,
  });

  factory SessionDataSecondary.fromJson(Map<String, dynamic> json) {
    return SessionDataSecondary(
      fromYear: json['fromyear'].toString() != "" ? json['fromyear'].toString()  : '',
      toYear: json['toyear'].toString() != "" ? json['toyear'].toString() : "",
      className: json['classname'].toString() != "" ? json['classname'].toString() : '',
      section: json['section'].toString() != "" ? json['section'].toString() : "",
      stream: json['stream'].toString() != "" ? json['stream'].toString() : "",
    );
  }

  Map<String, dynamic> toJson() => {
    'fromyear': fromYear,
    'toyear': toYear,
    'classname': className,
    'section': section,
    'stream': stream,
  };
}
