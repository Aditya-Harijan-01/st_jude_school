import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/examination_list_model.dart';
import '../../models/Students/syllabus_details_model.dart';
import '../../models/Students/syllabus_model.dart';
import '../common/common_post_method.dart';

class SubjectSyllabusProvider extends ChangeNotifier {
  bool isLoading = false;
  SubjectListModel? subjectListModel;
  List<SubjectData>? subjectData;
  SyllabusDetailsResponse? syllabusDetailsResponse;
  List<SyllabusData>? syllabusData;
  SyllabusItem? syllabusItem;
  
  ExaminationListResponse? examinationListResponse;
  List<ExaminationData>? examinationData;

  Future<bool> getStudentSyllabus(
    userId,
    fromyear,
    toyear
  ) async {
    isLoading = true;
    notifyListeners();

    // const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getSubjectListForSyllabus}";
    // log(url);

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
        subjectListModel = SubjectListModel.fromJson(data);
        subjectData = subjectListModel!.data;
        final firstsubject = subjectData!.first.subCode;

        await getSyllabusDetails(firstsubject, userId, fromyear, toyear);

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

  Future<bool> getSyllabusDetails(
    subjectCode,
    userId,
    fromyear,
    toyear
  ) async {
    isLoading = true;
    notifyListeners();

    const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getSyllabusDetails}";
    log(url);

    final Map<String, dynamic> body = {
      "sl": subjectCode,
      "sid": 0,
      "regno": userId,
      "fromyear": fromyear,
      "toyear": toyear,
      "monthid": "string",
      "usertype": "string"
    };

    try {
      final data = await postRequest(ApiEndpoints.getSyllabusDetails, body);

      if (data != null) {
        syllabusDetailsResponse = SyllabusDetailsResponse.fromJson(data);
        syllabusData = syllabusDetailsResponse!.data;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student Syllabus details data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getExaminationList(
    userId,
    fromyear,
    toyear
  ) async {
    isLoading = true;
    notifyListeners();

    // const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getExaminationList}";
    // log(url);

    final Map<String, dynamic> body = {
      "sl": "",
      "sid": 0,
      "regno": userId,
      "fromyear": fromyear,
      "toyear": toyear,
      "monthid": ""
    };

    try {
      final data = await postRequest(ApiEndpoints.getExaminationList, body);

      if (data != null) {
        examinationListResponse = ExaminationListResponse.fromJson(data);
        examinationData = examinationListResponse!.data;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get Examination List error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getSyllabusDetailsByExam(
    userId,
    fromyear,
    toyear,
    subCode,
    examid
  ) async {
    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      "regno": userId,
      "fromyear": fromyear,
      "toyear": toyear,
      "sub_code": subCode,
      "examid": examid
    };

    try {
      final data = await postRequest(ApiEndpoints.getSyllabusDetailsByExam, body);

      if (data != null) {
        syllabusDetailsResponse = SyllabusDetailsResponse.fromJson(data);
        syllabusData = syllabusDetailsResponse!.data;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student Syllabus details by exam error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
