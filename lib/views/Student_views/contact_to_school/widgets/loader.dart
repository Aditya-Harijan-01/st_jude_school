import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/colors.dart';

Widget buildConcernListShimmer() {
  return ListView.builder(
    padding: EdgeInsets.all(16.w),
    itemCount: 12, // number of shimmer items
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: CustomColor.colorWhite,
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12.h,
              width: 100.w,
              color: CustomColor.colorWhite,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 10.h,
                width: 180.w,
                color: CustomColor.colorWhite,
              ),
            ),
          ),
          trailing: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 10.h,
              width: 40.w,
              color: CustomColor.colorWhite,
            ),
          ),
        ),
      );
    },
  );
}
