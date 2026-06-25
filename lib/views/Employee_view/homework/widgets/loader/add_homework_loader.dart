import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AddHomeworkShimmer extends StatelessWidget {
  const AddHomeworkShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(height: 18, width: 140),      // Teacher type text
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Class dropdown
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Subject dropdown
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Book dropdown
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Chapter box
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Issue Date
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // Submission Date
            SizedBox(height: 16.h),

            shimmerBox(height: 50),                  // File picker
            SizedBox(height: 16.h),

            shimmerBox(height: 120),                 // Details
            SizedBox(height: 30.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerBox(height: 45, width: 120),  // Cancel Button
                shimmerBox(height: 45, width: 120),  // Save Button
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget shimmerBox({double height = 20, double width = double.infinity, double radius = 8}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
