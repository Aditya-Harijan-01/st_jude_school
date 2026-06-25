
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../models/employee/emp_student_attendence.dart';
import '../common/common_post_method.dart';

class EmpStudentAttendenceProvider extends ChangeNotifier {
  // Loading states
  bool isLoadingClasses = false;
  bool isLoading = false;
  bool isLoadingStudents = false;
  bool isSaving = false;
  bool isSessionChanging = false;
  bool isUpdatingAttendance = false;


  String selectedDate = "";
  List<AttendanceClass> classes = [];
  List<StudentAttendance> students = [];
  String isCompleted = '';
  AttendanceClass? currentClass;
  String attendance = "";
  String str = '';
  String sec = '';

  // Access control
  int userAccessValue = 0;
  bool canChangeSession = false;

  // Error message
  String errorMessage = "";

  // SETTERS
  void setDate(String date) {
    selectedDate = date;
    notifyListeners();
  }

  void setCurrentClass(AttendanceClass data) {
    currentClass = data;
    notifyListeners();
  }

  void clearMessage() {
    errorMessage = "";
    notifyListeners();
  }


  void toggleStudentAttendance(int index) {
    if (index >= 0 && index < students.length && students[index].canMarkAttendance) {
      students[index].toggleAttendance();
      notifyListeners();
    }
  }

  //---------------------------------------------------------------------------
  // 🔹 FETCH SESSION DATES
  //---------------------------------------------------------------------------
  Future<List<SessionDate>> getSessionDates(String from, String to) async {
    try {
      final data = await postRequest(ApiEndpoints.getSessionDate, {
        "fromyear": from,
        "toyear": to,
      });

      if (data != null && data["statusCode"] == "Success") {
        return (data["data"] as List?)
          ?.map((e) => SessionDate.fromJson(e))
          .toList() ??
        [];
      }
      return [];
    } catch (e) {
      log("Session date error: $e");
      return [];
    }
  }

  //---------------------------------------------------------------------------
  // 🔹 FETCH ACTIVE CLASSES
  //---------------------------------------------------------------------------
  Future<void> getActiveClasses(String empId, String from, String to) async {
    if (selectedDate.isEmpty) {
      errorMessage = "Please select a date first";
      notifyListeners();
      return;
    }

    isLoadingClasses = true;
    errorMessage = "";
    classes = [];
    notifyListeners();

    try {
      final response = await postRequest(
        ApiEndpoints.activeClsForStdAttend,
        {
          "attendance_date": selectedDate,
          "fromyear": from,
          "toyear": to,
          "empid": empId,
        },
      );

      if (response != null) {
        final classResponse = ClassListResponse.fromJson(response);

        userAccessValue = classResponse.userAccessValue;
        canChangeSession = userAccessValue == 0;

        if (classResponse.hasAccess) {
          classes = classResponse.data;

          if (classes.isEmpty) {
            errorMessage = "No classes found for the selected date";
          }
        } else {
          errorMessage = "You do not have access";
        }
      }
    } catch (e) {
      log("Active class error: $e");
      errorMessage = "Unable to load classes. Try again.";
    }

    isLoadingClasses = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------------
  // 🔹 FETCH STUDENTS
  //---------------------------------------------------------------------------
  Future<void> getStudents({
    required String empId,
    required String from,
    required String to,
    required String className,
    required String stream,
    required String section,
  }) async {
    isLoadingStudents = true;
    errorMessage = "";
    students = [];
    attendance = className;
    str = stream;
    sec = section;
    notifyListeners();

    try {
      final response = await postRequest(
        ApiEndpoints.activeStdForAttend,
        {
          "attendance_date": selectedDate,
          "fromyear": from,
          "toyear": to,
          "empid": empId,
          "class_name": className,
          "stream": stream,
          "section": section,
        },
      );

      if (response != null) {
        final studentResponse = StudentsResponse.fromJson(response);

        if (studentResponse.statusCode == "Success") {
          isCompleted = studentResponse.message;
          students = studentResponse.data;

          // Sort: by TC status then roll no
          students.sort((a, b) {
          // First: TC status (0 first, 1 last)
          if (a.isTc != b.isTc) {
            return a.isTc.compareTo(b.isTc);
          }

          // Second: Roll number
          final rA = int.tryParse(a.rollno) ?? 999;
          final rB = int.tryParse(b.rollno) ?? 999;
          return rA.compareTo(rB);
        });

        } else {
          errorMessage = "Failed to load students";
        }
      }
    } catch (e) {
      log("Student error: $e");
      errorMessage = "Unable to load students. Try again.";
    }

    isLoadingStudents = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------------
  // 🔹 TOGGLE ATTENDANCE LOCALLY
  //---------------------------------------------------------------------------
  void toggleAttendance(int index) {
    if (index < students.length && students[index].canMarkAttendance) {
      students[index].toggleAttendance();
      notifyListeners();
    }
  }

  //---------------------------------------------------------------------------
  // 🔹 UPDATE ATTENDANCE (SINGLE)
  //---------------------------------------------------------------------------
  Future<void> updateSingleAttendance({
    required String empId,
    required String from,
    required String to,
    required StudentAttendance student,
  }) async {
    isSaving = true;
    notifyListeners();

    try {
      final response = await postRequest(
        ApiEndpoints.updateStdAttend,
        {
          "empid": empId,
          "sid": student.sid,
          "attendance_date": selectedDate,
          "attendance_type": student.attendanceType,
          "remark": "",
          "class_name": attendance,
          "fromyear": from,
          "toyear": to,
        },
      );

      if (response != null) {
        final result = AttendanceUpdateResponse.fromJson(response);

        errorMessage = result.isSuccess
            ? "${student.studentName} updated"
            : "Failed to update ${student.studentName}";

        Future.delayed(const Duration(seconds: 2), clearMessage);
      }
    } catch (e) {
      log("Update error: $e");
      errorMessage = "Update failed. Try again.";
    }

    isSaving = false;
    // getActiveClasses(empId, from, to);
    // getStudents(empId: empId, from: from, to: to, className: attendance, stream: str, section: sec);
    notifyListeners();
  }

  //---------------------------------------------------------------------------
  // 🔹 BULK UPDATE ATTENDANCE
  //---------------------------------------------------------------------------
  Future<void> updateAll({
    required String empId,
    required String from,
    required String to,
    required bool markAllPresent,
  }) async {
    isSaving = true;
    errorMessage = "";
    notifyListeners();

    try {
      final list = students.where((s) => s.canMarkAttendance).toList();

      if (list.isEmpty) {
        errorMessage = "Nothing to update";
        isSaving = false;
        notifyListeners();
        return;
      }

      final payload = list
        .map(
          (s) => {
            "empid": empId,
            "sid": s.sid,
            "attendance_date": selectedDate,
            "attendance_type": markAllPresent ? "1" : "0",
            "remark": "",
            "class_name": attendance,
            "fromyear": from,
            "toyear": to,
          },
        )
        .toList();

      final response =
          await postRequestForBatchAttendance(ApiEndpoints.updateBatchStdAttend, payload);

      if (response != null && response["statusCode"] == "Success") {
        for (var s in list) {
          s.attendanceType = markAllPresent ? "1" : "0";
          s.isChecked = markAllPresent ? "Yes" : "No";
        }

        errorMessage = "Attendance updated successfully";
      } else {
        errorMessage = "Batch update failed";
      }

      Future.delayed(const Duration(seconds: 2), clearMessage);
    } catch (e) {
      log("Batch error: $e");
      errorMessage = "Error updating attendance";
    }

    isSaving = false;
    getActiveClasses(empId, from, to);
    getStudents(empId: empId, from: from, to: to, className: attendance, stream: str, section: sec);
    notifyListeners();
  }

  //---------------------------------------------------------------------------
  // 🔹 SUMMARY
  //---------------------------------------------------------------------------
  Map<String, int> getSummary() {
    final attendable = students.where((s) => s.canMarkAttendance).toList();
    final present = attendable.where((s) => s.isPresent).length;
    final absent = attendable.length - present;
    // final tc = students.where((s) => s.isTc).length;

    return {
      "total": attendable.length,
      "present": present,
      "absent": absent,
      // "tc": tc,
    };
  }

  //---------------------------------------------------------------------------
  // 🔹 RESET
  //---------------------------------------------------------------------------
  void reset() {
    isLoadingClasses = false;
    isLoadingStudents = false;
    isSaving = false;
    selectedDate = "";
    classes = [];
    students = [];
    currentClass = null;
    errorMessage = "";
    notifyListeners();
  }
}
