import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';

class NotificationShimmerCard extends StatelessWidget {
  const NotificationShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: CustomColor.primaryOne,
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
                color: CustomColor.colorShadow,
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE ROW
                Row(
                  children: [
                    _box(20.w, 20.w, radius: 4),
                    SizedBox(width: 10.w),
                    Expanded(child: _box(double.infinity, 14.h)),
                  ],
                ),

                SizedBox(height: 10.h),

                /// MESSAGE LINES
                _box(double.infinity, 12.h),
                SizedBox(height: 6.h),
                _box(double.infinity, 12.h),
                SizedBox(height: 6.h),
                _box(180.w, 12.h),

                SizedBox(height: 12.h),

                /// READ MORE
                _box(80.w, 12.h),

                SizedBox(height: 14.h),

                /// FOOTER ROW
                Row(
                  children: [
                    /// PROFILE
                    _box(28.w, 28.w, radius: 50),
                    SizedBox(width: 6.w),
                    Expanded(child: _box(100.w, 12.h)),
                    Spacer(),
                    _box(80.w, 12.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _box(double width, double height, {double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
