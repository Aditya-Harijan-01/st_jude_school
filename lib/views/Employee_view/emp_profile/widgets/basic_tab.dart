import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildBasicsTab(List<EmployeeBasic> basicInfo) {
  final emp = basicInfo.first;

  final Map<String, String> details = {
    "Employee Name": emp.employeeName,
    "Gender": emp.gender,
    "Date of Birth": emp.dob,
    "Birthplace": emp.birthplace,
    "Father's Name": emp.fatherName,
    "Mother's Name": emp.motherName,
    "Father Occupation": emp.fatherOccupation,
    "Nationality": emp.nationality,
    "Marital Status": emp.maritalStatus,
    "Wedding Date": emp.weddingDate,
    "Mother Tongue": emp.motherTongue,
    "Blood Group": emp.bloodGroup,
    "Aadhar No": emp.aadharNo,
    "Religion": emp.religion,
    "Caste": emp.castName,
    "Phone No": emp.phoneNo,
    "Emergency No": emp.emergencyNo,
  };

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
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