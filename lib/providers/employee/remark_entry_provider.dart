import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/remark_entry_model.dart';
import '../common/common_post_method.dart';

class RemarkEntryProvider extends ChangeNotifier {
  bool isLoading = false;

  List<RemarkProfileClass> classList = [];
  RemarkProfileClass? selectedClass;

  List<RemarkTerm> termList = [];
  RemarkTerm? selectedTerm;

  Future<void> getClassForRemarkEntry({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(ApiEndpoints.getClassForRemarkEntry, body);

      if (data != null && data["statusCode"] == "Success") {
        final response = RemarkProfileClassResponse.fromJson(data);
        classList = response.data ?? [];
        // Optional: Select first item if list is not empty, or keep null
        selectedClass = null; 
      } else {
        classList = [];
      }
    } catch (e) {
      log("Error fetching remark entry classes: $e");
      classList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedClass(RemarkProfileClass? value) {
    selectedClass = value;


    notifyListeners();
  }

  Future<void> getTermForRemarkEntry({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(ApiEndpoints.getTermForRemarkEntry, body);

      if (data != null && data["statusCode"] == "Success") {
        final response = RemarkTermResponse.fromJson(data);
        termList = response.data ?? [];
        selectedTerm = null; 
      } else {
        termList = [];
      }
    } catch (e) {
      log("Error fetching remark entry terms: $e");
      termList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedTerm(RemarkTerm? value) {
    selectedTerm = value;
    notifyListeners();
  }

  List<RemarkStudentEntry> studentList = [];

  Future<void> getStudentRemarkEntryList({
    required String fromYear,
    required String toYear,
    required String classId, 
    required String examId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String classNameRaw = "";
      String streamRaw = "NA";
      String sectionRaw = "";

      List<String> parts = classId.split('_');
      if (parts.length >= 3) {
        classNameRaw = parts[0]; 
        streamRaw = parts[1];    
        sectionRaw = parts[2];   
      } else if (parts.length == 2) {
         classNameRaw = parts[0];
         sectionRaw = parts[1];
      } else {
         classNameRaw = classId;
      }

      final body = {
        "fromyear": fromYear,
        "toyear": toYear,
        "class_name": classNameRaw,
        "stream": streamRaw,
        "section": sectionRaw,
        "exam_id": examId
      };

      final data = await postRequest(ApiEndpoints.getStudentRemarkEntryList, body);
      
      if (data != null && data["statusCode"] == "Success") {
         final response = RemarkStudentEntryListResponse.fromJson(data);
         studentList = response.data ?? [];
      } else {
         studentList = [];
      }

    } catch (e) {
      log("Error fetching student remark entry list: $e");
      studentList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<String?> setRemarkForExamination({
    required String sid,
    required String regno,
    required String termId,
    required String academicRemark,
    required String attendanceRemark,
    required String result,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final body = {
        "sid": sid,
        "regno": regno,
        "termid": termId,
        "accdemic_remark": academicRemark,
        "attendance_remark": attendanceRemark,
        "result": result,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(
          ApiEndpoints.setRemarkForExamination, body);
      if (data != null && data["statusCode"] == "Success") {
        return data["message"]?.toString();
      } else {
        return null;
      }
    }
    catch (e) {
      log(" error: $e");
      return null;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }
  void clearStudent(){
    studentList.clear();
    notifyListeners();
  }

  void updateStudentRemarkLocal({
    required String sid,
    required String academicRemark,
    required String attendanceRemark,
    required String resultRemark,
  }) {
    try {
      final studentIndex = studentList.indexWhere((student) => student.sid == sid);

      if (studentIndex != -1) {
        final student = studentList[studentIndex];
        if (student.accademicRemarkHeads != null) {
          for (var head in student.accademicRemarkHeads!) {
            if (head.remarkHead == academicRemark) {
              head.isAccademicRemarkSelected = 'yes';
            } else {
              head.isAccademicRemarkSelected = 'no';
            }
          }
        }

        if (student.attendanceRemarkHeads != null) {
          for (var head in student.attendanceRemarkHeads!) {
            if (head.remarkHead == attendanceRemark) {
              head.isAccademicRemarkSelected = 'yes';
            } else {
              head.isAccademicRemarkSelected = 'no';
            }
          }
        }

        if (student.resultRemarkHeads != null) {
          for (var head in student.resultRemarkHeads!) {
            if (head.remarkHead == resultRemark) {
              head.isResultRemarkSelected = 'yes';
            } else {
              head.isResultRemarkSelected = 'no';
            }
          }
        }

        notifyListeners();
      }
    } catch (e) {
      log("Error updating student remark locally: $e");
    }
  }
}
