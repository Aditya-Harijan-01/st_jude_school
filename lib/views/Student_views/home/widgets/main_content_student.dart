import 'package:st_jude_school/views/Student_views/home/emp_widget/main_content_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import 'week_calendar.dart';

class MainContentStudent extends StatelessWidget {
  final int selectedDayIndex;
  final Function(int) onDaySelected;
  final String? userType;

  const MainContentStudent({
    super.key,
    this.selectedDayIndex = 3,
    required this.onDaySelected,
    this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: userType == "Student"
                  ? WeekCalendar(
                      selectedDayIndex: selectedDayIndex,
                      onDaySelected: onDaySelected,
                    )
                  : WeekCalendarEmp(
                      selectedDayIndex: selectedDayIndex,
                      onDaySelected: onDaySelected,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
