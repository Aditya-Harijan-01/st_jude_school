
class StudentAttendanceSummaryResponse {
  final String? statusCode;
  final String? message;
  final Data? data;
  final dynamic data1;

  StudentAttendanceSummaryResponse({
    this.statusCode,
    this.message,
    this.data,
    this.data1,
  });

  factory StudentAttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceSummaryResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "data1": data1,
      };
}

class Data {
  final StudentAttendanceSummaryInfo? studentAddtendanceSummeryInfo;
  final List<MonthWiseBreakdown>? monthWiseBreakdown;
  final List<WeekStatus>? weekStatus;

  Data({
    this.studentAddtendanceSummeryInfo,
    this.monthWiseBreakdown,
    this.weekStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      studentAddtendanceSummeryInfo: json['studentAddtendanceSummeryInfo'] != null
          ? StudentAttendanceSummaryInfo.fromJson(json['studentAddtendanceSummeryInfo'])
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
        "studentAddtendanceSummeryInfo": studentAddtendanceSummeryInfo?.toJson(),
        "monthWiseBreakdown": monthWiseBreakdown?.map((e) => e.toJson()).toList(),
        "weekStatus": weekStatus?.map((e) => e.toJson()).toList(),
      };
}

class StudentAttendanceSummaryInfo {
  final String? currentDate;
  final String? currentDay;
  final int? totalDay;
  final int? totalPresent;
  final int? totalAbsent;
  final double? presentPer;
  final double? absentPer;
  final int? sid;

  StudentAttendanceSummaryInfo({
    this.currentDate,
    this.currentDay,
    this.totalDay,
    this.totalPresent,
    this.totalAbsent,
    this.presentPer,
    this.absentPer,
    this.sid,
  });

  factory StudentAttendanceSummaryInfo.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceSummaryInfo(
      currentDate: json['currentDate'],
      currentDay: json['currentDay'],
      totalDay: json['totalDay'],
      totalPresent: json['totalPresent'],
      totalAbsent: json['totalAbsent'],
      presentPer: json['presentPer']?.toDouble(),
      absentPer: json['absentPer']?.toDouble(),
      sid: json['sid'],
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
        "sid": sid,
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