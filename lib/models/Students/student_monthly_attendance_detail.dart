class StudentMonthlyAttendanceDetailResponse {
  final String? statusCode;
  final String? message;
  final MonthlyAttendanceData? data;
  final dynamic data1;

  StudentMonthlyAttendanceDetailResponse({
    this.statusCode,
    this.message,
    this.data,
    this.data1,
  });

  factory StudentMonthlyAttendanceDetailResponse.fromJson(Map<String, dynamic> json) {
    return StudentMonthlyAttendanceDetailResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? MonthlyAttendanceData.fromJson(json['data']) : null,
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

class MonthlyAttendanceData {
  final List<MonthwiseAttendance>? monthwiseAttendance;
  final List<HolidayDate>? holidayDates;

  MonthlyAttendanceData({
    this.monthwiseAttendance,
    this.holidayDates,
  });

  factory MonthlyAttendanceData.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendanceData(
      monthwiseAttendance: (json['monthwiseAttendance'] as List?)
          ?.map((e) => MonthwiseAttendance.fromJson(e))
          .toList(),
      holidayDates: (json['holidayDates'] as List?)
          ?.map((e) => HolidayDate.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "monthwiseAttendance": monthwiseAttendance?.map((e) => e.toJson()).toList(),
        "holidayDates": holidayDates?.map((e) => e.toJson()).toList(),
      };
}

class MonthwiseAttendance {
  final int? sid;
  final String? fromyear;
  final String? attnDate;
  final int? attendenceType;

  MonthwiseAttendance({
    this.sid,
    this.fromyear,
    this.attnDate,
    this.attendenceType,
  });

  factory MonthwiseAttendance.fromJson(Map<String, dynamic> json) {
    return MonthwiseAttendance(
      sid: json['sid'],
      fromyear: json['fromyear'],
      attnDate: json['attn_date'],
      attendenceType: json['attendenceType'],
    );
  }

  Map<String, dynamic> toJson() => {
        "sid": sid,
        "fromyear": fromyear,
        "attn_date": attnDate,
        "attendenceType": attendenceType,
      };
}

class HolidayDate {
  final String? holidayDate;
  final String? holidayDetails;
  final String? dayName;

  HolidayDate({
    this.holidayDate,
    this.holidayDetails,
    this.dayName,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) {
    return HolidayDate(
      holidayDate: json['holiday_date'],
      holidayDetails: json['holiday_details'],
      dayName: json['day_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "holiday_date": holidayDate,
        "holiday_details": holidayDetails,
        "day_name": dayName,
      };
}