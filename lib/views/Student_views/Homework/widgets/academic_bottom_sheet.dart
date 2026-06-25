import 'package:st_jude_school/widgets/common_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/student/get_assignment.dart';

class AcademicBottomSheet extends StatelessWidget {
  final String? total;
  final String? title;
  const AcademicBottomSheet({
    super.key,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      onSessionChange: (from, to) async {
        final auth = context.read<AuthProvider>();
        final academic = context.read<StudentAssignmentProvider>();
        await academic.getAssignment(auth.loginData!.regno, from, to);
      },
      content: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.w),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: CircleAvatar(
                    backgroundColor: CustomColor.colorRed,
                    child: Icon(
                      Icons.assignment,
                      color: CustomColor.colorWhite,
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title ?? "Total Assignment",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  total ?? "0",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.colorRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
