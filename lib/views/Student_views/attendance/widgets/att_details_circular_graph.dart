import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../constants/colors.dart';

class AttDetailsCircularGraph extends StatelessWidget {
  final String title;
  final String percentage;
  final int presentDays;
  final int totalDays;
  final List<ChartAttendanceMonth> chartData;

  const AttDetailsCircularGraph({
    super.key,
    required this.title,
    required this.percentage,
    required this.presentDays,
    required this.totalDays,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Chart
              SizedBox(
                width: 170.w,
                height: 170.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 55.r,
                        startDegreeOffset: -90,
                        sections: chartData.map((data) {
                          final bool isPresent = data.x == 'Present';
                          return PieChartSectionData(
                            value: data.y,
                            color: isPresent
                                ?  CustomColor.primaryColor
                                : Colors.grey.shade200,
                            radius: 30.r,
                            showTitle: false,
                          );
                        }).toList(),
                        pieTouchData: PieTouchData(enabled: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          percentage,
                          style: TextStyle(
                            color: CustomColor.primaryColor,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Legend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: CustomColor.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Present',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Text(
                        '$presentDays Days',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Total Class',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '$totalDays Days',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartAttendanceMonth {
  ChartAttendanceMonth(this.x, this.y);
  final String x;
  final double y;
}