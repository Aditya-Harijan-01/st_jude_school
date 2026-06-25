import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TimetableCardShimmer extends StatelessWidget {
  const TimetableCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        bool hasMultipleItems = index % 2 == 0; // just to show variation

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: hasMultipleItems
                    ? CustomColor.barYellow
                    : CustomColor.primaryColor,
                width: 6.w,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject shimmer
                      _buildShimmerBox(width: 150.w, height: 22.h),
                      SizedBox(height: 8.h),

                      // Row for teacher shimmer
                      Row(
                        children: [
                          // Teacher image shimmer
                          _buildCircleShimmer(radius: 18.r),
                          SizedBox(width: 10.w),
                          // Teacher name shimmer
                          _buildShimmerBox(width: 100.w, height: 16.h),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Period and Time shimmer block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildShimmerBox(width: 75.w, height: 20.h),
                    SizedBox(height: 8.h),
                    _buildShimmerBox(width: 75.w, height: 40.h),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Reusable shimmer box ---
  Widget _buildShimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
    );
  }

  // --- Circle shimmer (for image) ---
  Widget _buildCircleShimmer({required double radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
      ),
    );
  }
}
