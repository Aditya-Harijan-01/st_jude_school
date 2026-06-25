import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/student/get_session.dart';
import '../../../../providers/student/students_report_cards_provider.dart';
import '../../../Student_views/assessments/widgets/assesment_shimmer.dart';
import '../../../Student_views/assessments/widgets/exam_details_chart.dart';
import '../../../Student_views/assessments/widgets/report_exam_card.dart';
import 'exam_analysis_detail_screen_emp.dart';
import 'widgets/bottom_report.dart';


class AssessmentScreenFromEmp  extends StatefulWidget {
  final String name;
  final String regNo;
  final String tYear;
  final String fYear;
  const AssessmentScreenFromEmp({super.key, required this.regNo, required this.tYear, required this.fYear, required this.name});

  @override
  State<AssessmentScreenFromEmp> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreenFromEmp> {
  String toYear = '';
  String fromYear = '';

  @override
  void initState() {
    super.initState();
    toYear = widget.tYear;
    fromYear = widget.fYear;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionLoad(fromYear, toYear);
      _fetchReports();
    } );
  }

  Future<void> _sessionLoad(String fYear, String tYear) async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    sessProvider.selectedSession2 = null;
    await sessProvider.getSessionSecondary(widget.regNo, fYear, tYear, "Student");
  }

  Future<void> _fetchReports() async {
    try {
      final report = Provider.of<StudentsReportCardsProvider>(context, listen: false);

      await report.getStudentsReportCards(widget.regNo, fromYear, toYear);

    } catch (e, s) {
      log('Error fetching assignments: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
        return Consumer2<StudentsReportCardsProvider, SessionProvider>(
          builder: (context, reportProvider, ss, child) {
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
                style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
            ),
            centerTitle: true,
            backgroundColor: CustomColor.primaryColor,
            elevation: 0,
          ),
          body:  reportProvider.isLoading
            ? AssessmentShimmer()
            : Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExamDetailsChart(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 5.w),
                      child: Text(
                        'Report Cards',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    if (reportProvider.reportCards != null && reportProvider.reportCards!.isNotEmpty)
                      SizedBox(
                        height: 350.h,
                        child: ListView.builder(
                          itemCount: reportProvider.reportCards!.length,
                          itemBuilder: (context, index) {
                            final reportCard = reportProvider.reportCards![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: ReportExamCard(
                                regNo: widget.regNo,
                                examName: reportCard.examName.replaceAll(' ', '\n'),
                                marks: "${reportCard.examObtain}/${reportCard.examTotal}",
                                percentage: reportCard.examPercent,
                                reportCard: reportCard,
                                isDownload: reportCard.isDownload,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExamAnalysisDetailScreenEmp(
                                        examId: reportCard.hostExamId,
                                        examName: reportCard.examName, toYear: toYear, fromYear: fromYear, regNo: widget.regNo,
                                      ),
                                    ),
                                  );
                                }, reportID: reportCard.reportId, to: toYear, from: fromYear,
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

          bottomSheet:
            !ss.isLoading ? ReportBottomEmp(
            onSessionChange: (from, to)
            async {
              setState(() {
                toYear=to;
                fromYear=from;
              });
            await _fetchReports();
          },percentage: reportProvider.getStudentPercentage(), loading: reportProvider.isLoading, name: widget.name, fYear: fromYear, tYear: toYear,)
              : SizedBox.shrink(),
        );
          },
        );
  }
}
