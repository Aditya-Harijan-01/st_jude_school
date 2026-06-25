// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/emp_student_attendence.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentAttendance student;
  final VoidCallback? onToggle;

  const StudentAttendanceCard({
    super.key,
    required this.student,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final canMarkAttendance = student.canMarkAttendance;
    final isPresent = student.isPresent;

    return Container(
      margin: EdgeInsets.only(bottom: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Registration Number
          SizedBox(
            width: 50.w,
            child: Text(
              student.regno,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: CustomColor.colorBlack.withOpacity(0.65),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Student Name with Roll Number
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: student.studentName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: CustomColor.colorBlack.withOpacity(0.75),
                    ),
                  ),
                  if (student.rollno.isNotEmpty && student.rollno != '0')
                    TextSpan(
                      text: ' (${student.rollno})',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Attendance Toggle Switch
          if (canMarkAttendance)
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: isPresent,
                onChanged: onToggle != null ? (_) => onToggle!() : null,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red.withOpacity(0.3),
                activeTrackColor: Colors.green.withOpacity(0.3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )
          else
          // TC Student Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                'TC',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
