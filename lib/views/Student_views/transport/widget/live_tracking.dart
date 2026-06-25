import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveTrackingTab extends StatelessWidget {
  const LiveTrackingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Text("Live Tracking feature is not available!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryColor,
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Text("Live Tracking", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(10.r),
          //         child: Image.asset(
          //           "assets/images/Group 373.png", 
          //           fit: BoxFit.cover, 
          //           height: 500.h,
          //           width: double.infinity
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(12.w),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text("Next Station",
          //             style: TextStyle(
          //               color: Colors.grey.shade700, 
          //               fontSize: 12.sp
          //             )
          //           ),
          //           Text(
          //             "B2 - Zoo point, Guwahati - 781024",
          //             style: TextStyle(
          //               fontWeight: FontWeight.w600, 
          //               fontSize: 14.sp
          //             ),
          //           ),
          //           SizedBox(
          //             height: 8.h
          //           ),
          //           Text(
          //             "Estimated arrival in 4 min",
          //             style: TextStyle(
          //               color: Colors.green.shade700, 
          //               fontSize: 13.sp
          //             )
          //           ),
          //           SizedBox(
          //             height: 10.h
          //           ),
          //           Row(
          //             children: [
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     "Driver Name", 
          //                     style: TextStyle(
          //                       fontSize: 13.sp,
          //                       color: CustomColor.colorGrey
          //                     )
          //                   ),
          //                   Text(
          //                     "Aditya Kumar Harijan", 
          //                     style: TextStyle(
          //                       fontSize: 14.sp,
          //                     )
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(
          //                 width: 20.h,
          //               ),
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     "Contact", 
          //                     style: TextStyle(
          //                       fontSize: 13.sp,
          //                       color: CustomColor.colorGrey
          //                     )
          //                   ),
          //                   Text(
          //                     "91202 31318", 
          //                     style: TextStyle(
          //                       fontSize: 14.sp
          //                     )
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ],
    );
  }
}
