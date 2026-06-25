import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 760.h,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
          ],
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    CustomColor.primaryColor,
                  ],
                  stops: const [0.0, 0.9],
                ),
              ),
            ),
            // Content at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style:  TextStyle(
                              color: CustomColor.colorWhite,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           SizedBox(height: 8.h),
                          Row(
                            children: [
                               Icon(
                                Icons.calendar_today,
                                color: CustomColor.colorWhite,
                                size: 16.h,
                              ),
                               SizedBox(width: 8.h),
                              Text(
                                date,
                                style:  TextStyle(
                                  color: CustomColor.colorWhite,
                                  fontSize: 14.h,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: CustomColor.colorWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8.sp),
                      child:  Icon(
                        Icons.arrow_forward_ios,
                        color: CustomColor.colorWhite,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
