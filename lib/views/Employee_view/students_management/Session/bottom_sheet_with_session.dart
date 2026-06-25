import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/student/get_session.dart';
import 'sess_dropdown.dart';

class BottomSheet2 extends StatelessWidget {
  final Widget content;
  final String name;
  final String fYear;
  final String tYear;
  final String? emp;
  final Future<void> Function(String from, String to)? onSessionChange;

  const BottomSheet2({
    super.key,
    required this.content,
    this.onSessionChange,
    required this.name,
    required this.fYear,
    required this.tYear,
    this.emp,
  });

  @override
  Widget build(BuildContext context) {
    final sess = Provider.of<SessionProvider>(context);

    final selectedSession = sess.selectedSession2 ??
        (sess.sessionData2?.isNotEmpty == true ? 
        sess.sessionData2!.firstWhere(
            (element) => element.fromYear == fYear,
            orElse: () => sess.sessionData2!.first)
        : null);

    final className = selectedSession?.className ?? '';
    final section = selectedSession?.section ?? '';
    final designation = sess.studentInfo2?.designation;

    return Container(
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border(
          top: BorderSide(
            color: CustomColor.secondaryColor,
            width: 3.h,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header Row — Class Info & Session Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(emp == 'emp')...[
                      Text(
                        designation!,
                        style: TextStyle(
                          color: CustomColor.colorWhite,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                    else...[
                      Text(
                        section == '' ?
                        "Class $className"
                            : "Class $className ($section)",
                        style: TextStyle(
                          color: CustomColor.colorWhite,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SessionDropdown(
                    onSessionChanged: (from, to) async {
                      sess.updateSelectedSessionSecondary(from, to);
                      if (onSessionChange != null) {
                        await onSessionChange!(from, to);
                      }
                    },
                    fYear: fYear,
                    tYear: tYear,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
