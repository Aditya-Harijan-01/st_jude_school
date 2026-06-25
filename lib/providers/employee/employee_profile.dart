import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/employee/employee_profile.dart';
import '../common/common_post_method.dart';

class EmployeeProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  EmployeeDataResponse? employeeDataResponse;
  List<EmployeeBasic>? employeeBasic;
  List<EmployeeQualification>? employeeQualification;
  List<EmployeeExperience>? employeeExperience;
  List<EmployeeOffice>? employeeOffice;
  List<EmployeeBank>? employeeBank;
  List<EmployeeAddress>? employeeAddress;

  Future<bool> getEmployeeProfile(empId) async {
    isLoading = true;
    notifyListeners();

    const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getStudentProfile}";
    log(url);

    final Map<String, dynamic> body = {
      "tid": empId,
      "fromYear": '',
      "toyear": '',
    };

    try {

      final data = await postRequest(ApiEndpoints.getEmployeeProfile, body);

      if (data != null) {
        final profileOne = EmployeeDataResponse.fromJson(data);
        employeeDataResponse = profileOne;
        employeeBasic = profileOne.dataBasic;
        employeeBank = profileOne.dataBank;
        employeeQualification = profileOne.dataQualification;
        employeeOffice = profileOne.dataOffice;
        employeeAddress = profileOne.dataAddress;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student profile data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearEmployeeProfileData() {
    employeeAddress = null;
    employeeBank = null;
    employeeBasic = null;
    employeeDataResponse = null;
    employeeExperience = null;
    employeeOffice = null;
    employeeQualification = null;

    isLoading = false;

    notifyListeners();
    if (kDebugMode) {
      log("  Student profile data cleared successfully");
    }
  }

}
