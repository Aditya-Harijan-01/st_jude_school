import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'activity_item.dart';

class FoodSection extends StatelessWidget {
  const FoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Food',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
         SizedBox(height: 16.h),
        ActivityItem(
          icon: Icons.restaurant,
          iconColor: Colors.orange,
          time: '08:00',
          title: 'She finished her breakfast🥞',
          subtitle: 'Scheduled activity',
        ),
      ],
    );
  }
}