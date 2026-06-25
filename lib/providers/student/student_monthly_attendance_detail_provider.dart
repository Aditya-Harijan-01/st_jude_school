import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_monthly_attendance_detail.dart';
import '../common/common_post_method.dart';

class StudentMonthlyAttendanceDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentMonthlyAttendanceDetailResponse? monthlyAttendanceDetail;

  int get totalPresentDays {
    final attendances =
        monthlyAttendanceDetail?.data?.monthwiseAttendance;
    if (attendances == null || attendances.isEmpty) return 0;

    return attendances
        .where((item) => item.attendenceType == 1)
        .length;
  }


  Future<bool> getStudentMonthwiseAttendanceDetail({
    required String regno,
    required String fromyear,
    required String toyear,
    required String monthid, // 1-12
  }) async {
    isLoading = true;
    notifyListeners();

    const String endpoint = ApiEndpoints.getStudentMonthwiseAttendanceDetail;

    final Map<String, dynamic> body = {
      "sl": "",
      "sid": 0,
      "regno": regno,
      "fromyear": fromyear,
      "toyear": toyear,
      "monthid": monthid,
    };

    try {
      final data = await postRequest(endpoint, body);

      if (data != null) {
        monthlyAttendanceDetail = StudentMonthlyAttendanceDetailResponse.fromJson(data);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student monthly attendance detail data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String? getAttendanceStatus(String date) {
    if (monthlyAttendanceDetail?.data?.monthwiseAttendance == null) {
      return null;
    }

    final attendance = monthlyAttendanceDetail!.data!.monthwiseAttendance!
        .firstWhere(
          (item) => item.attnDate == date,
          orElse: () => MonthwiseAttendance(),
        );

    if (attendance.attendenceType == null) {
      return null;
    }

    // Assuming attendenceType 1 = Present, 0 = Absent
    return attendance.attendenceType == 1 ? 'Present' : 'Absent';
  }

  bool isHoliday(String date) {
    if (monthlyAttendanceDetail?.data?.holidayDates == null) {
      return false;
    }

    return monthlyAttendanceDetail!.data!.holidayDates!
        .any((holiday) => holiday.holidayDate == date);
  }

  // Helper method to get holiday details for a specific date
  String? getHolidayDetails(String date) {
    if (monthlyAttendanceDetail?.data?.holidayDates == null) {
      return null;
    }

    final holiday = monthlyAttendanceDetail!.data!.holidayDates!
        .firstWhere(
          (item) => item.holidayDate == date,
          orElse: () => HolidayDate(),
        );

    return holiday.holidayDetails;
  }
}