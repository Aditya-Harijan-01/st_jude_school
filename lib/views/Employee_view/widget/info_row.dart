

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';

Widget infoRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 95.w,
        child: Text(
          "$label:",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}



