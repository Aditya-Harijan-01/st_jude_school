import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';

Widget buildSyllabusTileShimmer() {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: CustomColor.colorWhite,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: CustomColor.colorShadow.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),

        SizedBox(width: 10.w),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 14.h,
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),

        SizedBox(width: 10.w),

        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20.h,
            width: 20.w,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  );
}
