import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildExperienceTab(List<EmployeeExperience> dataExperience) {
  return dataExperience.isNotEmpty ? Padding(
    padding: EdgeInsets.all(15.w),
    child: ListView.builder(
      itemCount: dataExperience.length,
      itemBuilder: (context, index) {
        final q = dataExperience[index];

        final Map<String, String> details = {
          "Organization": q.organization,
          "Started From": q.fromDate,
          "Ended To": q.toDate,
          "Designation": q.designation,
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
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side label
                    SizedBox(
                      width: 110.w, // Fixed label width for alignment
                      child: Text(
                        entry.key,
                        style:  TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    // SizedBox(width: 12.w),

                    // Value side (Flexible)
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
  ): Center(
    child: Text(
      "No Experience data available",
      style: TextStyle(color: Colors.black54, fontSize: 16.sp),
    ),
  );
}
