import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

class TopToggleBar extends StatelessWidget {
  final String selectedTab;
  final int issuedCount;
  final int returnedCount;
  final List<String> title;
  final Function(String) onTabChange;

  const TopToggleBar({
    super.key,
    required this.selectedTab,
    required this.issuedCount,
    required this.returnedCount,
    required this.title,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab("1", title[0], issuedCount),
          SizedBox(width: 12.w),
          _buildTab("2", title[1], returnedCount),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, int count) {
    final isSelected = selectedTab == id;

    return GestureDetector(
      onTap: () => onTabChange(id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomColor.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(17.r)
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: isSelected ? CustomColor.colorWhite : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected ? CustomColor.colorWhite : Colors.black26,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected
                      ? CustomColor.primaryColor
                      : CustomColor.colorWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
