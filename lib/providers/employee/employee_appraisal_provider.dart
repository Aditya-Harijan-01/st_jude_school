import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/employee/appraisal_model.dart';
// import '../../widgets/kdebug_log.dart';
import '../common/common_post_method.dart';

class EmployeeAppraisalProvider extends ChangeNotifier {
  bool isLoading = false;
  AppraisalData? appraisalData;
  List<YearlyAppraisal>? appraisalList;
  int? accessValue;

  Future<bool> getEmployeeAppraisalReport({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };


      final data = await postRequest(
        ApiEndpoints.getEmployeeAppraisalReport,
        body,
      );

      if (data != null) {
        final appraisalResponse = AppraisalData.fromJson(data);
        appraisalData = appraisalResponse;
        appraisalList = appraisalResponse.data;
        accessValue = appraisalResponse.userAccessValue;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        log("Failed to fetch employee appraisal report: Response is null");
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Error fetching employee appraisal report: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool get hasAppraisalData => appraisalData != null && appraisalList != null && appraisalList!.isNotEmpty;

  void clearAppraisalData() {
    appraisalData = null;
    appraisalList = null;
    accessValue = null;
    isLoading = false;
    notifyListeners();
  }

  bool get isDataLoading => isLoading;
}