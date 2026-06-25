
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildOfficialDetails(List<EmployeeOffice> official) {

  final q = official.first;
  final Map<String, String> details = {
    // "Biometric": q.biometricCode,
    "Pass Year": q.category,
    "Designation": q.designation,
    "Email ID": q.emailId,
    "Join Date": q.joinDate,
    "Nature of Appointment": q.noa,
    "Position": q.position,
    "Resignation Date": q.resignationDate
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// KEY
              SizedBox(
                width: 150.w, // fixed width for key
                child: Text(
                  entry.key,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
              ),

              SizedBox(width: 12.w), // <<---- space between key and value

              /// VALUE
              Expanded(
                child: Text(
                  entry.value != "" ? entry.value : "N/A",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              )
            ],
          ),
        );
      }).toList(),
    ),
  );
}