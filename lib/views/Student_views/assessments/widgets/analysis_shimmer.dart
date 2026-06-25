import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/info_card_shimmer.dart';
import '../../../../widgets/chart_shimmer.dart';
class OverviewSectionShimmer extends StatelessWidget {
  const OverviewSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorBlack.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBox(width: 120.w, height: 20.h, radius: 8),
                _buildBox(width: 50.w, height: 20.h, radius: 8),
              ],
            ),
            SizedBox(height: 20.h),

            // Mark Obtained box
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(width: 10.w),
                  _buildBox(width: 100.w, height: 18.h, radius: 6),
                  const Spacer(),
                  _buildBox(width: 60.w, height: 22.h, radius: 6),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // Info cards row
            Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Expanded(child: _buildInfoCardShimmer()),
                  if (i != 3) SizedBox(width: 6.w),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox({double? width, double? height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _buildInfoCardShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
          ),
          SizedBox(height: 12.h),
          _buildBox(width: 50.w, height: 22.h, radius: 6),
          SizedBox(height: 8.h),
          _buildBox(width: 70.w, height: 10.h, radius: 4),
        ],
      ),
    );
  }
}
class AnalysisShimmer extends StatelessWidget {
  const AnalysisShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          OverviewSectionShimmer(),
          SizedBox(height: 20.h),
          ChartShimmer(),
          SizedBox(height: 20.h),
          InfoCardShimmer(),
          SizedBox(height: 20.h),
          InfoCardShimmer(),
          SizedBox(height: 20.h),
          InfoCardShimmer(),

        ],
      ),
    );
  }
}


