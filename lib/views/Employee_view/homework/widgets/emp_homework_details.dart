// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';
import '../../../../models/employee/assignment.dart';
import '../../../../providers/employee/emp_assignment.dart';
import '../../../../providers/employee/emp_assignment_from.dart';
import '../../../../widgets/date_format.dart';

class EmpAssignmentDetailsScreen extends StatelessWidget {
  late AssignmentListProvider listProvider;
  late AssignmentFormProvider formProvider;
  final AssignmentData data;

  EmpAssignmentDetailsScreen({
    super.key,
    required this.listProvider,
    required this.formProvider,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text("HomeWork Details",
          style: TextStyle(
            color: CustomColor.colorWhite, 
            fontSize: 20.sp
            )
          ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite
          ),
        ),
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _teacherCard(),
            SizedBox(height: 20.h),
            _dateCard(),
            SizedBox(height: 20.h),
            if (data.assignmentAttachments.isNotEmpty)
              Column(
                children: data.assignmentAttachments.map<Widget>((file) {
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(file.filePath);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        // optional: handle if the link can't be opened
                        debugPrint('Could not launch ${file.filePath}');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            width: 1.w,
                            color: CustomColor.colorGrey
                          )
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color.fromARGB(255, 255, 219, 225),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.insert_drive_file,
                                  color: CustomColor.colorRedAccent,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                file.filePath.split('/').last,
                                style: TextStyle(
                                  fontSize: 12.sp, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Icon(
                              Icons.download,
                              size: 16.sp
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
              else
                SizedBox.shrink(),

            SizedBox(height: 20.h),
            Padding(
                padding:  EdgeInsets.all(6.r),
                child: Text('Assignment:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.colorBlack
                ),),
              ),

              /// ---------- Description / Questions ----------
              data.assignmentDetails != ''
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: CustomColor.colorWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      width: 0.5,
                      color: CustomColor.primaryColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: CustomColor.colorBlack.withOpacity(0.05),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Html(
                    data: data.assignmentDetails,

                    style: {
                      "p": Style(
                        fontSize: FontSize(15.sp),
                        lineHeight: LineHeight(1.5),
                      ),
                      "li": Style(
                        fontSize: FontSize(12.sp),
                        lineHeight: LineHeight(1.5),
                      ),
                    },
                  ),
                )
              : const SizedBox.shrink(),
            // _detailsSection(),
          ],
        ),
      ),
    );
  }

  Row _dateCard() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: CustomColor.secondaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                width: 1,
                // ignore: deprecated_member_use
                color: CustomColor.secondaryColor.withOpacity(0.4)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assigned On",
                  style: TextStyle(
                    fontSize: 12.sp, 
                    color: CustomColor.primaryColor
                  )
                ),
                SizedBox(height: 2.h),
                Text(
                  formatDate(data.assignmentDate),
                  style: TextStyle(
                    fontSize: 16.sp, 
                    fontWeight: FontWeight.bold,
                    color: CustomColor.primaryColor
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w, 
              vertical: 10.h
            ),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: CustomColor.colorRedAccentLight.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                width: 1.w,
                // ignore: deprecated_member_use
                color: CustomColor.colorRedAccent.withOpacity(0.3)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Due Date",
                  style: TextStyle(
                    fontSize: 12.sp, 
                    color: CustomColor.colorRedAccent
                  )
                ),
                SizedBox(height: 2.h),
                Text(
                  formatDate(data.submissionDate),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.colorRedAccent
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _teacherCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          CustomColor.primaryColor,
          CustomColor.secondaryColor,
        ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorBlack.withOpacity(0.05),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.subjectName,
                style: TextStyle(
                  color: CustomColor.colorWhite,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Text(
            data.chapterName,
            style: TextStyle(
              fontSize: 21.sp,
              fontWeight: FontWeight.w600,
              color:  CustomColor.colorWhite,
            ),
          ),
          SizedBox(height: 4.h),
          Divider(color: CustomColor.colorWhite,),

          /// Teacher & Page Info
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(data.profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                data.teacherName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color:  CustomColor.colorWhite,
                ),
              ),
              const Spacer(),
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color:  CustomColor.colorWhite,
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: 15.sp,
                  color: CustomColor.primaryColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                data.chapterName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color:  CustomColor.colorWhite,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
