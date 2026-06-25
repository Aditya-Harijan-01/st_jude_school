
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../models/employee/emp_dashboard.dart';
import '../common/common_post_method.dart';

class EmpDashBoardProvider extends ChangeNotifier {
  // UI States
  bool isLoading = false;

  DashboardResponse? dashboardResponse;

  List<CalendarData>? calendarData = []; 
  List<NoticeData>? noticeData = [];
  List<AttendanceData>? attendanceData = [];

  /// ------------------------------------------------------------
  /// FETCH EMPLOYEE DASHBOARD LIST 
  /// ------------------------------------------------------------
  Future<void> fetchEmpDashBoard(
    String empId, 
    String year, 
    String toYear,
  ) async {

    isLoading = true;
    notifyListeners();

    final url = ApiEndpoints.getEmployeeDashboardData;

    final body = {
      "startdate": "15/10/2025",
      "empid": empId,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(
        url,
        body
      );

      log("Employee Dashboard List Response: $response");

      if (response != null) {
        final model = DashboardResponse.fromJson(response);
        dashboardResponse = model;
        calendarData = model.dataCalendar;
        noticeData = model.dataNotice;
        attendanceData = model.dataAttendance;
      }
    } catch (e) {
      log("fetchAssignments ERROR → $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}