// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

Widget buildSubTopic(String subtitle, String page, String period, String term) {
  return Container(
    margin: EdgeInsets.only(bottom: 8.h),
    decoration: BoxDecoration(
      color: CustomColor.primaryColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Colored left strip
          Container(
            width: 5.w,
            decoration: BoxDecoration(
              color: CustomColor.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.colorBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      /// PAGE
                      Flexible(
                        flex: 1,
                        child: Text(
                          page,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      /// PERIOD
                      Flexible(
                        flex: 1,
                        child: Text(
                          period,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 4.h),
                  // /// TERM CHIP
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8.r),
                  //     color: CustomColor.primaryColor.withOpacity(0.2),
                  //   ),
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 2.h,
                  //     horizontal: 10.w,
                  //   ),
                  //   child: Text(
                  //     term,
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(
                  //       fontSize: 12.sp,
                  //       color: CustomColor.primaryColor,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}