import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_report_cards.dart';
import '../common/common_post_method.dart';

class StudentsReportCardsProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentsReportCardsResponse? studentsReportCardsResponse;
  List<ReportCard>? reportCards;
  List<ReportCardSummary>? reportCardSummaries;

  Future<void> getStudentsReportCards(String reg, String fromYear, String toYear) async {
    try {
      isLoading = true;
      notifyListeners();
      
      final body = {
        "sl": "string",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": ""
      };

      final data = await postRequest(ApiEndpoints.getStudentsReportCards, body);

      if (data != null) {
        final reportCardsResponse = StudentsReportCardsResponse.fromJson(data);
        studentsReportCardsResponse = reportCardsResponse;
        reportCards = reportCardsResponse.data;
        reportCardSummaries = reportCardsResponse.data1;
        notifyListeners();
      }
    } catch (e) {
      log("This is the error for the students report cards: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? getStudentPercentage() {
    try {
      return reportCardSummaries
          ?.firstWhere((item) => item.percentHead == 'STUDENT_PER')
          .examPercent;
    } catch (e) {
      return null;
    }
  }

  String? getClassPercentage() {
    try {
      return reportCardSummaries
          ?.firstWhere((item) => item.percentHead == 'CLASS')
          .examPercent;
    } catch (e) {
      return null;
    }
  }

  String? getStudentAggregatePercentage() {
    try {
      return reportCardSummaries
          ?.firstWhere((item) => item.percentHead == 'STUDENT_AGGR_PER')
          .examPercent;
    } catch (e) {
      return null;
    }
  }

  ReportCardSummary? getSummaryByHead(String percentHead) {
    try {
      return reportCardSummaries
          ?.firstWhere((item) => item.percentHead == percentHead);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> downloadReportCard({
    required String regNo,
    required String reportId,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      final body = {
        "regno": regNo,
        "reportid": reportId,
        "fromyear": fromYear,
        "toyear": toYear,
        "optionValue": 0,
        "level": 1
      };

      final data = await postRequest(ApiEndpoints.getExaminationReportCard, body);
      return data;
    } catch (e) {
      log("Error downloading admit card: $e");
      return null;
    }
  }

  // Check if data is available
  bool get hasData => studentsReportCardsResponse != null;
  bool get hasSummaries => reportCardSummaries != null && reportCardSummaries!.isNotEmpty;
}