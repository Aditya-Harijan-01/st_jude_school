import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildQualificationTab(List<EmployeeQualification> qualifications) {
  return qualifications.isNotEmpty ?
  Padding(
    padding: EdgeInsets.all(15.w),
    child: ListView.builder(
      itemCount: qualifications.length,
      itemBuilder: (context, index) {
        final q = qualifications[index];

        final Map<String, String> details = {
          "Exam Name": q.examName,
          "Pass Year": q.passYear,
          "Institute": q.institute,
          "Subject": q.subject,
          "Percentage": q.percentage,
        };

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side label
                    SizedBox(
                      width: 110.w,
                      child: Text(
                        entry.key,
                        style:  TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value != "" ? entry.value : "N/A",
                        style:  TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    ),
  )
  :
  Center(
    child: Text(
      "No qualification data available",
      style: TextStyle(color: Colors.black54, fontSize: 16.sp),
    ),
  );
}
