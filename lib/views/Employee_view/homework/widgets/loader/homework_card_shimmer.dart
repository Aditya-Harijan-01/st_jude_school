// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants/colors.dart';

class HomeworkCardShimmer extends StatelessWidget {
  const HomeworkCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: CustomColor.primaryColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dates Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(height: 12, width: 120),
                  _shimmerBox(height: 12, width: 120),
                ],
              ),
              const SizedBox(height: 10),

              // Subject
              _shimmerBox(height: 20, width: 180),
              const SizedBox(height: 8),

              // Chapter
              _shimmerBox(height: 16, width: 200),
              const SizedBox(height: 12),

              // View Button
              Align(
                alignment: Alignment.centerRight,
                child: _shimmerBox(height: 30, width: 80, radius: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({double height = 14, double width = double.infinity, double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
