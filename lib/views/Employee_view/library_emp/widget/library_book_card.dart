import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

class LibraryBookCard extends StatelessWidget {
  final String title;
  final String author;
  final String date;
  final String image;
  final bool isIssued;

  const LibraryBookCard({
    super.key,
    required this.title,
    required this.author,
    required this.date,
    required this.image,
    required this.isIssued,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Container(
        height: 140.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Thumbnail
            Container(
              height: 140.h,
              width: 110.w,
              decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child:
                image == "" ? Icon(Icons.book, size: 80.sp, color: CustomColor.colorWhite,):
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Book Details
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          author,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CustomColor.colorGrey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 16.sp,
                          color: CustomColor.colorGrey,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "${isIssued ? 'Issued' : 'Returned'} Date: $date",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: CustomColor.colorGrey,
                          ),
                        ),
                      ],
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