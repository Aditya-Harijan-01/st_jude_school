import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/colors.dart';

void showAccessDeniedDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.sp),
          SizedBox(width: 10.w),
          Text(
            'Access Restricted',
            style: TextStyle(
              fontSize: 21.sp,
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
      content: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Go Back',
            style: TextStyle(color: CustomColor.primaryColor),
          ),
        ),
      ],
    ),
  );
}
