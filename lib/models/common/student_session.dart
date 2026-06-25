class SessionResponse {
  final String statusCode;
  final String? message;
  final SessionMainData? data;
  final dynamic data1;

  SessionResponse({
    required this.statusCode,
    this.message,
    this.data,
    this.data1,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
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
  final StudentInfo? studentInfo;
  final List<SessionData> sessionInfo;

  SessionMainData({
    this.studentInfo,
    required this.sessionInfo,
  });

  factory SessionMainData.fromJson(Map<String, dynamic> json) {
    return SessionMainData(
      studentInfo: json['student_info'] != null
          ? StudentInfo.fromJson(json['student_info'])
          : StudentInfo.fromJson(json['employeeInfo']),
      sessionInfo:json['session_info'] != null
      ? (json['session_info'] as List<dynamic>? ?? [])
          .map((e) => SessionData.fromJson(e))
          .toList()
          :
        (json['sessionModelEmployee'] as List<dynamic>? ?? [])
            .map((e) => SessionData.fromJson(e))
            .toList(),

    );
  }

  Map<String, dynamic> toJson() => {
        'student_info': studentInfo?.toJson(),
        'session_info': sessionInfo.map((e) => e.toJson()).toList(),
      };
}

class StudentInfo {
  final String name;
  final String designation;
  StudentInfo({required this.name, required this.designation});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(name: json['name'] ?? '', designation: json['designation'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class SessionData {
  final String fromYear;
  final String toYear;
  final String className;
  final String section;
  final String stream;

  SessionData({
    required this.fromYear,
    required this.toYear,
    required this.className,
    required this.section,
    required this.stream,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
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
