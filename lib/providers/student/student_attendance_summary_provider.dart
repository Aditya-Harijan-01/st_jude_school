import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_attendance_summary.dart';
import '../common/common_post_method.dart';

class StudentAttendanceSummaryProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentAttendanceSummaryResponse? attendanceSummary;

  Future<bool> getStudentAttendanceSummary({
    required String regno,
    required String fromyear,
    required String toyear,
  }) async {
    isLoading = true;
    notifyListeners();

    const String endpoint = ApiEndpoints.getStudentAttendanceSummery;

    final Map<String, dynamic> body = {
      "sl": "",
      "sid": 0,
      "regno": regno,
      "fromyear": fromyear,
      "toyear": toyear,
      "monthid": "",
    };

    try {
      final data = await postRequest(endpoint, body);

      if (data != null) {
        attendanceSummary = StudentAttendanceSummaryResponse.fromJson(data);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student attendance summary data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}