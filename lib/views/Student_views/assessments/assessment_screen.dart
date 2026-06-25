import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/students_report_cards_provider.dart';
import 'exam_analysis_detail_screen.dart';
import 'widgets/assesment_shimmer.dart';
import 'widgets/exam_details_chart.dart';
import 'widgets/report_bottom.dart';
import 'widgets/report_exam_card.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  String toYear = '';
  String fromYear = '';
  String userID = '';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    toYear = auth.loginData!.currentyearto;
    fromYear = auth.loginData!.currentyearfrom;

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchReports());
  }

  Future<void> _fetchReports() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final report = Provider.of<StudentsReportCardsProvider>(
        context,
        listen: false,
      );
      userID = auth.loginData!.regno;

      await report.getStudentsReportCards(userID, fromYear, toYear);
    } catch (e, s) {
      log('Error fetching assignments: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentsReportCardsProvider>(
      builder: (context, reportProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: CustomColor.colorWhite,
                size: 20.sp,
              ),
            ),
            title: Text(
              "Assessment",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
            backgroundColor: CustomColor.primaryColor,
            elevation: 0,
          ),
          body: reportProvider.isLoading
              ? AssessmentShimmer()
              : Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExamDetailsChart(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 5.w,
                        ),
                        child: Text(
                          'Report Cards',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      if (reportProvider.reportCards != null &&
                          reportProvider.reportCards!.isNotEmpty)
                        SizedBox(
                          height: 350.h,
                          child: ListView.builder(
                            itemCount: reportProvider.reportCards!.length,
                            itemBuilder: (context, index) {
                              final reportCard =
                                  reportProvider.reportCards![index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: ReportExamCard(
                                  regNo: userID,
                                  examName: reportCard.examName.replaceAll(
                                    ' ',
                                    '\n',
                                  ),
                                  marks:
                                      "${reportCard.examObtain}/${reportCard.examTotal}",
                                  percentage: reportCard.examPercent,
                                  reportCard: reportCard,
                                  isDownload: reportCard.isDownload,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExamAnalysisDetailScreen(
                                              examId: reportCard.hostExamId,
                                              examName: reportCard.examName,
                                              toYear: toYear,
                                              fromYear: fromYear,
                                            ),
                                      ),
                                    );
                                  },
                                  reportID: reportCard.reportId,
                                  to: toYear,
                                  from: fromYear,
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.all(16.r),
                          child: Text(
                            'No report cards available',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

          bottomSheet: ReportBottom(
            onSessionChange: (from, to) async {
              setState(() {
                toYear = to;
                fromYear = from;
              });
              await _fetchReports();
            },
            percentage: reportProvider.getStudentPercentage(),
            loading: reportProvider.isLoading,
          ),
        );
      },
    );
  }
}
