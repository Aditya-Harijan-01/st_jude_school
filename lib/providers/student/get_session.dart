import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/common/student_session.dart';
import '../../views/Employee_view/students_management/Session/model_session/model_ss.dart';
import '../common/common_post_method.dart';

class SessionProvider extends ChangeNotifier {
  bool isLoading = false;
  SessionResponse? sessionResponse;
  SessionResponseSeconday? sessionResponse2;
  List<SessionData>? sessionData;
  List<SessionDataSecondary>? sessionData2;
  StudentInfo? studentInfo;
  StudentInfoSecondary? studentInfo2;
  SessionData? selectedSession;
  SessionDataSecondary? selectedSession2;

  Future<void> getSession(String? reg, fromYear, toYear, userType) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "sl": "string",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };
      //rtbpdf1862e0ngvh$2

      final bodyEmp = {
        "sl": "",
        "sid": 0,
        "tid" : reg,
        "fromyear": "",
        "toyear": "",
        "monthid": ""
      };


      final data =  await postRequest(
        userType == "Student" 
          ? ApiEndpoints.getStudentSession
          : ApiEndpoints.getAllValidSessionEmployee,

          userType == "Student" ? body : bodyEmp);

      if (data != null) {
        log("This data is for the student Session : $data");

        final session = SessionResponse.fromJson(data);
        sessionResponse = session;
        sessionData = session.data?.sessionInfo ?? [];
        studentInfo = session.data?.studentInfo;

        notifyListeners();
      }
    } catch (e) {
      log("This is the error for the student Session: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> getSessionSecondary(String? reg, fromYear, toYear, userType) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "sl": "string",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };

      final bodyEmp = {
        "sl": "",
        "sid": 0,
        "tid" : reg,
        "fromyear": "",
        "toyear": "",
        "monthid": ""
      };

      // final empBody = {
      //   "sl": "string",
      //   "sid": 0,
      //   "tid": "147",
      //   "fromyear": "",
      //   "toyear": "",
      //   "monthid": ""
      // };

      final data =  await postRequest(
        userType == "Student"
          ? ApiEndpoints.getStudentSession
          : ApiEndpoints.getAllValidSessionEmployee,

          userType == "Student" ? body : bodyEmp);

      if (data != null) {
        log("This data is for the student Session : $data");

        final session = SessionResponseSeconday.fromJson(data);
        sessionResponse2 = session;
        sessionData2 = session.data?.sessionInfo ?? [];
        studentInfo2 = session.data?.studentInfo;

        notifyListeners();
      }
    } catch (e) {
      log("This is the error for the student Session: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedSession(String from, String to) {
    selectedSession = sessionData?.firstWhere(
      (s) => s.fromYear == from && s.toYear == to,
      orElse: () => sessionData!.first,
    );
    notifyListeners();
  }
  void updateSelectedSessionSecondary(String from, String to) {
    selectedSession2 = sessionData2?.firstWhere(
      (s) => s.fromYear == from && s.toYear == to,
      orElse: () => sessionData2!.first,
    );
    notifyListeners();
  }
}
