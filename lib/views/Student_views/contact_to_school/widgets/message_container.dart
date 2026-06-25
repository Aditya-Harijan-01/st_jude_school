import 'package:st_jude_school/models/Students/concern_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/student/get_student_profile.dart';
import '../../../../widgets/base64_image.dart';
import '../../../../widgets/date_format.dart';

class MessageContainer extends StatelessWidget {
  final bool receiver;
  final ConcernMessage message;
  final ConcernHistoryResponse? concern;
  final img;
  final String type;
  const MessageContainer({
    super.key,
    required this.receiver,
    required this.message,
    required this.concern,
    required this.img,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool alendata = message.contentDirection == 'SND' ? false : true;
    final provider = Provider.of<StudentProfileProvider>(context);
    final regData = type == "STD" ? img : provider.registrationDetails!.first;
    // final msg = message
    return Container(
      margin: alendata
          ? EdgeInsets.only(right: 20.w, bottom: 20.h)
          : EdgeInsets.only(left: 20.w, bottom: 20.h),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: alendata
            ? BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorGrey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: CustomColor.colorBlack,
                fontSize: 14.sp,
                height: 1.5.h,
              ),
              children: [
                TextSpan(
                  text: "${concern!.data.first.contentCategoryName}:- ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: CustomColor.colorBlack.withOpacity(0.8),
                  ),
                ),
                TextSpan(
                  text: message.contentDescription,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: CustomColor.colorBlack.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          if (message.attachment.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                children: message.attachment.map((attachment) {
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(attachment.filePath);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open attachment'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.all(5.w),
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
                              "Attachment", // You might want to extract filename from path if possible, or use 'Attachment'
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: CustomColor.colorBlack,
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
            ),
          SizedBox(height: 16.h),
          Row(
            children: [
              type == "STD"
                  ? CircleAvatar(
                      radius: 18.r,
                      backgroundColor: Colors.teal,
                      backgroundImage: !alendata
                          ? buildProfileImage(regData)
                          : message.profileUrl != 'No_Image'
                          ? NetworkImage(message.profileUrl)
                          : null,
                      child: message.profileUrl == ''
                          ? Text(
                              'S',
                              style: TextStyle(
                                color: CustomColor.colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    )
                  : CircleAvatar(
                      radius: 18.r,
                      backgroundColor: Colors.teal,
                      backgroundImage: !alendata
                          ? buildProfileImage(regData.imgByte)
                          : message.profileUrl != 'No_Image'
                          ? NetworkImage(message.profileUrl)
                          : null,
                      child: message.profileUrl == ''
                          ? Text(
                              'S',
                              style: TextStyle(
                                color: CustomColor.colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concern!.data.first.complaintRegNo,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: CustomColor.colorBlack.withOpacity(0.75),
                    ),
                  ),
                  Text(
                    message.postedBy,
                    style: TextStyle(
                      color: CustomColor.colorBlack.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatDate(message.postedOn),
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Text(
                  //   concern!.data.first.className,
                  //   style: TextStyle(
                  //     color: CustomColor.colorGrey,
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
