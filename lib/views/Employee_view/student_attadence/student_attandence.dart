// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';
import '../../../models/employee/emp_student_attendence.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/emp_student_attendance.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/student/get_session.dart';
import '../widget/top_card.dart';
import 'student_attendence_list_screen.dart';
import 'widgets/alert_denied.dart';
import 'widgets/attendence_class_card.dart';
import 'widgets/attendence_date_picker.dart';

class EmpStudentAttandenceScreen extends StatefulWidget {
  const EmpStudentAttandenceScreen({super.key});

  @override
  State<EmpStudentAttandenceScreen> createState() =>
      _EmpStudentAttandenceScreenState();
}

class _EmpStudentAttandenceScreenState extends State<EmpStudentAttandenceScreen> {

  late EmpStudentAttendenceProvider empStdAttendProvider;
  late AuthProvider userProvider;
  bool _isSessionChanging = false;
  String empId = '';
  String fromYear = '';
  String toyear = '';

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<AuthProvider>(context, listen: false);
    empStdAttendProvider = EmpStudentAttendenceProvider();

    empId = userProvider.loginData!.empId;
    fromYear = userProvider.loginData!.currentyearfrom;
    toyear = userProvider.loginData!.currentyearto;

    // Set today's date as default
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    empStdAttendProvider.setDate(today);

    // Load classes for today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // For users with access value 1, reset to their default session
      _resetToDefaultSessionIfNeeded();
      empStdAttendProvider.getActiveClasses(empId,fromYear,toyear);
    });
  }

  void _resetToDefaultSessionIfNeeded() {
    

    // Calculate the correct session based on current date
    final now = DateTime.now();
    final currentYear = now.year;
    final april1st = DateTime(currentYear, 4, 1); // April 1st of current year

    String defaultFromYear;
    String defaultToYear;

    if (now.isBefore(april1st)) {
      // Before April 1st: Previous year session
      // Example: If today is March 2025, session should be 2024-2025
      defaultFromYear = (currentYear - 1).toString();
      defaultToYear = currentYear.toString();
    } else {
      // On or after April 1st: Current year session
      // Example: If today is April 2025 or later, session should be 2025-2026
      defaultFromYear = currentYear.toString();
      defaultToYear = (currentYear + 1).toString();
    }

  }

  @override
  void dispose() {
    empStdAttendProvider.dispose();
    super.dispose();
  }

  void _showAccessDeniedDialog() {
    showAccessDeniedDialog(context, 'Student Attendance');
  }

  void _onDateSelected(String date) {
    empStdAttendProvider.setDate(date);
    empStdAttendProvider.getActiveClasses(empId,fromYear,toyear);
  }

  void _refreshData() {
    empStdAttendProvider.getActiveClasses(empId,fromYear,toyear);
  }

  // Session change callback for the common header
  Future<void> _onSessionChange(BuildContext context) async {
    setState(() {
      _isSessionChanging = true;
    });

    try {
      final userProvider = Provider.of<AuthProvider>(context, listen: false);

      // Get session dates from API using the NEW session years
      final sessionDates = await empStdAttendProvider.getSessionDates(
        userProvider.loginData!.currentyearfrom,
        userProvider.loginData!.currentyearto,
      );

      if (sessionDates.isNotEmpty) {
        final sessionDate = sessionDates.first;
        final today = DateTime.now();

        // Determine the default date for the new session
        String defaultDate;
        if (today.isAfter(sessionDate.startDate.subtract(Duration(days: 1))) &&
            today.isBefore(sessionDate.endDate.add(Duration(days: 1)))) {
          // Today is within session range, use today
          defaultDate = DateFormat('dd/MM/yyyy').format(today);
        } else {
          // Today is outside session range, use session start date
          defaultDate = DateFormat('dd/MM/yyyy').format(sessionDate.startDate);
        }

        // Set the new default date
        empStdAttendProvider.setDate(defaultDate);
      } else {
        // Fallback: set to first day of the from year if no session dates found
        final fallbackDate = DateTime(
          int.parse(userProvider.loginData!.currentyearfrom),
          4,
          1,
        ); // April 1st
        empStdAttendProvider.setDate(
          DateFormat('dd/MM/yyyy').format(fallbackDate),
        );
      }

      // Refresh attendance data for the new session
      await empStdAttendProvider.getActiveClasses(empId, fromYear,toyear);

      // Force rebuild to update date picker with new session dates
      setState(() {});
    } finally {
      setState(() {
        _isSessionChanging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>();
    final auth = context.read<AuthProvider>();
    final empProvider = context.watch<EmployeeProfileProvider>();
    return ChangeNotifierProvider.value(
      value: empStdAttendProvider,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.primaryColor,
          title: Text(
            "Student Attendance",
            style: TextStyle(color: CustomColor.colorWhite, fontSize: 20.sp),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: CustomColor.colorWhite),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.grey[50],
        body: Consumer3<
          EmpStudentAttendenceProvider,
          EmployeeProfileProvider,
          AuthProvider
        >(
          builder: (
            context,
            attendanceProvider,
            profileProvider,
            userProvider,
            _,
          ) {
            // Show access denied dialog if needed
            if (attendanceProvider.userAccessValue != 0 &&
                attendanceProvider.userAccessValue != 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAccessDeniedDialog();
              });
            }

            // Check if user can change session (user_access_value == 0)
            final canChangeSession = attendanceProvider.userAccessValue == 0;

            return Column(
              children: [
                // SESSION TOP CARD
                buildTopCard(
                  (from, to) async {
                    // await attend.onSessionChange(context, from, to);
                  },
                  session,
                  empProvider,
                  auth.loginData?.empId ?? "",
                  "",
                  "",
                  false
                ),

                // Session display for users without session change access (only show after loading)
                if (!attendanceProvider.isLoading && !canChangeSession)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Consumer<AuthProvider>(
                      builder: (context, userProvider, _) {
                        final currentSession =
                            '${userProvider.loginData?.currentyearfrom}-${userProvider.loginData!.currentyearto}';
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_view_month,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Academic Session: $currentSession',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                // Error Message
                if (attendanceProvider.errorMessage.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color:
                        attendanceProvider.errorMessage.contains(
                          'successfully',
                        )
                        ? Colors.green[100]
                        : Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                          attendanceProvider.errorMessage.contains(
                            'successfully',
                          )
                          ? Colors.green
                          : Colors.red,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          attendanceProvider.errorMessage.contains(
                            'successfully',
                          )
                          ? Icons.check_circle
                          : Icons.error,
                          color:
                            attendanceProvider.errorMessage.contains(
                              'successfully',
                            )
                            ? Colors.green
                            : Colors.red,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            attendanceProvider.errorMessage,
                            style: TextStyle(
                              color:
                                attendanceProvider.errorMessage.contains(
                                  'successfully',
                                )
                                ? Colors.green[800]
                                : Colors.red[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => attendanceProvider.clearMessage(),
                          icon: Icon(Icons.close, size: 16.sp),
                        ),
                      ],
                    ),
                  ),

                // Session changing indicator
                if (_isSessionChanging)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Updating session data...',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Date Picker for all users (both user_access_value 0 and 1)
                if (!attendanceProvider.isLoading)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Consumer<AuthProvider>(
                      builder: (context, userProvider, _) {
                        return AttendanceDatePicker(
                          selectedDate: attendanceProvider.selectedDate,
                          onDateSelected: _onDateSelected,
                          fromYear: userProvider.loginData!.currentyearfrom,
                          toYear: userProvider.loginData!.currentyearto,
                        );
                      },
                    ),
                  ),

                // Classes Header Row
                if (!attendanceProvider.isLoading && attendanceProvider.classes.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Class',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Students',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'PR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'AB',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Classes List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    child:
                        attendanceProvider.isLoading
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading classes...'),
                                ],
                              ),
                            )
                            : attendanceProvider.classes.isEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return 
                                    studentCardShimmer();
                              }
                            ) : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              itemCount: attendanceProvider.classes.length,
                              itemBuilder: (context, index) {
                                final classData =
                                    attendanceProvider.classes[index];
                                return AttendanceClassCard(
                                  attendanceClass: classData,
                                  selectedDate:
                                      attendanceProvider.selectedDate,
                                  onTap:
                                    classData.isClickable
                                      ? () =>
                                        _navigateToStudentList(classData)
                                      : null,
                                );
                              },
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget studentCardShimmer() {
    return  Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(width: 140.w, height: 14.h),
                  SizedBox(height: 6.h),
                  _shimmerBox(width: 80.w, height: 12.h),
                ],
              ),
            ),

            SizedBox(width: 12.w),
            _shimmerBox(width: 40.w, height: 20.h),
          ],
        )
    );
  }

  Widget _shimmerBox({
    double? width,
    double? height,
    BorderRadius? radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius ?? BorderRadius.circular(8.r),
      ),
    )
    );
  }

  void _navigateToStudentList(AttendanceClass classData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StudentAttendanceListScreen(
              attendanceClass: classData,
              selectedDate: empStdAttendProvider.selectedDate,
              attendanceProvider: empStdAttendProvider,
              auth: userProvider
            ),
      ),
    );
  }
}

