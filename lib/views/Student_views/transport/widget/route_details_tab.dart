import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/student/transport_provider.dart';

class RouteDetailsTab extends StatelessWidget {
  const RouteDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportProvider>(context);
    final routeInfo = provider.routeInfo;

    // Guard against null or empty data
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (routeInfo == null || routeInfo.isEmpty) {
      return const Center(child: Text("No route details available"));
    }

    // Use the first route (if multiple exist)
    final stops = routeInfo.first.stopPoints;

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Route Details",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),

                //   Dynamic Stop List
                ...List.generate(stops.length, (index) {
                  final stop = stops[index];
                  final isLast = index == stops.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🕒 Distance instead of Time
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          "${stop.distanceFromSchool} km",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),

                      // 🟢 Timeline Circle + Line
                      Column(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: CustomColor.colorWhite,
                              border: Border.all(
                                width: 1.5,
                                color: CustomColor.primaryColor,
                              ),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 6.w,
                              height: 50.h,
                              color: CustomColor.primaryColor,
                            ),
                          if (isLast)
                            Container(
                              width: 6.w,
                              height: 20.h,
                              color: CustomColor.primaryColor,
                            ),
                        ],
                      ),

                      SizedBox(width: 10.w),

                      // 📍 Stop Point Name
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            stop.pointName,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
