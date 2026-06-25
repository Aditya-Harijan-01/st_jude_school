// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/leave_model.dart';

class LeaveCardWidget extends StatelessWidget {
  final LeaveSummary leave;

  const LeaveCardWidget({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 8.h),
      width: 0.42.sw, // ScreenUtil width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(color: CustomColor.primaryColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGreen.withOpacity(0.2),
            spreadRadius: 1.r,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)
              ),
              color: CustomColor.primaryColor.withOpacity(0.1)
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Center(
                child: Text(
                  leave.leaveName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColor.colorBlack,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
      
          Padding(
            padding: EdgeInsets.only(top: 4.w,left: 8.w, right: 8.w, bottom: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Eligible',
                      style: TextStyle(fontSize: 12.sp, color: CustomColor.primaryColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      leave.assignLeave.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Used',
                      style: TextStyle(fontSize: 12.sp, color: CustomColor.primaryColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      leave.used,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Bal',
                      style: TextStyle(fontSize: 12.sp, color: CustomColor.primaryColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      leave.balanceLeave.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      
          // SizedBox(height: 5.h),
      
          Padding(
            padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 4.w, bottom: 8.w),
            child: SizedBox(
              height: 6.h,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double totalWidth = constraints.maxWidth;
                  double eligible = leave.assignLeave;
                  double used = double.parse(leave.used);
                  double bal = leave.balanceLeave;
                  
                  double usedWidth = 0;
                  double balWidth = 0;
                  double unusedWidth = 0;
                  
                  if (eligible > 0) {
                    usedWidth = (used / eligible).clamp(0.0, 1.0) * totalWidth;
                    balWidth = (bal / eligible).clamp(0.0, 1.0) * totalWidth;
                    unusedWidth = totalWidth - usedWidth - balWidth;
                    if (unusedWidth < 0) unusedWidth = 0;
                  } else {
                    unusedWidth = totalWidth;
                  }
                  
                  return Row(
                    children: [
                      Container(
                        width: usedWidth,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 215, 14, 14),
                              Color.fromARGB(255, 255, 255, 255)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      Container(
                        width: balWidth,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                      Container(
                        width: unusedWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
