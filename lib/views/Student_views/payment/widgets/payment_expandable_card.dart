import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

class PaymentExpandableCard extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Color? iconColor;
  final Widget? child;

  const PaymentExpandableCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.iconColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 2, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
            onTap: onToggle,
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconColor != null)
                  Icon(Icons.error, color: iconColor, size: 18.sp),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
          if (isExpanded && child != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: child,
            ),
        ],
      ),
    );
  }
}