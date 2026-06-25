import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/colors.dart';
import '../../../../models/Students/assignment_details.dart';
import '../../../../widgets/parser_formator.dart';

class AcademicDetailScreen extends StatefulWidget {
  final StudentAssignment assignment;
  const AcademicDetailScreen({super.key, required this.assignment});

  @override
  State<AcademicDetailScreen> createState() => _AcademicDetailScreenState();
}

class _AcademicDetailScreenState extends State<AcademicDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;

    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: AppBar(
         title: const Text('Assignment Details'),
         backgroundColor: CustomColor.primaryColor,
         foregroundColor: CustomColor.colorWhite,
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () => Navigator.pop(context),
         ),
       ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- Header Card ----------
              Container(
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
                    /// Subject & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignment.subjectName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: (assignment.displayStatus.toLowerCase() ==
                                "active")
                                ? CustomColor.colorRedAccentLight
                                : CustomColor.primaryLight,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            assignment.displayStatus,
                            style: TextStyle(
                              color: (assignment.displayStatus.toLowerCase() ==
                                  "active")
                                  ? CustomColor.colorRedAccent
                                  : CustomColor.primaryColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    Text(
                      assignment.chapterName,
                      style: TextStyle(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                        color:  Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Divider(color: Colors.white,),

                    /// Teacher & Page Info
                    Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(assignment.teacherImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          assignment.teacherName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color:  Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color:  Colors.white,
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            size: 15.sp,
                            color: CustomColor.primaryColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Page ${assignment.pageFrom}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color:  Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// ---------- Dates ----------
              Row(
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
                              fontSize: 12.sp, color: CustomColor.primaryColor)),
                          SizedBox(height: 2.h),
                          Text(
                            formatDate(assignment.assignmentDate),
                            style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold,color: CustomColor.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
                              fontSize: 12.sp, color: CustomColor.colorRedAccent)),
                          SizedBox(height: 2.h),
                          Text(
                            formatDate(assignment.assignmentSubmissionDate),
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
              ),

              SizedBox(height: 8.h),

              /// ---------- Attachments ----------
              if (assignment.docList.isNotEmpty)
                Column(
                  children: assignment.docList.map<Widget>((file) {
                    return GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(file.docPath);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          // optional: handle if the link can't be opened
                          debugPrint('Could not launch ${file.docPath}');
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
                                  file.docPath.split('/').last,
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
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

              SizedBox(height: 8.h),
              Padding(
                padding:  EdgeInsets.all(6.r),
                child: Text('Assignment:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),),
              ),

              /// ---------- Description / Questions ----------
              assignment.assignmentDetails != ''
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
                    data: assignment.assignmentDetails,
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
            ],
          ),
        ),
      ),
    );
  }
}
