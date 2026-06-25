import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/emp_attendance_summary.dart';

class WeekStatusWidget extends StatelessWidget {
  final DateTime currentDate;
  final List<WeekStatus>? weekStatus;

  const WeekStatusWidget({
    super.key,
    required this.currentDate,
    required this.weekStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomColor.colorWhite,
            Color(0xFFC8F0E0),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CustomColor.lightPrGreen,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
             SizedBox(height: 14.h),
            _buildWeekStatusSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final day = currentDate.day;
    final month = _getMonthName(currentDate.month);
    final year = currentDate.year;
    final weekday = _getWeekdayName(currentDate.weekday);

    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$day',
                style: TextStyle(
                  fontSize: 56.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.primaryColor,
                  height: 1.h,
                ),
              ),
              TextSpan(
                text: 'th',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.primaryColor,
                  height: 1.h,
                ),
              ),
            ],
          ),
        ),
         SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekday,
                style:  TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$month $year',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: CustomColor.colorWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:  Icon(
            Icons.arrow_forward_ios,
            color: CustomColor.primaryColor,
            size: 20.r,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekStatusSection() {
    if (weekStatus == null || weekStatus!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This week status',
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF4A4A4A),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text('No data available'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This week status',
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xFF4A4A4A),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: weekStatus!.map((status) {
            return Row(
              children: [
                _buildDayStatusItemFromWeekStatus(status),
                SizedBox(width: 10.w),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayStatusItemFromWeekStatus(WeekStatus status) {
    String label;
    switch (status.dayName?.toLowerCase()) {
      case 'monday':
        label = 'M';
        break;
      case 'tuesday':
        label = 'T';
        break;
      case 'wednesday':
        label = 'W';
        break;
      case 'thursday':
        label = 'Th';
        break;
      case 'friday':
        label = 'Fr';
        break;
      case 'saturday':
        label = 'Sa';
        break;
      case 'sunday':
        label = 'Su';
        break;
      default:
        label = '?';
    }

    Color statusColor;
    IconData? icon;

    switch (status.status?.toLowerCase()) {
      case 'present':
        statusColor = CustomColor.primaryColor;
        icon = Icons.check;
        break;
      case 'absent':
        statusColor = Colors.red.shade700;
        icon = null;
        break;
      default:
        statusColor = Colors.grey.shade300;
        icon = null;
    }

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: 20.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
          child: icon != null
              ? Icon(
                  icon,
                  color: CustomColor.colorWhite,
                  size: 14.sp,
                )
              : status.status?.toLowerCase() == 'absent'
                  ? Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: CustomColor.colorWhite,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return weekdays[weekday - 1];
  }
}

enum DayStatus {
  completed,
  absent,
  pending,
}

