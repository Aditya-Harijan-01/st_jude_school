import '../../../providers/auth_provider/auth_provider.dart';
import '../widget/common_bottom_sheet_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';

import 'package:provider/provider.dart';
import '../../../providers/employee/student_management.dart';
import '../../../widgets/info_card_shimmer.dart';
import '../widget/access_denied_dialog.dart';
import 'widgets/class_dropdown_widget.dart';
import 'widgets/student_menu_modal.dart';

class StudentsManageScreen extends StatefulWidget {
  const StudentsManageScreen({super.key});

  @override
  State<StudentsManageScreen> createState() => _StudentsManageScreenState();
}

class _StudentsManageScreenState extends State<StudentsManageScreen> {
  final TextEditingController _searchStudentController =
      TextEditingController();
  String _searchQuery = '';
  String fromYear = '';
  String toYear = '';
  bool _hasShownAccessDeniedDialog = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    fromYear = auth.loginData!.currentyearfrom;
    toYear = auth.loginData!.currentyearto;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClass();
    });
  }

  Future<void> _loadClass() async {
    final auth = context.read<AuthProvider>();
    final studentProvider = Provider.of<StudentManagementProvider>(
      context,
      listen: false,
    );

    await studentProvider.getAllActiveClassList(
      auth.loginData!.empId,
      fromYear,
      toYear,
    );

    if (studentProvider.selectedClass != null) {
      studentProvider.getStudentList(auth.loginData!.empId, fromYear, toYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Students",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Consumer<StudentManagementProvider>(
        builder: (context, provider, child) {
          if (provider.userAccessValue != 0 && !_hasShownAccessDeniedDialog) {
            _hasShownAccessDeniedDialog = true;
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccessDeniedDialog(
                context,
                'You do not have permission to view detailed student management data.',
              );
            });
          }

          return Column(
            children: [
              if (provider.studentList.isEmpty ||
                  provider.isStudentLoading ||
                  provider.isLoading)
                const SizedBox.shrink()
              else
                Column(
                  children: [
                    SizedBox(height: 8.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        controller: _searchStudentController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search students...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: CustomColor.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: CustomColor.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: CustomColor.primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: CustomColor.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomColor.primaryColor,
                      CustomColor.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.r),
                    bottom: Radius.zero,
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: CustomColor.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Reg No.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Student Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isStudentLoading || provider.isLoading) {
                      return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InfoCardShimmer(),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      );
                    }

                    if (provider.studentList.isEmpty) {
                      return Center(
                        child: Text(
                          "No students found",
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                      );
                    }

                    final filteredList = provider.studentList.where((student) {
                      final name = student.studentName.toLowerCase();
                      final reg = student.regno.toLowerCase();
                      return name.contains(_searchQuery) ||
                          reg.contains(_searchQuery);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text(
                          "No matching students found",
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final student = filteredList[index];
                        return Card(
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.only(bottom: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            // side: BorderSide(
                            //   color: CustomColor.primaryColor,
                            //   width: 0.5,
                            // ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            splashColor: CustomColor.primaryColor.withAlpha(50),
                            highlightColor: CustomColor.secondaryColor
                                .withAlpha(50),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => StudentMenuModal(
                                  student: student,
                                  fromYear: fromYear,
                                  toYear: toYear,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          CustomColor.primaryColor.withAlpha(
                                            150,
                                          ),
                                          CustomColor.primaryOne,
                                        ],
                                        begin: AlignmentGeometry.topLeft,
                                        end: AlignmentGeometry.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        bottomLeft: Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      student.regno,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 18.w),
                                  Expanded(
                                    child: Text(
                                      student.studentName,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: CustomColor.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 14.sp,
                                      color: CustomColor.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CommonBottomSheetEmp(
        onSessionChange: (from, to) async {
          _searchStudentController.clear();
          setState(() {
            toYear = to;
            fromYear = from;
          });
          await _loadClass();
        },
        content: ClassDropdownWidget(fromYear: fromYear, toYear: toYear),
      ),
    );
  }
}
