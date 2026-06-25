import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSalaryShimmer() {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: 6, // number of shimmer items
      itemBuilder: (context, index) => _buildShimmerCard(),
    ),
  );
}

Widget _buildShimmerCard() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade300, width: 1.2.w),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month + Pay Slip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 120.w, height: 18.h),
              _shimmerBox(width: 80.w, height: 18.h),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 100.w, height: 16.h),
              _shimmerBox(width: 60.w, height: 16.h),
            ],
          ),

          SizedBox(height: 6.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 100.w, height: 16.h),
              _shimmerBox(width: 60.w, height: 16.h),
            ],
          ),

          SizedBox(height: 12.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 100.w, height: 18.h),
                _shimmerBox(width: 60.w, height: 18.h),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _shimmerBox({required double width, required double height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6.r),
    ),
  );
}
