
class EmpAttendanceSummaryResponse {
  final String? statusCode;
  final String? message;
  final Data? data;

  EmpAttendanceSummaryResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmpAttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return EmpAttendanceSummaryResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final EmpAttendanceSummaryInfo? EmpAddtendanceSummeryInfo;
  final List<MonthWiseBreakdown>? monthWiseBreakdown;
  final List<WeekStatus>? weekStatus;

  Data({
    this.EmpAddtendanceSummeryInfo,
    this.monthWiseBreakdown,
    this.weekStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      EmpAddtendanceSummeryInfo: json['employeeAttendanceSummeryInfo'] != null
          ? EmpAttendanceSummaryInfo.fromJson(json['employeeAttendanceSummeryInfo'])
          : null,
      monthWiseBreakdown: (json['monthWiseBreakdown'] as List?)
          ?.map((e) => MonthWiseBreakdown.fromJson(e))
          .toList(),
      weekStatus: (json['weekStatus'] as List?)
          ?.map((e) => WeekStatus.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "employeeAttendanceSummeryInfo": EmpAddtendanceSummeryInfo?.toJson(),
    "monthWiseBreakdown": monthWiseBreakdown?.map((e) => e.toJson()).toList(),
    "weekStatus": weekStatus?.map((e) => e.toJson()).toList(),
  };
}

class EmpAttendanceSummaryInfo {
  final String? currentDate;
  final String? currentDay;
  final int? totalDay;
  final int? totalPresent;
  final int? totalAbsent;
  final double? presentPer;
  final double? absentPer;
  final String? sid;

  EmpAttendanceSummaryInfo({
    this.currentDate,
    this.currentDay,
    this.totalDay,
    this.totalPresent,
    this.totalAbsent,
    this.presentPer,
    this.absentPer,
    this.sid,
  });

  factory EmpAttendanceSummaryInfo.fromJson(Map<String, dynamic> json) {
    return EmpAttendanceSummaryInfo(
      currentDate: json['currentDate'],
      currentDay: json['currentDay'],
      totalDay: json['totalDay'],
      totalPresent: json['totalPresent'],
      totalAbsent: json['totalAbsent'],
      presentPer: json['presentPer']?.toDouble(),
      absentPer: json['absentPer']?.toDouble(),
      sid: json['tid'],
    );
  }

  Map<String, dynamic> toJson() => {
    "currentDate": currentDate,
    "currentDay": currentDay,
    "totalDay": totalDay,
    "totalPresent": totalPresent,
    "totalAbsent": totalAbsent,
    "presentPer": presentPer,
    "absentPer": absentPer,
    "tid": sid,
  };
}

class MonthWiseBreakdown {
  final int? monthNumber;
  final String? monthName;
  final int? totalDays;
  final int? presentDays;
  final int? absentDays;
  final double? presentPercentage;

  MonthWiseBreakdown({
    this.monthNumber,
    this.monthName,
    this.totalDays,
    this.presentDays,
    this.absentDays,
    this.presentPercentage,
  });

  factory MonthWiseBreakdown.fromJson(Map<String, dynamic> json) {
    return MonthWiseBreakdown(
      monthNumber: json['monthNumber'],
      monthName: json['monthName'],
      totalDays: json['totalDays'],
      presentDays: json['presentDays'],
      absentDays: json['absentDays'],
      presentPercentage: json['presentPercentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "monthNumber": monthNumber,
    "monthName": monthName,
    "totalDays": totalDays,
    "presentDays": presentDays,
    "absentDays": absentDays,
    "presentPercentage": presentPercentage,
  };
}

class WeekStatus {
  final String? date;
  final String? dayName;
  final String? status;

  WeekStatus({
    this.date,
    this.dayName,
    this.status,
  });

  factory WeekStatus.fromJson(Map<String, dynamic> json) {
    return WeekStatus(
      date: json['date'],
      dayName: json['dayName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "dayName": dayName,
    "status": status,
  };
}