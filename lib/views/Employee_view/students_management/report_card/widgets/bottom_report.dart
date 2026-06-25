import '../../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/p_color_progress.dart';
import '../../Session/bottom_sheet_with_session.dart';


class ReportBottomEmp extends StatelessWidget {
  final String name;
  final String fYear;
  final String tYear;
  final String? percentage;
  final bool loading;
  final Future<void> Function(String from, String to)? onSessionChange;
  const ReportBottomEmp({super.key, required this.percentage, required this.loading, this.onSessionChange, required this.name, required this.fYear, required this.tYear});

  @override
  Widget build(BuildContext context) {
    final percentageValue = double.tryParse(percentage ?? '') ?? 0;
    final clampedValue = percentageValue.clamp(0, 100).toDouble();
    final widthFactor = (clampedValue / 100).clamp(0.0, 1.0);

    final barColor = pColor(clampedValue);

    return BottomSheet2(
      onSessionChange: onSessionChange,
      content: !loading
          ? Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
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
                    color: barColor,
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
                    backgroundColor: CustomColor.primaryColor,
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
                    'My Average',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${clampedValue.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: barColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
      name: name,
      fYear: fYear,
      tYear: tYear,
    );
  }
}
