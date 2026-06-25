// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/Students/student_analysis_by_examination.dart';
import '../../../../providers/student/students_analysis_by_examination_provider.dart';
import '../../../../widgets/p_color_progress.dart';
import '../../../Student_views/assessments/widgets/analysis_shimmer.dart';
import '../../../Student_views/assessments/widgets/subject_analysis_chart.dart';
import '../../../Student_views/attendance/widgets/tree_line_from_DS_report.dart';


class ExamAnalysisDetailScreenEmp extends StatefulWidget {
  final String regNo;
  final String examId;
  final String examName;
  final String toYear;
  final String fromYear;

  const ExamAnalysisDetailScreenEmp({
    super.key,
    required this.examId,
    required this.examName,
    required this.toYear,
    required this.fromYear,
    required this.regNo,
  });

  @override
  State<ExamAnalysisDetailScreenEmp> createState() => _ExamAnalysisDetailScreenState();
}

class _ExamAnalysisDetailScreenState extends State<ExamAnalysisDetailScreenEmp> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchExamAnalysis());
  }

  Future<void> _fetchExamAnalysis() async {
    try {
      final analysisProvider = Provider.of<StudentsAnalysisByExaminationProvider>(context, listen: false);

      await analysisProvider.getStudentsAnalysisByExamination(
        widget.examId,
        widget.regNo,
        widget.fromYear,
        widget.toYear,
      );

    } catch (e, s) {
      log('Error fetching exam analysis: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentsAnalysisByExaminationProvider>(
      builder: (context, analysisProvider, child) {
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
                "${widget.examName} Analysis",
                style:TextStyle(fontWeight: FontWeight.w600, color: CustomColor.colorWhite, fontSize: 20.sp)
            ),
            centerTitle: true,
            backgroundColor: CustomColor.primaryColor,
            elevation: 0,
          ),
          body: analysisProvider.isLoading
              ? AnalysisShimmer()
              : RefreshIndicator(
            onRefresh: _fetchExamAnalysis,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewSection(analysisProvider),
                    SizedBox(height: 20.h),
                    SubjectAnalysisChart(
                      subjectAnalysisData: analysisProvider.getSubjectAnalysis() ?? [],
                    ),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: analysisProvider.subjectData.length,
                      itemBuilder: (context, index) {
                        return _buildSubjectCard( analysisProvider.subjectData[index], analysisProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildSubjectCard(SubjectAnalysisData subject, StudentsAnalysisByExaminationProvider analysisProvider) {
    final marks = subject.subAggrMark;
    final fullMarks = subject.subAggrFull;
    final rank = subject.subRank;
    final subjectName = subject.subName;
    final hasGroups = subject.subjectGroup.isNotEmpty;
    final isExpanded = analysisProvider.isSubjectExpanded(subject.aggrId);
    final marksDouble = double.tryParse(marks) ?? 0;
    final fullMarksDouble = double.tryParse(fullMarks) ?? 1;
    final percentage = (marksDouble / fullMarksDouble) * 100;

    Color percentageColor = pColor(percentage);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: CustomColor.primaryColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: hasGroups ? () => analysisProvider.toggleSubjectExpansion(subject.aggrId) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:  EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),

              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Rank',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        rank,
                        style:  TextStyle(
                          color: CustomColor.secondaryColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 50.h,
                    width: 1,
                    color: CustomColor.colorGrey.withOpacity(0.5),
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                  ),

                  // Subject Name Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          style: TextStyle(
                            color: CustomColor.colorBlack,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$marks/$fullMarks',
                        style: TextStyle(
                          color: percentageColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          if (hasGroups && isExpanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:  BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 1.h,
                    color: Colors.grey[300],
                  ),
                  ...subject.subjectGroup.asMap().entries.map((entry) {
                    int index = entry.key;
                    SubjectGroupItem group = entry.value;
                    bool isLast = index == subject.subjectGroup.length - 1;
                    return _buildSubjectGroupItem(group, isLast);
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectGroupItem(SubjectGroupItem group, bool isLast) {
    final obtainedMarks = group.subObtainMark ;
    final fullMarks = group.subFullMark;
    final groupName = group.subName;

    return Container(
      padding: EdgeInsets.only(bottom: isLast? 3.h: 0,top: 0, right: 12.w, left:  12.w),


      child: Row(
        children: [
          SizedBox(width: 32.w),
          // Tree structure lines
          SizedBox(
            width:  20.w,
            child: CustomPaint(
              painter: TreeLinePainter(isLast: isLast),
              size: Size( 12.w, 30),
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' $groupName',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$obtainedMarks/$fullMarks',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildOverviewSection(StudentsAnalysisByExaminationProvider analysisProvider) {
    final overallAnalysis = analysisProvider.getOverallAnalysis();


    if (overallAnalysis == null) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              // A slightly more noticeable, modern shadow
              color: CustomColor.colorBlack.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Overview',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'No analysis data available',
                style: TextStyle(color: CustomColor.colorGrey),
              ),
            ),
          ],
        ),
      );
    }
    final double percentage = double.tryParse(overallAnalysis.examPercent) ?? 0;


    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exam Overview',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${overallAnalysis.examPercent}%',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: pColor(percentage)
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: pColor(percentage).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: pColor(percentage).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: pColor(percentage).withOpacity(0.15),
                  child: Icon(
                    Icons.grade,
                    size: 22.sp,
                    color: pColor(percentage),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Mark Obtained',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: pColor(percentage),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                Text(
                  '${overallAnalysis.markObtain}/${overallAnalysis.examTotal}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: pColor(percentage),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Class Average',
                  '${overallAnalysis.classAverage}%',
                  Icons.trending_up,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildInfoCard(
                  'Section Rank',
                  overallAnalysis.sectionRank,
                  Icons.emoji_events,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildInfoCard(
                  'Class Rank',
                  overallAnalysis.classRank,
                  Icons.workspace_premium,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _buildInfoCard(
                  'Subjects',
                  overallAnalysis.subjectCount,
                  Icons.menu_book_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: CustomColor.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: CustomColor.primaryColor.withOpacity(0.15),
            child: Icon(
              icon,
              size: 22.sp,
              color: CustomColor.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp, // Increased size
              color: CustomColor.primaryColor, // Use primary color
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,

          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2, // Allow title to wrap if needed
          ),
        ],
      ),
    );
  }
}