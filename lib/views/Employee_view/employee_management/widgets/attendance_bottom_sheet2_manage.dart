// import '../widget/common_bottom_sheet_emp.dart';
import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/p_color_progress.dart';
import '../../students_management/Session/bottom_sheet_with_session.dart';

class AttendanceBottomSheet2Manage extends StatelessWidget {
  final String percentage;
  final bool loading;
  final String name;
  final String fromYear;
  final String toYear;
  final Future<void> Function(String from, String to)? onSessionChange;

  const AttendanceBottomSheet2Manage({
    super.key,
    required this.percentage,
    this.onSessionChange,
    required this.loading,
    required this.name,
    required this.fromYear,
    required this.toYear,
  });

  @override
  Widget build(BuildContext context) {
    final percentageValue = double.tryParse(percentage) ?? 0;
    final widthFactor = (percentageValue / 100).clamp(0.0, 1.0);

    return BottomSheet2(
      onSessionChange: onSessionChange,
      emp: 'emp',
      content: !loading
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.h, top: 4.h),
                    width: double.infinity,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: widthFactor,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: pColor(double.parse(percentage)),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: CircleAvatar(
                          backgroundColor: CustomColor.attendanceGreen,
                          child: Icon(
                            Icons.area_chart,
                            color: CustomColor.colorWhite,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'My Attendance',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${percentageValue.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: pColor(double.parse(percentage)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
      name: name,
      fYear: fromYear,
      tYear: toYear,
    );
  }
}
