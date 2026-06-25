import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/employee/pending_task_model.dart';
// import '../../widgets/kdebug_log.dart';
import '../common/common_post_method.dart';

class PendingTaskProvider extends ChangeNotifier {
  bool isLoading = false;
  List<PendingTaskData>? pendingTaskList;

  Future<bool> getEmployeePendingTask({
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
      final data = await postRequest(ApiEndpoints.getEmployeePendingTask, body);

      if (data != null) {
        final response = PendingTaskResponse.fromJson(data);
          pendingTaskList = response.data;
          isLoading = false;
          notifyListeners();
          return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get employee pending task error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearPendingTaskList() {
    pendingTaskList = null;
    isLoading = false;
    notifyListeners();
  }
}
