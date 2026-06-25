// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/student/get_session.dart';
import '../../../widgets/base64_image.dart';
import '../leave/widgets/emp_emp_leave.dart';
import 'common_card_session.dart';
import 'info_row.dart';

/// ---------------- TOP CARD ----------------

  Widget buildTopCard(
      Future<void> Function(String from, String to) reload,
      SessionProvider session, 
      EmployeeProfileProvider emp,
      String empId,
      String type,
      String? image,
      bool disable,
  ) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Container(
        // height: 190.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomColor.primaryColor.withOpacity(0.95),
              CustomColor.primaryColor.withOpacity(0.65),
              CustomColor.primaryColor.withOpacity(0.35),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r)],
        ),
        child: Column(
          children: [
            type =="EMP"
            ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow("Name", session.studentInfo2?.name ?? "-"),
                      SizedBox(height: 6.h),
                      infoRow("Designation",
                          session.studentInfo2?.designation ?? "-"),
                      SizedBox(height: 6.h),
                      infoRow("Employee Code", "EMP-$empId"),
                    ],
                  ),
                ),
                buildDupProfileImage(image),
              ],
            ) :
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow("Name", session.studentInfo?.name ?? "-"),
                      SizedBox(height: 6.h),
                      infoRow("Designation",
                          session.studentInfo?.designation ?? "-"),
                      SizedBox(height: 6.h),
                      infoRow("Employee Code", "EMP-$empId"),
                    ],
                  ),
                ),
                buildProfileImage(emp),
              ],
            ),
            SizedBox(height: 14.h),
            type == "EMP"
            ?
            buildDuplicateSessionDropdown(
              (from, to) async => await reload(from,to),
              disable
            ) :
            buildSessionDropdown(
              (from, to) async => await reload(from,to),
              disable
            ),

          ],
        ),
      ),
    );
  }

  Widget buildProfileImage(EmployeeProfileProvider emp) {
    return Container(
      height: 95.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: CustomColor.colorWhite,
        image: DecorationImage(
          image: buildEmpProfileImage(
            emp.employeeBasic?.first.profileImage ?? "",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildDupProfileImage(emp) {
    return Container(
      height: 95.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: CustomColor.colorWhite,
        image: DecorationImage(
          image: buildEmpProfileImage(
            emp,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }