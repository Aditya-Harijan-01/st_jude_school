// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../notification_screen/widget/notification_attachment.dart';

class HomeworkCard extends StatelessWidget {
  final String subject;
  final String chapter;
  final String teacher;
  final String dueDate;
  final bool isCompleted;
  final String? imageUrl;
  final List<dynamic>? attachments;

  const HomeworkCard({
    super.key,
    required this.subject,
    required this.chapter,
    required this.teacher,
    required this.dueDate,
    required this.isCompleted,
    this.imageUrl,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.primaryColor,
                ),
              ),
              if (attachments != null && attachments!.isNotEmpty) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40.w,
                                height: 4.h,
                                margin: EdgeInsets.only(bottom: 20.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ),
                            Text(
                              "Attachments",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomColor.primaryColor,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            AttachmentNotification(attachments: attachments!),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Transform.rotate(
                        angle: 0.785, // 45 degrees in radians
                        child: Icon(Icons.attach_file,
                            color: CustomColor.primaryColor, size: 22.sp),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.w,
                            minHeight: 16.w,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            attachments!.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Chapter: $chapter",
            style: TextStyle(
              fontSize: 13.sp,
              color: CustomColor.colorBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT SIDE → Image + Teacher Name
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    if (imageUrl != null && imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          imageUrl!,
                          height: 20.h,
                          width: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Text(
                        "By $teacher",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 15.w),

              /// RIGHT SIDE → Icon + Due Date
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: isCompleted
                            ? CustomColor.colorGreen.withAlpha(50)
                            : Colors.red.shade100,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.date_range,
                          color: isCompleted
                              ? CustomColor.colorGreen
                              :  Colors.red.shade500,
                          size: 15.sp,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Text(
                        "Due: $dueDate",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? CustomColor.colorGreen
                              : Colors.red.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}