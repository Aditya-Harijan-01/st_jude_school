// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/employee/emp_student_attendence.dart';

class AttendanceClassCard extends StatelessWidget {
  final AttendanceClass attendanceClass;
  final String selectedDate;
  final VoidCallback? onTap;

  const AttendanceClassCard({
    super.key,
    required this.attendanceClass,
    required this.selectedDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClickable = attendanceClass.isClickable;
    final color = _getColorFromHex(attendanceClass.fontColor);

    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isClickable ? onTap : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isClickable ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Class Name
                Expanded(
                  flex: 3,
                  child: Text(
                    attendanceClass.classDisplay,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),

                // Students Count
                Expanded(
                  flex: 1,
                  child: Text(
                    attendanceClass.totalStudent.isEmpty ? '-' : attendanceClass.totalStudent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Present Count
                Expanded(
                  flex: 1,
                  child: Text(
                    attendanceClass.totalPresent.isEmpty ? '-' : attendanceClass.totalPresent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Absent Count
                Expanded(
                  flex: 1,
                  child: Text(
                    attendanceClass.totalAbsent.isEmpty ? '-' : attendanceClass.totalAbsent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Arrow Icon (only for clickable classes)
                if (isClickable)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
