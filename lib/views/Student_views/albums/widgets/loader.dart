import 'package:carousel_slider/carousel_slider.dart';
import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';


Widget buildAlbumShimmer() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
    child: CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (context, index, realIdx) {
        return BodyShimmer();
      },
      options: CarouselOptions(
        height: 800.h,
        enlargeCenterPage: true,
        enlargeFactor: 0.175,
        viewportFraction: 0.85,
        enableInfiniteScroll: false,
        autoPlay: false,
      ),
    ),
  ); 
}

class BodyShimmer extends StatelessWidget {
  const BodyShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        height: 800.h,
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inner content shimmer
              Container(
                height: 560.h,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerRow(
                      children: [
                        _buildBox(150.h, 200.w),
                        _buildBox(150.h, 90.w),
                      ],
                    ),
                    _buildShimmerRow(
                      children: [
                        _buildBox(150.h, 90.w),
                        _buildBox(150.h, 200.w),
                      ],
                    ),
                    _buildShimmerRow(
                      children: [
                        _buildBox(150.h, 150.w),
                        _buildBox(150.h, 145.w),
                      ],
                    ),
                    _buildShimmerBox(40.h, double.infinity, margin: const EdgeInsets.symmetric(horizontal: 20)),
                  ],
                ),
              ),
    
              // Footer shimmer
              Container(
                height: 180.h,
                width: double.infinity,
                // color: Colors.grey.shade200,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerBox(24.h, 250.w),
                    _buildShimmerBox(24.h, 220.w),
                    _buildShimmerBox(24.h, 150.w),
                    SizedBox(height: 5.h),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBox(40.h, 40.w),
                            _buildBox(40.h, 160.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Helper: Common shimmer row builder
Widget _buildShimmerRow({required List<Widget> children}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    ),
  );
}

/// 🔹 Helper: Simple shimmer box
Widget _buildShimmerBox(double height, double width, {EdgeInsets? margin}) {
  return Padding(
    padding: margin ?? const EdgeInsets.only(left: 20, right: 20, bottom: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: _buildBox(height, width),
    ),
  );
}

/// 🔹 Helper: Base box container
Widget _buildBox(double height, double width) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: CustomColor.colorWhite,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
