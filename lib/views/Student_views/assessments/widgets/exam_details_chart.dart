import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../../providers/student/students_report_cards_provider.dart';
import '../../../../widgets/p_color_progress.dart';

class ExamDetailsChart extends StatelessWidget {
  const ExamDetailsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCardsProvider = Provider.of<StudentsReportCardsProvider>(
      context,
    );
    final reportCards = reportCardsProvider.reportCards ?? [];

    if (reportCards.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Details',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 200.h,
              child: const Center(child: Text('No exam data available')),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Details',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final exam = reportCards[groupIndex].examName;
                            final value = rod.toY;
                            return BarTooltipItem(
                              '$exam : ${value.toStringAsFixed(0)}',
                              TextStyle(
                                color: CustomColor.colorWhite,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < reportCards.length) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    reportCards[value.toInt()].examName
                                        .replaceAll(' ', '\n'),
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 30.h,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 25,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                            reservedSize: 35.w,
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[200],
                            strokeWidth: 1.w,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: reportCards.asMap().entries.map((entry) {
                        final index = entry.key;
                        final reportCard = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barsSpace: 0,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  double.tryParse(reportCard.examPercent) ??
                                  0.0,
                              color: pColor(
                                double.tryParse(reportCard.examPercent) ?? 0.0,
                              ),
                              width: 12.w,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.r),
                              ),
                            ),
                            BarChartRodData(
                              toY:
                                  double.tryParse(reportCard.examClassAvg) ??
                                  0.0,
                              color: CustomColor.secondaryColor,
                              width: 12.w,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.r),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: CustomColor.barYellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: CustomColor.colorRedAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'My Marks',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 20.w),
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: CustomColor.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Class Average',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
