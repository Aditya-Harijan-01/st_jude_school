import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../constants/colors.dart';
import '../../../../widgets/info_card_shimmer.dart';
import '../../../../widgets/chart_shimmer.dart';

class AssessmentShimmer extends StatelessWidget {
  const AssessmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          ChartShimmer(),
          SizedBox(height: 30.h),
          InfoCardShimmer(),
          SizedBox(height: 12.h),
          InfoCardShimmer(),
          SizedBox(height: 12.h),
          InfoCardShimmer(),
          SizedBox(height: 12.h),
          InfoCardShimmer(),
          SizedBox(height: 12.h),
          InfoCardShimmer(),
        ],
      ),
    );
  }
}

