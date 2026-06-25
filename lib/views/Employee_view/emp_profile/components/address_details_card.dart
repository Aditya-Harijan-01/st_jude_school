
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/employee/employee_profile.dart';

Widget buildAddressDetails(List<EmployeeAddress> address) {

  final q = address.first;

  final Map<String, String> details = {
    "Present Address": q.presentAddress,
    "Present City": q.presentCity,
    "Present State": q.presentState,
    "Present Country": q.presentCountry,
    "Present ZIP": q.presentZip,
    "Parmanent Address": q.parmAddress,
    "Parmanent City": q.parmCity,
    "Parmanent Country": q.parmCountry,
    "Parmanent State": q.parmState,
    "Parmanent ZIP": q.parmZip
  };
  // return Padding(
  //   padding: EdgeInsets.all(15.w),
  //   child: ListView.builder(
  //     itemCount: address.length,
  //     itemBuilder: (context, index) {
  //       final q = address[index];

  //       final Map<String, String> details = {
  //         "Present Address": q.presentAddress,
  //         "Present City": q.presentCity,
  //         "Present State": q.presentState,
  //         "Present Country": q.presentCountry,
  //         "Present ZIP": q.presentZip,
  //         "Parmanent Address": q.parmAddress,
  //         "Parmanent City": q.parmCity,
  //         "Parmanent Country": q.parmCountry,
  //         "Parmanent State": q.parmState,
  //         "Parmanent ZIP": q.parmZip
  //       };

  //       return Container(
  //         margin: EdgeInsets.symmetric(vertical: 8.h),
  //         padding: EdgeInsets.all(15.w),
  //         decoration: BoxDecoration(
  //           color: Colors.grey.shade100,
  //           borderRadius: BorderRadius.circular(12.r),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: details.entries.map((entry) {
  //             return Padding(
  //               padding: EdgeInsets.symmetric(vertical: 4.h),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     entry.key,
  //                     style: const TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.black54,
  //                     ),
  //                   ),
  //                   Text(
  //                     entry.value,
  //                     style: const TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   ),
  // );

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