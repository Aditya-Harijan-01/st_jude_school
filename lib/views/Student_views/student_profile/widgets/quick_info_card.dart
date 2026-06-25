import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickInfoCard extends StatelessWidget {
  final IconData icon;
  // final String title;
  final String value;
  final Color customColor;

  const QuickInfoCard({
    super.key,
    required this.icon,
    // required this.title,
    required this.value,
    required this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: customColor.withAlpha(60),
            ),
            padding: EdgeInsets.all(10.w),
            child: Icon(icon, size: 24.sp, color: customColor,)
          ),
          SizedBox(
            height: 6.h
          ),
          // Text(
          //   title,
          //   style: TextStyle(
          //     fontSize: 14.sp,
          //     color: CustomColor.colorGrey
          //   ),
          // ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
