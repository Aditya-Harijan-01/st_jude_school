import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/Students/student_report_cards.dart';
import '../../../../widgets/p_color_progress.dart';
import 'download_report.dart';

class ReportExamCard extends StatelessWidget {
  final String reportID;
  final String examName;
  final String marks;
  final String percentage;
  final String to;
  final String from;
  final ReportCard? reportCard;
  final VoidCallback? onTap;
  final String regNo;
  final bool isDownload;

  const ReportExamCard({
    super.key,
    required this.examName,
    required this.marks,
    required this.percentage,
    this.reportCard,
    this.onTap,
    required this.reportID,
    required this.to,
    required this.from,
    required this.regNo,
    required this.isDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isDownload) ...[
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  Icons.file_download_outlined,
                  size: 30.sp,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await downloadReportCard(regNo, reportID, to, from, context);
                },
              ),
              SizedBox(width: 12.sp),
            ] else ...[
              SizedBox.shrink(),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examName,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "$marks Marks",
                      style: TextStyle(color: Colors.black54, fontSize: 16.sp),
                    ),
                    SizedBox(width: 30.w),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: pColor(double.parse(percentage)),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color: CustomColor.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
