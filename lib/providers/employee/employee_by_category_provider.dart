import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/employee_by_category_model.dart';
import '../common/common_post_method.dart';

class EmployeeByCategoryProvider with ChangeNotifier {
  EmployeeByCategoryResponse? _employeeByCategoryData;
  bool _isLoading = false;
  String? _error;

  EmployeeByCategoryResponse? get employeeByCategoryData => _employeeByCategoryData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getEmployeeByCategory({
    required String categoryId,
    required String fromYear,
    required String toYear,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> requestBody = {
        "category_id": categoryId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final response = await postRequest(
        ApiEndpoints.getEmployeeByCategory,
        requestBody,
      );

      if (response != null) {
        final categoryResponse = EmployeeByCategoryResponse.fromJson(response);
        if (categoryResponse.isSuccess) {
          _employeeByCategoryData = categoryResponse;
        } else {
          _error = categoryResponse.message ?? "Failed to fetch data";
          _employeeByCategoryData = null;
        }
      } else {
        _error = "Failed to fetch data";
        _employeeByCategoryData = null;
      }
    } catch (e) {
      _error = e.toString();
      _employeeByCategoryData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearEmployeeByCategoryProvider() {
    _employeeByCategoryData = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
