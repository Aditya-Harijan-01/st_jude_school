import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class TopToggleBar extends StatelessWidget {
  final String selectedTab;
  final int issuedCount;
  final int returnedCount;
  final Function(String) onTabChange;
  final List<String> title;

  const TopToggleBar({
    super.key,
    required this.selectedTab,
    required this.issuedCount,
    required this.returnedCount,
    required this.onTabChange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildToggle({
      required String tabKey,
      required String title,
      required String count,
      required bool isActive,
    }) {
      return GestureDetector(
        onTap: () => onTabChange(tabKey),
        child: Container(
          height: 45.h,
          width: 190.w,
          decoration: BoxDecoration(
            color: isActive
                ? CustomColor.primaryColor
                : CustomColor.colorDemoGrey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isActive
                        ? CustomColor.colorWhite
                        : Colors.grey.shade600,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: isActive
                      ? CustomColor.secondaryColor
                      : Colors.grey.shade600,
                  radius: 14.r,
                  child: Text(
                    count,
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildToggle(
            tabKey: "1",
            title: title.first,
            count: issuedCount.toString(),
            isActive: selectedTab == "1",
          ),
          buildToggle(
            tabKey: "0",
            title: title.last,
            count: returnedCount.toString(),
            isActive: selectedTab == "0",
          ),
        ],
      ),
    );
  }
}
