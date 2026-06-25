import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading skeleton for the Transport Form header
class TransportFormShimmer extends StatelessWidget {
  const TransportFormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚌 Bus icon shimmer
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 80.sp,
                width: 80.sp,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // 💬 Text shimmer line
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 16.h,
              width: 220.w,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8.h),
            ),
          ),

          // Optional secondary line shimmer for realism
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12.h,
              width: 150.w,
              color: Colors.white,
              margin: EdgeInsets.only(top: 4.h),
            ),
          ),
        ],
      ),
    );
  }
}
