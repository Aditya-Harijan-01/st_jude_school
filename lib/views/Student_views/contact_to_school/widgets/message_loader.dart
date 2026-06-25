import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';

class MessageContainerShimmer extends StatelessWidget {
  const MessageContainerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorGrey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // 🔹 Shimmer only inside (for all inner items)
      child: Shimmer.fromColors(
        // ignore: deprecated_member_use
        baseColor: CustomColor.colorGrey.withOpacity(0.3),
        // ignore: deprecated_member_use
        highlightColor: CustomColor.colorGrey.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟦 Line 1
            _buildShimmerBox(width: 220.w, height: 14.h),
            SizedBox(height: 10.h),
            // 🟦 Line 2
            _buildShimmerBox(width: 280.w, height: 12.h),
            SizedBox(height: 16.h),

            Row(
              children: [
                // 🟦 Avatar
                _buildCircleShimmer(size: 36.r),
                SizedBox(width: 8.w),

                // 🟦 Left-side details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: 100.w, height: 12.h),
                    SizedBox(height: 6.h),
                    _buildShimmerBox(width: 80.w, height: 10.h),
                  ],
                ),

                const Spacer(),

                // 🟦 Right-side details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildShimmerBox(width: 70.w, height: 10.h),
                    SizedBox(height: 6.h),
                    _buildShimmerBox(width: 60.w, height: 10.h),
                  ],
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // 🟦 Add a few more placeholders to simulate message metadata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerBox(width: 120.w, height: 12.h),
                _buildShimmerBox(width: 80.w, height: 12.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Helper for rectangular shimmer elements
  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }

  /// 🔹 Helper for circular shimmer (like avatar)
  Widget _buildCircleShimmer({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
