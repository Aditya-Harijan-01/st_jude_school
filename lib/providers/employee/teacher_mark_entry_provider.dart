import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/teacher_mark_entry_model.dart';
import '../../models/employee/student_mark_entry_model.dart';
import '../common/common_post_method.dart';

class TeacherMarkEntryProvider extends ChangeNotifier {
  TeacherMarkEntryResponse? teacherMarkEntryResponse;
  List<TeacherMarkEntryData>? teacherMarkEntryData;
  TeacherMarkEntryData? selectedTeacher;
  bool isLoading = false;
  bool isTeacherLoading = false;
  List<Map<String, String>> classList = [];
  String? selectedClassId;

  List<Map<String, String>> examinationList = [];
  String? selectedExaminationId;

  List<Map<String, String>> subjectGroupList = [];
  String? selectedSubjectGroupId;

  List<Map<String, String>> subjectList = [];
  String? selectedSubjectId;

  // Student list for mark entry
  StudentMarkEntryResponse? studentMarkEntryResponse;
  List<StudentMarkEntryData>? studentMarkEntryData;

  Future<void> getTeacherForMarkEntry({
    required String empId,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      isTeacherLoading = true;
      notifyListeners();

      final body = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(ApiEndpoints.getTeacherForMarkEntry, body);

      if (data != null) {
        log("Teacher mark entry data: $data");
        final teacherResponse = TeacherMarkEntryResponse.fromJson(data);
        teacherMarkEntryResponse = teacherResponse;
        teacherMarkEntryData = teacherResponse.teachingStaff;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching teacher data: $e");
    } finally {
      isLoading = false;
      isTeacherLoading = false;
      notifyListeners();
    }
  }

  void setSelectedTeacher(TeacherMarkEntryData? teacher) {
    selectedTeacher = teacher;
    notifyListeners();
  }

  TeacherMarkEntryData? getSelectedTeacher() {
    return selectedTeacher;
  }

  String getSelectedTeacherEmpId() {
    return selectedTeacher?.empId ?? '';
  }

  String getSelectedTeacherName() {
    return selectedTeacher?.empName ?? '';
  }

  List<TeacherMarkEntryData> get availableTeachers =>
      teacherMarkEntryData?.toList() ?? [];

  int get totalTeachers => teacherMarkEntryData?.length ?? 0;

  Future<void> getClassForMarkEntry({
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

      final data =
          await postRequest(ApiEndpoints.getClassForMarkEntry, body);

      if (data != null &&
          data["statusCode"] == "Success" &&
          data["data"] is List) {
        final List list = data["data"];

        classList = list
            .map<Map<String, String>>((e) => {
                  "class_id": e["class_id"]?.toString() ?? "",
                  "class_name": e["class_name"]?.toString() ?? "",
                })
            .toList();

        selectedClassId = null;
      } else {
        classList = [];
        selectedClassId = null;
      }
    } catch (e) {
      log("Error fetching class data for mark entry: $e");
      classList = [];
      selectedClassId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get availableClasses => classList;

  void setSelectedClass(String? classId) {
    selectedClassId = classId;

    selectedExaminationId = null;
    examinationList = [];

    selectedSubjectGroupId = null;
    subjectGroupList = [];

    selectedSubjectId = null;
    subjectList = [];

    // Clear student data when class changes
    studentMarkEntryResponse = null;
    studentMarkEntryData = null;

    notifyListeners();
  }

  Map<String, String> _parseClassId(String classId) {
    final parts = classId.split('_');
    return {
      'class_name': parts.isNotEmpty ? parts[0] : '',
      'section': parts.length > 1 ? parts[1] : '',
      'stream': parts.length > 2 ? parts[2] : '',
    };
  }

  Future<void> getExaminationForMarkEntry({
    required String empId,
    required String fromYear,
    required String toYear,
    required String classId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = _parseClassId(classId);

      final body = {
        "empid": empId,
        "class_name": parsed['class_name'] ?? "",
        "section": parsed['section'] ?? "",
        "stream": parsed['stream'] ?? "",
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(
        ApiEndpoints.getExaminationForMarkEntry,
        body,
      );

      if (data != null &&
          data["statusCode"] == "Success" &&
          data["data"] is List) {
        final List list = data["data"];
        examinationList = list
            .map<Map<String, String>>((e) => {
                  "exam_id": e["exam_id"]?.toString() ?? "",
                  "exam_name": e["exam_name"]?.toString() ?? "",
                })
            .toList();
        selectedExaminationId = null;
      } else {
        examinationList = [];
        selectedExaminationId = null;
      }
    } catch (e) {
      log("Error fetching examination data for mark entry: $e");
      examinationList = [];
      selectedExaminationId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get availableExaminations => examinationList;

  void setSelectedExamination(String? examId) {
    selectedExaminationId = examId;

    selectedSubjectGroupId = null;
    subjectGroupList = [];

    // Clear student data when examination changes
    studentMarkEntryResponse = null;
    studentMarkEntryData = null;

    notifyListeners();
  }

  Future<void> getSubjectGroupForMarkEntry({
    required String empId,
    required String fromYear,
    required String toYear,
    required String classId,
    required String examId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = _parseClassId(classId);

      final body = {
        "empid": empId,
        "class_name": parsed['class_name'] ?? "",
        "section": parsed['section'] ?? "",
        "stream": parsed['stream'] ?? "",
        "exam_id": examId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(
        ApiEndpoints.getSubjectGroupForMarkEntry,
        body,
      );

      if (data != null &&
          data["statusCode"] == "Success" &&
          data["data"] is List) {
        final List list = data["data"];
        subjectGroupList = list
            .map<Map<String, String>>((e) => {
                  "subgroupid": e["subgroupid"]?.toString() ?? "",
                  "subgroupname": e["subgroupname"]?.toString() ?? "",
                })
            .toList();

        if (subjectGroupList.isNotEmpty) {
          selectedSubjectGroupId = subjectGroupList.first["subgroupid"];
        } else {
          selectedSubjectGroupId = null;
        }
      } else {
        subjectGroupList = [];
        selectedSubjectGroupId = null;
      }
    } catch (e) {
      log("Error fetching subject group data for mark entry: $e");
      subjectGroupList = [];
      selectedSubjectGroupId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get availableSubjectGroups => subjectGroupList;

  void setSelectedSubjectGroup(String? subgroupId) {
    selectedSubjectGroupId = subgroupId;
    
    selectedSubjectId = null;
    subjectList = [];
    
    // Clear student data when subject group changes
    studentMarkEntryResponse = null;
    studentMarkEntryData = null;
    
    notifyListeners();
  }

  String _parseSubgroupId(String subgroupIdWithMode) {
    final parts = subgroupIdWithMode.split('_');
    return parts.isNotEmpty ? parts[0] : '';
  }

  String _parseMode(String subgroupIdWithMode) {
    final parts = subgroupIdWithMode.split('_');
    return parts.length > 1 ? parts[1] : '';
  }

  Future<void> getSubjectListForMarkEntry({
    required String empId,
    required String classId,
    required String examId,
    required String subgroupIdWithMode,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = _parseClassId(classId);
      final actualSubgroupId = _parseSubgroupId(subgroupIdWithMode);
      final mode = _parseMode(subgroupIdWithMode);

      final body = {
        "empid": empId,
        "class_name": parsed['class_name'] ?? "",
        "section": parsed['section'] ?? "",
        "stream": parsed['stream'] ?? "",
        "exam_id": examId,
        "subgroupid": actualSubgroupId,
        "mode": mode,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(
        ApiEndpoints.getSubjectListForMarkEntry,
        body,
      );

      if (data != null &&
          data["statusCode"] == "Success" &&
          data["data"] is List) {
        final List list = data["data"];
        subjectList = list
            .map<Map<String, String>>((e) => {
                  "subid": e["subid"]?.toString() ?? "",
                  "sub_code": e["sub_code"]?.toString() ?? "",
                  "sub_name": e["sub_name"]?.toString() ?? "",
                })
            .toList();

        if (subjectList.isNotEmpty) {
          selectedSubjectId = subjectList.first["subid"];
        } else {
          selectedSubjectId = null;
        }
      } else {
        subjectList = [];
        selectedSubjectId = null;
      }
    } catch (e) {
      log("Error fetching subject list for mark entry: $e");
      subjectList = [];
      selectedSubjectId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> get availableSubjects => subjectList;

  void setSelectedSubject(String? subjectId) {
    selectedSubjectId = subjectId;
    
    studentMarkEntryResponse = null;
    studentMarkEntryData = null;
    
    notifyListeners();
  }

  Future<void> getStudentListForMarkEntry({
    required String empId,
    required String classId,
    required String examId,
    required String subjectId,
    required String subgroupIdWithMode,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = _parseClassId(classId);
      final actualSubgroupId = _parseSubgroupId(subgroupIdWithMode);
      final mode = _parseMode(subgroupIdWithMode);
      
      final selectedSubject = subjectList.firstWhere(
        (subject) => subject['subid'] == subjectId,
        orElse: () => {},
      );
      final subCode = selectedSubject['sub_code'] ?? '';

      final body = {
        "empid": empId,
        "class_name": parsed['class_name'] ?? "",
        "section": parsed['section'] ?? "",
        "stream": parsed['stream'] ?? "",
        "exam_id": examId,
        "subgroupid": actualSubgroupId,
        "mode": mode,
        "fromyear": fromYear,
        "sub_code": subCode,
        "toyear": toYear,
      };

      final data = await postRequest(
        ApiEndpoints.getStudentListForMarkEntry,
        body,
      );
      log('datass: $data');
      if (data != null) {
        log("Student mark entry data: $data");
        final studentResponse = StudentMarkEntryResponse.fromJson(data);
        studentMarkEntryResponse = studentResponse;
        studentMarkEntryData = studentResponse.data;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching student list for mark entry: $e");
      studentMarkEntryResponse = null;
      studentMarkEntryData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void clearAllMarkEntryData() {
    selectedTeacher = null;

    classList.clear();
    selectedClassId = null;

    examinationList.clear();
    selectedExaminationId = null;

    subjectGroupList.clear();
    selectedSubjectGroupId = null;

    subjectList.clear();
    selectedSubjectId = null;

    studentMarkEntryResponse = null;
    studentMarkEntryData = [];

    teacherMarkEntryResponse = null;
    teacherMarkEntryData = [];

    notifyListeners();
  }
  List<StudentMarkEntryData> get availableStudents =>
      studentMarkEntryData ?? [];

  bool get hasStudents => 
      studentMarkEntryData != null && studentMarkEntryData!.isNotEmpty;
}