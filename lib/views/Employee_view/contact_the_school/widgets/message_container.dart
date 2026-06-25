
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';
// import '../../../../providers/student/get_student_profile.dart';
import '../../../../models/Students/concern_history.dart';
import '../../../../providers/employee/employee_profile.dart';
import '../../../../widgets/base64_image.dart';
import '../../../../widgets/date_format.dart';

class MessageContainer extends StatelessWidget {
  final bool receiver;
  final ConcernMessage message;
  final ConcernHistoryResponse? concern;
  const MessageContainer({
    super.key, 
    required this.receiver, 
    required this.message, 
    required this.concern
  });

  @override
  Widget build(BuildContext context) {

    bool alendata = message.contentDirection == 'SND' ? false : true;
    final provider = Provider.of<EmployeeProfileProvider>(context);
    final regData = provider.employeeBasic!.first.profileImage;
    final designation = provider.employeeOffice!.first.designation;

    // final msg = message
    return Container(
      margin: alendata ? EdgeInsets.only(right: 20.w, bottom: 20.h) : EdgeInsets.only(left: 20.w, bottom: 20.h),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius:  alendata ? BorderRadius.only(topRight: Radius.circular(20.r), bottomRight: Radius.circular(20.r)) : BorderRadius.only(topLeft: Radius.circular(20.r), bottomLeft: Radius.circular(20.r)),
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
            text:  TextSpan(
              style: TextStyle(color: CustomColor.colorBlack, fontSize: 14.sp, height: 1.5.h),
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
                )
              ],
            ),
          ),

          if (message.attachment.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey[500]!,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200],
              ),
              child: Column(
                children: List.generate(
                  message.attachment.length,
                  (index) {
                    final attachment = message.attachment[index];
                    final attachmentUrl = attachment['file_path'] ?? '';
                    final attachmentName = attachmentUrl.split(RegExp(r'[\\/\\\\]')).last;
                    return ListTile(
                      leading: Icon(Icons.insert_drive_file, color: CustomColor.primaryColor),
                      title: Text(
                        attachmentName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download, color: Colors.green),
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse(attachmentUrl))) {
                            await launchUrl(Uri.parse(attachmentUrl),
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cannot open attachment')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.teal,
                backgroundImage: !alendata ?
                buildEmpProfileImage(regData)
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
                      color: CustomColor.colorBlack.withOpacity(0.75)
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
                  Text(
                    designation,
                    style: TextStyle(
                      color: CustomColor.colorBlack.withOpacity(0.75),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}




