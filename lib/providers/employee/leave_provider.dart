import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/constant.dart';
import '../../models/employee/leave_calander_model.dart';
import '../../models/employee/leave_calander.dart';
import '../../models/employee/leave_model.dart';
import '../../models/employee/leave_type_response.dart';
import '../common/common_post_method.dart';

class LeaveProvider extends ChangeNotifier {
  /// LOADING FLAGS
  bool isSummaryLoading = false;
  bool isCalendarLoading = false;

  /// DATA
  LeaveSummaryResponse? leaveSummaryResponse;
  List<LeaveSummary> leaveSummary = [];
  List<LeaveDeductionSummary> leaveDeductionSummary = [];

  LeaveCalendarResponse? leaveCalendarResponse;
  List<LeaveCalendarData> leaveCalendarData = [];

  LeaveTypeResponse? leaveTypeResponse;
  List<LeaveType>? leaveType;

  LeaveFromTo? leaveFromTo;

  ApplyLeaveCalendarResponse? applyLeaveCalendarResponse;
  List<LeaveDescription>? leaveDescription;

  int userAccess = 1;
  String empID = "";

  /// ---------------- SUMMARY ----------------
  Future<void> getEmployeeLeaveSummery(empId, from, to) async {
    isSummaryLoading = true;
    empID = empId;
    notifyListeners();

    final body = {
      "empid": empId,
      "fromYear": from,
      "toyear": to,
    };

    try {
      final data = await postRequest(ApiEndpoints.getEmployeeLeaveSummery, body);
      if (data != null) {
        final res = LeaveSummaryResponse.fromJson(data);
        leaveSummaryResponse = res;
        leaveSummary = res.leaveSummary;
        leaveDeductionSummary = res.leaveDeductionSummary;
        userAccess = res.userAccess;
      }
    } catch (e) {
      log("Error summary: $e");
    }

    isSummaryLoading = false;
    notifyListeners();
  }

  /// ---------------- HISTORY ----------------
  Future<void> getEmployeeLeaveHistory(empId, from, to) async {
    isCalendarLoading = true;
    notifyListeners();

    final body = {
      "empid": empId,
      "fromYear": from,
      "toyear": to,
    };

    try {
      final data = await postRequest(ApiEndpoints.getEmployeeLeaveHistory, body);
      if (data != null) {
        final res = LeaveCalendarResponse.fromJson(data);
        leaveCalendarResponse = res;
        leaveCalendarData = res.data;
      }
    } catch (e) {
      log("Error history: $e");
    }

    isCalendarLoading = false;
    notifyListeners();
  }

  /// ---------------- LEAVE TYPE ----------------
  Future<void> getEmployeeLeaveTypeMaster(empId, from, to) async {
    final body = {
      "empid": empId,
      "fromYear": from,
      "toyear": to,
    };

    try {
      final data =
          await postRequest(ApiEndpoints.getEmployeeLeaveTypeMaster, body);
      if (data != null) {
        final res = LeaveTypeResponse.fromJson(data);
        leaveTypeResponse = res;
        leaveType = res.data;

        notifyListeners();
      }
    } catch (e) {
      log("Error leave type: $e");
    }

    notifyListeners();
  }

  /// ---------------- VERIFY LEAVE REQUEST ----------------
  Future<void> verifyEmployeeLeaveRequest(
    empId,
    fromYear,
    toYear,
    leaveId,
    startDate,
    totalBalance,
  ) async {
    final body = {
      "empid": empId,
      "fromyear": fromYear,
      "toyear": toYear,
      "leave_id": leaveId,
      "leave_start_date": startDate,
      "total_balance": totalBalance.toString(),
    };

    try {
      final data =
          await postRequest(ApiEndpoints.verifyEmployeeLeaveRequest, body);
      if (data != null) {
        leaveFromTo = LeaveFromTo.fromJson(data);
      }
    } catch (e) {
      log("Error verify: $e");
    }

    notifyListeners();
  }

  /// ---------------- REQUEST DESCRIPTION ----------------
  Future<void> getRequestedLeaveDescription(
    empId,
    fromYear,
    toYear,
    leaveId,
    startDate,
    endDate,
  ) async {
    final body = {
      "empid": empId,
      "fromyear": fromYear,
      "toyear": toYear,
      "leave_id": leaveId,
      "start_date": startDate,
      "end_date": endDate,
    };

    try {
      final data =
          await postRequest(ApiEndpoints.getRequestedLeaveDescription, body);
      if (data != null) {
        final res = ApplyLeaveCalendarResponse.fromJson(data);
        applyLeaveCalendarResponse = res;
        leaveDescription = res.leaveDescription;
      }
    } catch (e) {
      log("Error description: $e");
    }

    notifyListeners();
  }

  /// ---------------- APPLY LEAVE ----------------
  Future<bool> employeeLeaveApply(
    empId,
    fromYear,
    toYear,
    leaveFrom,
    leaveTo,
    reason,
    List<LeaveDescription>? leaveDescriptionDetails,
  ) async {
    final detailsList = leaveDescriptionDetails?.map((desc) {
      final d = desc.leaveDescriptionDetails;
      final p = d.leaveCodeSeries.split("~");
      return {
        "leave_id": p[1],
        "applicant_id": p[0],
        "leave_date": d.leaveDate,
        "leave_type": p[3],
        "status": p[8],
        "from_year": fromYear,
        "to_year": toYear,
        "oflineID": "0",
        "apply_leave_type_id": p[4],
        "grant_leave_type_id": p[4],
        "apply_leave": p[9],
        "is_sandwich": p[10],
      };
    }).toList();

    final body = {
      "empid": empId,
      "start_date": leaveFrom,
      "end_date": leaveTo,
      "remark": reason,
      "leave_detail": detailsList,
    };

    log("this is for the testing :$body");

    try {
      final data = await postRequest(ApiEndpoints.employeeLeaveApply, body);
      return data != null;
    } catch (e) {
      log("Error applying leave: $e");
      return false;
    }
  }

  /// ---------------- CANCEL LEAVE ----------------
  Future<bool> cancelEmployeeLeave(empId, leaveId, leaveDate) async {
    final year = DateFormat("yyyy").format(DateTime.now());

    final body = {
      "empid": empId,
      "leave_id": leaveId,
      "leave_date": leaveDate,
      "fromyear": year,
    };

    try {
      final data = await postRequest(ApiEndpoints.cancelEmployeeLeave, body);
      return data != null;
    } catch (e) {
      log("Error cancel: $e");
      return false;
    }
  }


  void clearLeaveScreenData() {
    leaveSummary.clear();
    leaveDeductionSummary.clear();
    leaveCalendarData.clear();
    leaveSummaryResponse = null;
    leaveCalendarResponse = null;

    isSummaryLoading = true;
    isCalendarLoading = true;

    notifyListeners();
  }

}
