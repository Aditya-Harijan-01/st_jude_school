// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/student/get_student_profile.dart';
import '../../../models/Students/student_profile.dart';
import 'widgets/profile_shimmer.dart';

class Profile extends StatefulWidget {
  final String regNo;
  final String fromYear;
  const Profile({super.key, required this.fromYear, required this.regNo});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StudentProfileProvider _studentProfileProvider;

  @override
  void initState() {
    super.initState();
    _studentProfileProvider = StudentProfileProvider();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _studentProfileProvider.getStudentProfile("", widget.regNo, widget.fromYear, "");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _studentProfileProvider,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CustomColor.colorWhite,
              size: 20.sp,
            ),
          ),
          title: Text(
            "Student Profile",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomColor.colorWhite,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: CustomColor.primaryColor,
          elevation: 0,
        ),
        body: Consumer<StudentProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const ProfileShimmer();
            }

            if (provider.profileOne == null) {
              return Center(
                child: Text(
                  "No profile data found",
                  style: TextStyle(fontSize: 16.sp, color: CustomColor.colorGrey),
                ),
              );
            }

            final registration = provider.registrationDetails?.firstOrNull;
            if (registration == null) {
              return const Center(child: Text("No registration details available"));
            }

            return Column(
              children: [
                _buildHeader(registration),
                Container(
                  color: CustomColor.colorWhite,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: CustomColor.primaryColor,
                    unselectedLabelColor: CustomColor.colorGrey,
                    indicatorColor: CustomColor.primaryColor,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: "Personal"),
                      Tab(text: "Academic"),
                      Tab(text: "Parents"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPersonalTab(registration),
                      _buildAcademicTab(provider.academicDetails?.firstOrNull),
                      _buildParentsTab(provider.parentDetails?.firstOrNull),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(RegistrationDetails registration) {
    Uint8List? imageBytes;
    try {
      if (registration.imgByte != null && registration.imgByte!.isNotEmpty) {
        imageBytes = base64Decode(registration.imgByte!);
      }
    } catch (e) {
      imageBytes = null;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColor.primaryColor,
            CustomColor.primaryOne,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CustomColor.primaryLight, width: 2),
              boxShadow: [
                BoxShadow(color: CustomColor.primaryLight.withAlpha(100),blurRadius: 9.r,spreadRadius: 5, offset: Offset(0,2)),
              ],
            ),
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 40.sp,
                        color: CustomColor.colorGrey,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 40.sp,
                      color: CustomColor.colorGrey,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registration.fname ?? "N/A",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.colorWhite,
                  ),
                ),
                Text(
                  "Reg No: ${registration.regno ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.colorWhite.withOpacity(0.9),
                  ),
                ),
                Text(
                  "DOB: ${registration.dob ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.colorWhite.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(RegistrationDetails? details) {
    if (details == null) return const Center(child: Text("No data"));
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildInfoCard("Basic Information", [
            _buildInfoRow("Gender", details.gender),
            _buildInfoRow("Blood Group", details.bloodgroup),
            _buildInfoRow("Religion", details.religion),
            _buildInfoRow("Mother Tongue", details.motherTongue),
            _buildInfoRow("Nationality", details.nationality),
            _buildInfoRow("Tribe", details.tribe),
          ]),
          SizedBox(height: 16.h),
          _buildInfoCard("Contact Information", [
            _buildInfoRow("Email", details.email),
            _buildInfoRow("Phone", details.phone),
            _buildInfoRow("Guardian Phone", details.guardPhone),
          ]),
          SizedBox(height: 16.h),
          _buildInfoCard("Address", [
            _buildInfoRow("House Name", details.housename),
            _buildInfoRow("Village", details.prVill),
            _buildInfoRow("City", details.prCity),
            _buildInfoRow("District", details.prDistrict),
            _buildInfoRow("State", details.prState),
            _buildInfoRow("PIN", details.prPin),
          ]),
        ],
      ),
    );
  }

  Widget _buildAcademicTab(AcademicDetails? details) {
    if (details == null) return const Center(child: Text("No data"));
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: _buildInfoCard("Academic Details", [
        _buildInfoRow("Class", details.className),
        _buildInfoRow("Section", details.section),
        _buildInfoRow("Roll No", details.rollNo),
        if (details.stream != "")
        _buildInfoRow("Stream", details.stream),
        _buildInfoRow("Session", "${details.fromYear} - ${details.toYear}"),
      ]),
    );
  }

  Widget _buildParentsTab(ParentDetails? details) {
    if (details == null) return const Center(child: Text("No data"));
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildInfoCard("Father's Details", [
            _buildInfoRow("Name", details.fatherName),
            _buildInfoRow("Phone", details.fatherPhone),
            _buildInfoRow("Occupation", details.fatherOccupation),
            _buildInfoRow("Education", details.fatherEducation),
            _buildInfoRow("Income", details.fatherIncome),
            _buildInfoRow("Office", details.fatherOffice),
          ]),
          SizedBox(height: 16.h),
          _buildInfoCard("Mother's Details", [
            _buildInfoRow("Name", details.motherName),
            _buildInfoRow("Phone", details.motherPhone),
            _buildInfoRow("Occupation", details.motherOccupation),
            _buildInfoRow("Education", details.motherEducation),
            _buildInfoRow("Income", details.motherIncome),
            _buildInfoRow("Office", details.motherOffice),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
          ),
          Divider(color: CustomColor.colorGrey.withOpacity(0.2), height: 20.h),
          ...children,
        ],
      ),
    );
  }
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value!="" ? value ?? "N/A": "N/A",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
