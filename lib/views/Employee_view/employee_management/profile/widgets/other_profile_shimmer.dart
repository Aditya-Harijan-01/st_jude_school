// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../constants/colors.dart';

class OtherProfileShimmer extends StatelessWidget {
  const OtherProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryOne,
      body: SizedBox(
        width: double.infinity,
        height: 1.sh,
        child: Column(
          children: [
            SizedBox(height: 60.h),
            // Centered Header Shimmer
            _buildHeaderShimmer(),
            SizedBox(height: 20.h),
            // Content Card Shimmer
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: CustomColor.colorWhite,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      // Title placeholder
                      Container(
                        width: 150.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: CustomColor.colorWhite,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Tab placeholders
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) => Container(
                          width: 80.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: CustomColor.colorWhite,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        )),
                      ),
                      SizedBox(height: 20.h),
                      // Content lines
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: List.generate(6, (index) => Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: CustomColor.colorWhite,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: Container(
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: CustomColor.colorWhite,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar Shimmer
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight + 10.h,
        color: CustomColor.colorWhite,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: CustomColor.colorWhite,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 40.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: CustomColor.colorWhite.withOpacity(0.3),
      highlightColor: CustomColor.colorWhite.withOpacity(0.1),
      child: Column(
        children: [
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: 180.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 120.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
