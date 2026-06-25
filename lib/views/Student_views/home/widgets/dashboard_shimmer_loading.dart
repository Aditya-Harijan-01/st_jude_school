
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmerLoading extends StatelessWidget {
  const DashboardShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w), // Matches broad layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssignmentShimmer(),
            AssignmentShimmer(),
          ],
        ),
      ),
    );
  }

}

class AssignmentShimmer extends StatelessWidget {
  const AssignmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(  
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                _buildShimmerBox(30.w, 30.w, isCircle: true),
                SizedBox(width: 12.w),
                _buildShimmerBox(100.w, 20.h),
                const Spacer(),
                _buildShimmerBox(20.w, 20.w),
              ],
            ),
          ),
          _buildAssignmentCard(),
          SizedBox(height: 12.h),
          _buildAssignmentCard(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(120.w, 18.h),
                    SizedBox(height: 8.h),
                    _buildShimmerBox(200.w, 14.h),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildShimmerBox(24.w, 24.w, isCircle: true),
              SizedBox(width: 8.w),
              _buildShimmerBox(100.w, 14.h),
              const Spacer(),
              _buildShimmerBox(20.w, 20.w),
              SizedBox(width: 8.w),
              _buildShimmerBox(100.w, 14.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {bool isCircle = false}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isCircle
              ? BorderRadius.circular(width / 2)
              : BorderRadius.circular(6.r),
        ),
      ),
    );
  }
}

// Example usage in your app
class AssignmentShimmerDemo extends StatelessWidget {
  const AssignmentShimmerDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Assignment Shimmer'),
        backgroundColor: Colors.orange.shade400,
      ),
      body: const SingleChildScrollView(
        child: AssignmentShimmer(),
      ),
    );
  }
}

