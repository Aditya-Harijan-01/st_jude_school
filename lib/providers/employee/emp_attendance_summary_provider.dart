import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/emp_attendance_summary.dart';
import '../common/common_post_method.dart';

class EmployeeAttendanceSummaryProvider extends ChangeNotifier {
  bool isLoading = false;
  EmpAttendanceSummaryResponse? attendanceSummary;

  Future<bool> getEmployeeAttendanceSummary({
    required String tid,
    required String fromyear,
    required String toyear,
  }) async {
    isLoading = true;
    notifyListeners();

    const String endpoint = ApiEndpoints.getEmployeeAttendanceSummery;

    final Map<String, dynamic> body = {"tid":tid,"fromyear":fromyear,"toyear":toyear};

    try {
      final data = await postRequest(endpoint, body);

      if (data != null) {
        attendanceSummary = EmpAttendanceSummaryResponse.fromJson(data);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get Employee attendance summary data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
  void clear(){
    attendanceSummary = null;
  }
}