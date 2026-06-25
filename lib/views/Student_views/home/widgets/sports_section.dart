import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'activity_item.dart';

class SportsSection extends StatelessWidget {
  const SportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sports',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
         SizedBox(height: 16.h),
        ActivityItem(
          icon: Icons.directions_run,
          iconColor: Colors.blue,
          time: '08:45',
          title: 'Morning exercise done collectively',
          subtitle: 'idk what is this',
        ),
      ],
    );
  }
}