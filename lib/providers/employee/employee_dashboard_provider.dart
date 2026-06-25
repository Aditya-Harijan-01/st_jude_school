import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/emp_dashboard_model.dart';
import '../common/common_post_method.dart';

class EmpDashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  EmpDashboardModel? empDashboardModel;

  Future<void> getEmpDashboardData({
    required String startDate,
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body ={
        "startdate": startDate,
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getEmployeeDashboardData, body);
      if (data != null) {
        log("Dashboard Data: $data");
        empDashboardModel = EmpDashboardModel.fromJson(data);
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
