
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildBankDetails(List<EmployeeBank> bank) {
  final q = bank.first;

  final Map<String, String> details = {
    "Present Address": q.nameOfAccount,
    "Present City": q.bankName,
    "Present State": q.branchName,
    "Present Country": q.ifscCode,
    "Present ZIP": q.bankAcNo,
    "Parmanent Address": q.atmFacility,
  };

  return Padding(
    padding: EdgeInsets.all(15.w),
    child: ListView(
      children: details.entries.map((entry) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
              Text(
                entry.value != "" ? entry.value : "N/A",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}