
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';

class EmpHomeworkCard extends StatelessWidget {
  final String? publishDate;
  final String? dueDate;
  final String subject;
  final String? chapter;
  final VoidCallback onView;
  final VoidCallback editAssignment;

  const EmpHomeworkCard({
    super.key,
    required this.publishDate,
    required this.dueDate,
    required this.subject,
    required this.chapter,
    required this.onView,
    required this.editAssignment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(width: 1.w, color: CustomColor.primaryColor),
          boxShadow: [
            BoxShadow(color: Colors.black54.withAlpha(20),
              blurRadius: 2.r,
              spreadRadius: 1.r,
              offset: Offset(0, 2)
            )
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Publish Date: $publishDate", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  Text("Submisssion Date: ${dueDate != "" ? dueDate : "N/A"}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10.h),
              Text(subject,
                  style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  )),
              Text("Chapter: $chapter", style: TextStyle(fontSize: 16.sp, color: CustomColor.colorBlack)),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: editAssignment,
                    child: Container(
                      height: 30.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        // border: Border.all(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          "Edit", 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp
                          )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onView,
                    child: Container(
                      height: 30.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: CustomColor.primaryColor),
                        borderRadius: BorderRadius.circular(12.r),
                        color: CustomColor.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "View", 
                          style: TextStyle(
                            color: CustomColor.colorWhite, 
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp
                          )
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}