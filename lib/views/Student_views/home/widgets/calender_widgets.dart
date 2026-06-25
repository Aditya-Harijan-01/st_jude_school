import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

Widget buildCalendarInfoCard({
  required Color color,
  required String title,
  required String date,
  required List<dynamic> children,
}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          color: CustomColor.primaryColor,
          width: 4,
        ),
      ),
      color: color,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: CustomColor.primaryColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_note_rounded, color: CustomColor.primaryColor, size: 36.sp),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ...children,
      ],
    ),
  );
}
Widget buildInfoRow(String text) {
  return Container(
    padding: EdgeInsets.all( 10.w),
    margin: EdgeInsets.only(bottom: 4.h),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r)
    ),
    child: Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          size: 21.sp,
          color: CustomColor.secondaryColor,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text == '' ? 'N/A' : text ,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
