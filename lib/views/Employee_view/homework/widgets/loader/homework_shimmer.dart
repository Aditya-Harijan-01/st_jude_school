
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants/colors.dart';

class AddHomeworkShimmerWidget extends StatelessWidget {
  const AddHomeworkShimmerWidget({super.key});

  Widget _shimmerContainer({double height = 48, double width = double.infinity, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerLabel() {
    return _shimmerContainer(height: 14, width: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: CustomColor.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerContainer(height: 20, width: 150), // Teacher type label
              const SizedBox(height: 16),
              _shimmerContainer(height: 48), // Class dropdown
              const SizedBox(height: 16),
              _shimmerContainer(height: 48), // Subject dropdown
              const SizedBox(height: 16),
              _shimmerContainer(height: 48), // Book dropdown
              const SizedBox(height: 16),
              _shimmerLabel(),
              const SizedBox(height: 6),
              _shimmerContainer(height: 48), // Multi-select
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerLabel(),
                        const SizedBox(height: 6),
                        _shimmerContainer(height: 48),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerLabel(),
                        const SizedBox(height: 6),
                        _shimmerContainer(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerLabel(),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: _shimmerContainer(height: 48)),
                  const SizedBox(width: 8),
                  _shimmerContainer(height: 48, width: 100),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerLabel(),
              const SizedBox(height: 6),
              _shimmerContainer(height: 120), // Homework details
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerContainer(height: 45, width: 125), // Cancel
                  _shimmerContainer(height: 45, width: 125), // Submit
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
