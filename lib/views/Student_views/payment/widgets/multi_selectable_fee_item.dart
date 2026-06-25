import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

class MultiSelectableFeeItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool isChecked;
  final bool isEnabled;
  final ValueChanged<bool?> onChanged;

  const MultiSelectableFeeItem({
    super.key,
    required this.title,
    required this.amount,
    required this.isChecked,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? () => onChanged(!isChecked) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isChecked ? CustomColor.colorGreen : CustomColor.colorRed,
            width: 0.25,
          ),
          color: isChecked
              // ignore: deprecated_member_use
              ? Colors.green.withOpacity(0.08)
              // ignore: deprecated_member_use
              : Colors.red.withOpacity(0.08),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isChecked ? CustomColor.primaryColor : CustomColor.colorRed,
                      width: 2,
                    ),
                    color: isChecked
                        ? CustomColor.primaryColor
                        : Colors.transparent,
                  ),
                  child: isChecked
                      ? Icon(
                          Icons.check,
                          color: CustomColor.colorWhite,
                          size: 14.sp,
                        ) : !isEnabled ? Icon(Icons.lock,
                      color: CustomColor.colorRed,
                      size: 14.sp
                  )
                      : null,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: CustomColor.colorBlack,
                  ),
                ),
              ],
            ),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isChecked ? CustomColor.colorGreen : CustomColor.colorRed,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
