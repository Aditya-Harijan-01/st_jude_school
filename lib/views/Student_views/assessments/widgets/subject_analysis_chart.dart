import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../models/Students/student_analysis_by_examination.dart';
import '../../../../widgets/p_color_progress.dart';

class SubjectAnalysisChart extends StatelessWidget {
  final List<SubjectAnalysisData> subjectAnalysisData;

  const SubjectAnalysisChart({super.key, required this.subjectAnalysisData});

  @override
  Widget build(BuildContext context) {
    if (subjectAnalysisData.isEmpty) {
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
              'Subject-wise Performance',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200.h,
              child: const Center(
                child: Text('No subject analysis data available'),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
            'Subject-wise Performance',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 180.h,
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
                            final subject = subjectAnalysisData[groupIndex];
                            final value = rod.toY;
                            return BarTooltipItem(
                              '${subject.subName}: ${value.toStringAsFixed(1)}%',
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
                                  value.toInt() < subjectAnalysisData.length) {
                                final subject =
                                    subjectAnalysisData[value.toInt()];
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      subject.subName,
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },

                            reservedSize: 40.h,
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
                      barGroups: subjectAnalysisData.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final subject = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barsSpace: 2.w,
                          barRods: [
                            BarChartRodData(
                              toY: double.tryParse(subject.subAggrPer) ?? 0.0,
                              color: pColor(
                                double.tryParse(subject.subAggrPer) ?? 0.0,
                              ),
                              width: 15.w,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.r),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
