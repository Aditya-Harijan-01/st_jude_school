import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/employee/employee_list_task_model.dart';
import '../../models/employee/employee_slot_wise_task_model.dart';
// import '../../widgets/kdebug_log.dart';
import '../common/common_post_method.dart';

class EmployeeTaskProvider extends ChangeNotifier {
  bool isLoading = false;
  List<EmployeeTaskData>? employeeList;
  int? accessValue;

  bool isLoadingSlotWiseTask = false;
  List<SlotData>? slotWiseTaskList;

  Future<bool> getEmployeeListForTask({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      "empid": empId,
      "fromyear": fromYear,
      "toyear": toYear,
    };

    try {
      final data = await postRequest(ApiEndpoints.getEmployeeListForTask, body);

      if (data != null) {
        final response = EmployeeListForTaskResponse.fromJson(data);
        if (response.statusCode == "Success") {
          employeeList = response.data;
          accessValue = response.userAccessValue;
          isLoading = false;
          notifyListeners();
          return true;
        } else {
          isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get employee list for task error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getEmployeeSlotWiseTask({
    required String empId,
    required String fromYear,
    required String fromDate,
    required String toDate,
  }) async {
    isLoadingSlotWiseTask = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      "empid": empId,
      "fromyear": fromYear,
      "fromdate": fromDate,
      "todate": toDate,
    };

    try {
      final data = await postRequest(ApiEndpoints.getEmployeeSlotWiseTask, body);

      if (data != null) {
        final response = EmployeeSlotWiseTaskResponse.fromJson(data);
        if (response.statusCode == "Success") {
          slotWiseTaskList = response.data;
          isLoadingSlotWiseTask = false;
          notifyListeners();
          return true;
        } else {
          isLoadingSlotWiseTask = false;
          notifyListeners();
          return false;
        }
      } else {
        isLoadingSlotWiseTask = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get employee slot-wise task error: $e");
      isLoadingSlotWiseTask = false;
      notifyListeners();
      return false;
    }
  }

  void clearEmployeeList() {
    employeeList = null;
    isLoading = false;
    slotWiseTaskList = null;
    isLoadingSlotWiseTask = false;
    notifyListeners();
  }
}
