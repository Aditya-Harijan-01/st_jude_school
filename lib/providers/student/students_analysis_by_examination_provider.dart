import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_analysis_by_examination.dart';
import '../common/common_post_method.dart';

class StudentsAnalysisByExaminationProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentsAnalysisByExaminationResponse? studentsAnalysisResponse;
  List<AnalysisData>? analysisData;
  List<SubjectAnalysisData>? subjectAnalysisData;

  List<SubjectAnalysisData> get subjectData => studentsAnalysisResponse?.data1 ?? [];
  final Map<String, bool> _expandedSubjects = {};


  Future<void> getStudentsAnalysisByExamination(
    String examId,
    String regNo,
    String fromYear,
    String toYear,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      
      final body = {
        "sl": examId,
        "sid": 0,
        "regno": regNo,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": ""
      };

      final data = await postRequest(ApiEndpoints.getStudentsAnalysisByExamination, body);

      if (data != null) {
        final analysisResponse = StudentsAnalysisByExaminationResponse.fromJson(data);
        studentsAnalysisResponse = analysisResponse;
        analysisData = analysisResponse.data;
        subjectAnalysisData = analysisResponse.data1;
        notifyListeners();
      }
    } catch (e) {
      log("This is the error for the students analysis by examination: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get overall analysis data (data field)
  AnalysisData? getOverallAnalysis() {
    try {
      return analysisData?.first;
    } catch (e) {
      return null;
    }
  }

  // Get subject-wise analysis data (data1 field)
  List<SubjectAnalysisData>? getSubjectAnalysis() {
    return subjectAnalysisData;
  }

  // Get specific subject analysis by subject name
  SubjectAnalysisData? getSubjectAnalysisByName(String subjectName) {
    try {
      return subjectAnalysisData?.firstWhere(
        (subject) => subject.subName == subjectName,
      );
    } catch (e) {
      return null;
    }
  }

  // Get rank information
  String? getSectionRank() {
    try {
      return analysisData?.first.sectionRank;
    } catch (e) {
      return null;
    }
  }

  bool isSubjectExpanded(String subjectId) {
    return _expandedSubjects[subjectId] ?? true;
  }

  void toggleSubjectExpansion(String subjectId) {
    _expandedSubjects[subjectId] = !(_expandedSubjects[subjectId] ?? false);
    notifyListeners();
  }

  // Check if subject has groups
  bool hasSubjectGroups(SubjectAnalysisData subject) {
    return subject.subjectGroup.isNotEmpty;
  }

  String? getClassRank() {
    try {
      return analysisData?.first.classRank;
    } catch (e) {
      return null;
    }
  }

  // Get percentage information
  String? getExamPercentage() {
    try {
      return analysisData?.first.examPercent;
    } catch (e) {
      return null;
    }
  }

  String? getClassAverage() {
    try {
      return analysisData?.first.classAverage;
    } catch (e) {
      return null;
    }
  }

  // Get marks information
  String? getObtainedMarks() {
    try {
      return analysisData?.first.markObtain;
    } catch (e) {
      return null;
    }
  }

  String? getTotalMarks() {
    try {
      return analysisData?.first.examTotal;
    } catch (e) {
      return null;
    }
  }

  String? getSubjectCount() {
    try {
      return analysisData?.first.subjectCount;
    } catch (e) {
      return null;
    }
  }

  // Check if data is available
  bool get hasData => studentsAnalysisResponse != null;
  bool get hasAnalysisData => analysisData != null && analysisData!.isNotEmpty;
  bool get hasSubjectData => subjectAnalysisData != null && subjectAnalysisData!.isNotEmpty;
}