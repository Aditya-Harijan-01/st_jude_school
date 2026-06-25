// ignore_for_file: deprecated_member_use

import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LeaveCardShimmer extends StatelessWidget {
  const LeaveCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    Widget box({double? w, double? h, BorderRadius? br}) => Container(
          width: w,
          height: h ?? 12.h,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: br ?? BorderRadius.circular(4.r),
          ),
        );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColor.primaryColor, width: 0.5.w),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.2),
            spreadRadius: 1.r,
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              box(w: 80.w, h: 14.h),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      box(w: 30.w, h: 10.h),
                      SizedBox(height: 6.h),
                      box(w: 35.w, h: 12.h),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              ClipRRect(
                borderRadius: BorderRadius.circular(3.r),
                child: SizedBox(
                  height: 6.h,
                  child: Row(
                    children: [
                      Expanded(child: Container(color: baseColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
