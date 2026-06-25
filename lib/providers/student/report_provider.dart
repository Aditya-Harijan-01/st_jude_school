import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../common/common_post_method.dart';

class SubjectSyllabusProvider extends ChangeNotifier {
  bool isLoading = false;


  Future<bool> getStudentSyllabus(
    userId,
    fromyear,
    toyear
  ) async {
    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      "sl": "string",
      "sid": 0,
      "regno": userId,
      "fromyear": fromyear,
      "toyear": toyear,
      "monthid": "string",
      "usertype": "string"
      };

    try {
      final data = await postRequest(ApiEndpoints.getSubjectListForSyllabus, body);

      if (data != null) {

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student Syllabus data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
