// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';

class LeaveCalendarShimmerWidget extends StatelessWidget {
  const LeaveCalendarShimmerWidget({super.key});

  /// --- Shimmer Box (Reusable)
  Widget buildShimmerBox({double height = 14, double width = 60}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  /// --- Shimmer Card
  Widget shimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(width: 1, color: CustomColor.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildShimmerBox(
            height: 20.h, 
            width: 150.w
          ),
          SizedBox(
            height: 8.h
          ),
          buildShimmerBox(
            height: 14.h,
            width: 200.w
          ),
          SizedBox(
            height: 16.h
          ),

          /// --- Inner Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5.w, 
                color: CustomColor.primaryColor
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.w),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 2, child: Center(child: buildShimmerBox(width: 60))),
                        Expanded(flex: 2, child: Center(child: buildShimmerBox(width: 60))),
                        Expanded(flex: 2, child: Center(child: buildShimmerBox(width: 60))),
                        Expanded(flex: 1, child: Center(child: buildShimmerBox(width: 30))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => shimmerCard(),
    );
  }
}
