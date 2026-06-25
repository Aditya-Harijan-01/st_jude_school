import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/colors.dart';

class AttachmentNotification extends StatelessWidget {
  const AttachmentNotification({
    super.key,
    required this.attachments,
  });

  final List<dynamic> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: attachments.map((attachment) {
          final String docPath = attachment.docPath ?? '';
          if (docPath.isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () async {
              final uri = Uri.parse(docPath);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $uri';
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: const Color.fromARGB(255, 246, 209, 207),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.edit_document,
                        size: 20.sp,
                        color: const Color.fromARGB(255, 211, 30, 17),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      docPath.split('/').last,
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                    Icon(
                      Icons.open_in_new,
                      size: 18.sp,
                      color: CustomColor.colorBlack,
                    ),


                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class EmpAttachmentNotification extends StatelessWidget {
  const EmpAttachmentNotification({
    super.key,
    required this.attachments,
  });

  final List<dynamic> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: attachments.map((attachment) {
          final String docPath = attachment.attachmentUrl ?? '';
          if (docPath.isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () async {
              final uri = Uri.parse(docPath);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $uri';
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: const Color.fromARGB(255, 246, 209, 207),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.edit_document,
                        size: 20.sp,
                        color: const Color.fromARGB(255, 211, 30, 17),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      docPath.split('/').last,
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                    Icon(
                      Icons.open_in_new,
                      size: 18.sp,
                      color: CustomColor.colorBlack,
                    ),


                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}