import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/employee_counter_model.dart';
import '../common/common_post_method.dart';

class EmployeeCounterProvider with ChangeNotifier {
  EmployeeCounterResponse? _employeeCounterData;
  bool _isLoading = false;
  String? _error;

  EmployeeCounterResponse? get employeeCounterData => _employeeCounterData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getEmployeeCounter({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> requestBody = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final response = await postRequest(
        ApiEndpoints.getEmployeeCounter,
        requestBody,
      );

      if (response != null) {
        final counterResponse = EmployeeCounterResponse.fromJson(response);
        if (counterResponse.isSuccess) {
          _employeeCounterData = counterResponse;
        } else {
          _error = "Failed to fetch data";
          _employeeCounterData = null;
        }
      } else {
        _error = "Failed to fetch data";
        _employeeCounterData = null;
      }
    } catch (e) {
      _error = e.toString();
      _employeeCounterData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearEmployeeCounterProvider() {
    _employeeCounterData = null;
    _isLoading = false;
    _error = null;

    notifyListeners();
  }

}
