import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/common/common_Session.dart';
import '../../../providers/student/get_session.dart';

class CommonBottomSheetEmp extends StatelessWidget {
  final Widget content;
  final Future<void> Function(String from, String to)? onSessionChange;

  const CommonBottomSheetEmp({
    super.key,
    required this.content,
    this.onSessionChange,
  });

  @override
  Widget build(BuildContext context) {
    final sess = Provider.of<SessionProvider>(context);

    // final selectedSession = sess.selectedSession ??
    //     (sess.sessionData?.isNotEmpty == true ? sess.sessionData!.first : null);

    final name = sess.studentInfo?.name;
    final designation = sess.studentInfo?.designation;

    return Container(
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border(
          top: BorderSide(color: CustomColor.secondaryColor, width: 3.h),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? '',
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      designation ?? '',
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SessionDropdown(
                    onSessionChanged: (from, to) async {
                      sess.updateSelectedSession(from, to);
                      if (onSessionChange != null) {
                        await onSessionChange!(from, to);
                      }
                    },
                    disable: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(child: content),
            ),
          ],
        ),
      ),
    );
  }
}
