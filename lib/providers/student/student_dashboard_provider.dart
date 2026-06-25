import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_dashboard_model.dart';
import '../common/common_post_method.dart';

class StudentDashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentDashboardModel? studentDashboardModel;

  Future<void> getStudentDashboardData({
    required String startDate,
    required String regNo,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "startdate": startDate,
        "regno": regNo,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getStudentDashboardData, body);

      if (data != null) {
        log("Dashboard Data: $data");
        studentDashboardModel = StudentDashboardModel.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching dashboard data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
