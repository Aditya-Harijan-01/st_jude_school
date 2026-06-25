// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';

class EmpConcernTicketCardShimmer extends StatelessWidget {
  const EmpConcernTicketCardShimmer({
    super.key,
  });

  Widget _buildShimmerLine({double? width, double height = 14}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle({double size = 40}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: size.w,
        width: size.w,
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: CustomColor.primaryOne, // Matches the left border color
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: CustomColor.colorWhite,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: CustomColor.colorGrey.withOpacity(0.2),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Line
              _buildShimmerLine(width: 0.4.sw, height: 16),
              SizedBox(height: 12.h),

              // Content Lines
              _buildShimmerLine(height: 12),
              SizedBox(height: 6.h),
              _buildShimmerLine(width: 0.8.sw, height: 12),
              SizedBox(height: 6.h),
              _buildShimmerLine(width: 0.6.sw, height: 12),
              
              SizedBox(height: 16.h),

              // Footer Row (Sender & Time)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildShimmerCircle(size: 20),
                      SizedBox(width: 8.w),
                      _buildShimmerLine(width: 80, height: 12),
                    ],
                  ),
                  Row(
                    children: [
                      _buildShimmerCircle(size: 16),
                      SizedBox(width: 6.w),
                      _buildShimmerLine(width: 60, height: 12),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
