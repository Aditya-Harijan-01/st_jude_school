// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

import '../../../../constants/constant.dart';
import '../../../../models/employee/student_management/student_list.dart';
import '../../../../providers/common/common_post_method.dart';
import '../../../Student_views/contact_to_school/contact_to_school.dart';
import '../attendance/attendance_record_screen.dart';
import '../payment/payment_from_emp.dart';
import '../profile.dart';
import '../report_card/assessment_screen_from_emp.dart';

class StudentMenuModal extends StatefulWidget {
  final Student student;
  final String fromYear;
  final String toYear;

  const StudentMenuModal({
    super.key,
    required this.student, required this.fromYear, required this.toYear,
  });

  @override
  State<StudentMenuModal> createState() => _StudentMenuModalState();
}

class _StudentMenuModalState extends State<StudentMenuModal> {
  String? profileImageBase64;
  bool isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final response = await postRequest(ApiEndpoints.getStudentProfileImage, {
        "sid": widget.student.sid
      });

      if (response != null && response['statusCode'] == 'Success') {
        final resultString = response["resultString"];
        final List<dynamic> resultList = jsonDecode(resultString);
        if (resultList.isNotEmpty && mounted) {
          setState(() {
            profileImageBase64 = resultList.first["profile_image"];
            isLoadingImage = false;
          });
        } else if (mounted) {
          setState(() {
            isLoadingImage = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadingImage = false;
          });
        }
      }
    } catch (e) {
      log('Error loading profile image: $e');
      if (mounted) {
        setState(() {
          isLoadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                _buildProfileImage(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student.studentName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: CustomColor.colorBlack,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: CustomColor.primaryLight,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'RegNo: ${widget.student.regno}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),
          Divider(height: 1, color: Colors.grey[200]),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuOption(
                    context,
                    icon: Icons.person,
                    title: 'Personal Information',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> Profile(fromYear: widget.fromYear, regNo: widget.student.regno)));
                    },
                  ),
                  _buildMenuOption(
                    context,
                    icon: Icons.qr_code_rounded,
                    title: 'Attendance',
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AttendanceRecordScreenFromEmp(regNo: widget.student.regno, fromYear: widget.fromYear, toYear: widget.toYear, name: widget.student.studentName,))
                      );
                    },
                  ),
                  _buildMenuOption(
                    context,
                    icon: Icons.credit_card_rounded,
                    title: 'Payment',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreenFromEmp(regNo: widget.student.regno, tYear: widget.toYear, fYear: widget.fromYear, name: widget.student.studentName,)));
                    },
                  ),
                  _buildMenuOption(
                    context,
                    icon: Icons.analytics_outlined,
                    title: 'Report Card',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> AssessmentScreenFromEmp(regNo: widget.student.regno, tYear: widget.toYear, fYear: widget.fromYear, name: widget.student.studentName,)));
                    },
                  ),
                  _buildMenuOption(
                    context,
                    icon: Icons.contact_support_outlined,
                    title: 'Contact School',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ContactToSchoolScreen(regNo: widget.student.regno, tYear: widget.toYear, fYear: widget.fromYear, type: "STD", img: profileImageBase64)));
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColor.primaryLight,
        border: Border.all(
          color: CustomColor.primaryColor.withAlpha(200),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColor.primaryColor.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: isLoadingImage
            ? Center(
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: CustomColor.primaryColor,
                  ),
                ),
              )
            : profileImageBase64 != null
                ? Image.memory(
                    base64Decode(profileImageBase64!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderAvatar(),
                  )
                : _buildPlaceholderAvatar(),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: CustomColor.primaryLight,
      child: Icon(
        Icons.person,
        color: CustomColor.primaryColor,
        size: 35.sp,
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: CustomColor.primaryLight.withAlpha(180),
        highlightColor: CustomColor.primaryLight.withAlpha(150),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: CustomColor.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: CustomColor.primaryColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.colorBlack.withOpacity(0.8),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
