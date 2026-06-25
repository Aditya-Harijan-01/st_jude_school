// import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../models/employee/emp_time_table.dart';
import '../../models/employee/teacher_timetable.dart';
import '../common/common_post_method.dart';


enum TimetableStatus { loading, loaded, error }

  class EmpTimetableProvider extends ChangeNotifier {

  List<TimetableItem> timetableItems = [];
  List<TimetableData> timetableItemsEmp = [];

  TimetableStatus status = TimetableStatus.loading;
  String errorMessage = '';
  String selectedDate = '';
  String currentDayName = '';

  bool get isLoading => status == TimetableStatus.loading;
  bool get hasError => status == TimetableStatus.error;

  // ---------------- CLEAR ----------------
  void clearTimetable() {
    timetableItems.clear();
    timetableItemsEmp.clear();
    status = TimetableStatus.loading;
    errorMessage = '';
    selectedDate = '';
    currentDayName = '';
    notifyListeners();
  }

  // ---------------- EMPLOYEE TIMETABLE ----------------
  Future<void> fetchEmpTimetable({
    required String date,
    required String regNo,
    required String fromYear,
    required String toYear,
  }) async {

    // SET LOADING
    status = TimetableStatus.loading;
    selectedDate = date;
    timetableItemsEmp.clear();
    notifyListeners();

    final url = ApiEndpoints.getEmployeeDaywiseTimetableDetails;

    final body = {
      "sl": date,
      "empid": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "monthid": ""
    };

    try {
      final response = await postRequest(url, body);

      if (response == null) {
        _setError("No response from server");
        return;
      }

      final timetableResponse = TeacherTimetableModel.fromJson(response);

      if (timetableResponse.statusCode.toLowerCase() == 'success') {
        timetableItemsEmp = timetableResponse.data;

        currentDayName = timetableItemsEmp.isNotEmpty
            ? timetableItemsEmp.first.dayName
            : '';

        status = TimetableStatus.loaded;
        errorMessage = '';
      } else {
        _setError("No classes found");
      }
    } catch (e) {
      log("Emp timetable error: $e");
      _setError("Something went wrong");
    }

    notifyListeners();
  }

  // ---------------- STUDENT TIMETABLE ----------------
  Future<void> fetchTimetable({
    required String date,
    required String regNo,
    required String fromYear,
    required String toYear,
  }) async {

    status = TimetableStatus.loading;
    selectedDate = date;
    timetableItems.clear();
    notifyListeners();

    final url = ApiEndpoints.getDaywiseTimetableDetails;

    final body = {
      "sl": date,
      "sid": 0,
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "monthid": "0"
    };

    try {
      final response = await postRequest(url, body);

      if (response == null) {
        _setError("No response from server");
        return;
      }

      final data = TimetableResponse.fromJson(response);

      if (data.statusCode.toLowerCase() != 'success') {
        _setError("No classes found");
        return;
      }

      timetableItems = data.data;
      currentDayName =
          timetableItems.isNotEmpty ? timetableItems.first.dayName : '';

      status = TimetableStatus.loaded;
      errorMessage = '';
    } catch (e) {
      log("Student timetable error: $e");
      _setError("Something went wrong");
    }

    notifyListeners();
  }

  // ---------------- ERROR ----------------
  void _setError(String message) {
    status = TimetableStatus.error;
    errorMessage = message;
    timetableItems.clear();
    timetableItemsEmp.clear();
  }

  // ---------------- REFRESH ----------------
  Future<void> refreshTimetable({
    required String regNo,
    required String fromYear,
    required String toYear,
    bool isEmployee = true,
    String? empID,
  }) async {
    if (selectedDate.isEmpty) return;

    isEmployee
        ? await fetchEmpTimetable(
            date: selectedDate,
            regNo: empID!,
            fromYear: fromYear,
            toYear: toYear,
          )
        : await fetchTimetable(
            date: selectedDate,
            regNo: regNo,
            fromYear: fromYear,
            toYear: toYear,
          );
  }
}
