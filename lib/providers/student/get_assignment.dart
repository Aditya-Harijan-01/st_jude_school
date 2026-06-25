import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/assignment_details.dart';
import '../common/common_post_method.dart';

class StudentAssignmentProvider extends ChangeNotifier {
  bool isLoading = false;


  StudentAssignmentResponse? studentAssignmentResponse;
  List<StudentAssignment>? studentAssignment;
  AssignmentDocument? assignmentDocument;

  String activeCount = "";
  String completedCount = "";

  Future<void> getAssignment(String reg, fromYear, toYear) async {
    // _setLoading(true);
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

      final data = await postRequest(ApiEndpoints.getStudentAssignment, body);

      if (data != null) {
        log("This data is for the student Assignment :$data");
        final assignment = StudentAssignmentResponse.fromJson(data);
        studentAssignmentResponse = assignment;
        studentAssignment = assignment.data;
        activeCount = studentAssignment!.where((item) => item.displayStatus.toLowerCase() == "active")
                      .length.toString();

        completedCount = studentAssignment!
            .where((item) => item.displayStatus.toLowerCase() == "completed")
            .length.toString();

        // print(assignment.data.length);
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student Assignment: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}