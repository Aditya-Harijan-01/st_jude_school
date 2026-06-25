import 'dart:convert';
import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/Students/student_profile.dart';
import 'widgets/profile_details.dart';
import 'widgets/quick_info_card.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentProfileResponse? student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final admission = student?.responseObject?.admissionDetails?.first;
    final academic = student?.responseObject?.academicDetails?.first;
    final parent = student?.responseObject?.parentDetails?.first;
    final reg = student?.responseObject?.registrationDetails?.first;
    final className = academic?.className ?? '';
    final section = academic?.section ?? '';
    final stream = academic?.stream ?? '';
    String cleanText = '';

    if (className.isNotEmpty) {
      cleanText = "Class $className";
    }

    if (section.isNotEmpty) {
      cleanText += " ($section)";
    }

    if (stream.isNotEmpty) {
      cleanText += " - $stream";
    }
    return Scaffold(
      backgroundColor: CustomColor.primaryOne,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/profile_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 50.h),

              // 🔹 Profile image
              Container(
                height: 140.h,
                width: 140.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 3.w, color: CustomColor.colorWhite),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildProfileImage(reg!.imgByte),
              ),

              SizedBox(height: 10.h),

              // 🔹 Student Name
              Text(
                reg.fname ?? "N/A",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: CustomColor.colorWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 10.h),


              // // 🔹 Class and Roll
              // Text(
              //   "Class ${academic?.className ?? '-'} (${academic?.section ?? '-'}) • Roll No. ${academic?.rollNo ?? '-'}",
              //   style: TextStyle(
              //     fontSize: 14.sp,
              //     color: CustomColor.colorWhite,
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.all(15.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: CustomColor.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: CustomColor.colorShadow,
                        spreadRadius: 2.r,
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuickInfoCard(
                        icon: Icons.school,
                        // title: "Grade",
                        value: cleanText,
                        customColor: const Color(0xFF77CAFF),
                      ),
                      // QuickInfoCard(
                      //   icon: "assets/icons/svg/calendar_check.svg",
                      //   title: "Attendance",
                      //   value: "${academic.rollNo ?? '-'}%",
                      //   customColor: const Color(0xFFCAFAD9),
                      // ),
                      QuickInfoCard(
                        icon: Icons.numbers_rounded,
                        // title: "Rank",
                        value: "Roll No. ${admission?.rollNo}",
                        customColor: const Color(0xFFD18CFF),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 Details Sections
              SizedBox(
                height: 0.55.sh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      DetailsSection(
                        title: "Student Details",
                        details: {
                          // Personal Information
                          "Full Name": reg.fname ?? "-",
                          "Registration No.": reg.regno ?? "-",
                          "Date of Birth": reg.dob ?? "-",
                          "Gender": reg.gender ?? "-",
                          "Blood Group": reg.bloodgroup ?? "-",
                          "Religion": reg.religion ?? "-",
                          "Tribe": reg.tribe ?? "-",
                          "Mother Tongue": reg.motherTongue ?? "-",
                          "Nationality": reg.nationality ?? "-",

                          // Contact Information
                          "Email Address": reg.email ?? "-",
                          "Phone": reg.phone ?? "-",
                          "Guard Phone": reg.guardPhone ?? "-",

                          // Address Information
                          "House Name": reg.housename ?? "-",
                          "Village": reg.prVill ?? "-",
                          "City": reg.prCity ?? "-",
                          "District": reg.prDistrict ?? "-",
                          "State": reg.prState ?? "-",
                          "PinCode": reg.prPin ?? "-",

                          // Other / Academic Information
                          "Date of Admission": reg.doa ?? "-",
                        }

                      ),
                      DetailsSection(
                        title: "Parent Details",
                        details: {
                          "Father's Name": parent?.fatherName ?? "-",
                          "Father's Address": parent?.fatherAddress ?? "-",
                          "Father's Education": parent?.fatherEducation ?? "-",
                          "Father's Occupation": parent?.fatherOccupation ?? "-",
                          "Father's Office": parent?.fatherOffice ?? "-",
                          "Mother's Name": parent?.motherName ?? "-",
                          "Mother's Address": parent?.motherAddress ?? "-",
                          "Mother's Education": parent?.motherEducation ?? "-",
                          "Mother's Occupation": parent?.motherOccupation ?? "-",
                          "Mother's Office": parent?.motherOffice ?? "-",
                          "Father Phone": parent?.fatherPhone ?? "-",
                          "Mother Phone": parent?.motherPhone ?? "-",
                        },
                      ),
                      DetailsSection(
                        title: "Academic Details",
                        details: {
                          "Class": ?(academic!.className == null || academic.className!.isEmpty)
                              ? "-"
                              : academic.className,
                          "Section": ?(academic.section == null || academic.section!.isEmpty)
                              ? "-"
                              : academic.section,
                          "Stream": ?(academic.stream == null || academic.stream!.isEmpty)
                              ? "-"
                              : academic.stream,
                          "Roll No.": ?(academic.rollNo == null || academic.rollNo!.isEmpty)
                              ? "-"
                              : academic.rollNo,
                          "Session": "${academic.toYear} - ${academic.fromYear}",
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper for Base64 image
  Widget _buildProfileImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return Image.asset(
        "assets/images/default_user.png",
        fit: BoxFit.cover,
      );
    }

    try {
      final bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      return Image.asset(
        "assets/images/default_user.png",
        fit: BoxFit.cover,
      );
    }
  }
}
