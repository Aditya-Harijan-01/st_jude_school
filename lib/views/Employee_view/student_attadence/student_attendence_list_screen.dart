
// ignore_for_file: deprecated_member_use

import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/employee/emp_student_attendence.dart';
import '../../../providers/employee/emp_student_attendance.dart';
import 'widgets/student_attenence_card.dart';

class StudentAttendanceListScreen extends StatefulWidget {
  final AttendanceClass attendanceClass;
  final String selectedDate;
  final EmpStudentAttendenceProvider attendanceProvider;
  final AuthProvider auth;

  const StudentAttendanceListScreen({
    super.key,
    required this.attendanceClass,
    required this.selectedDate,
    required this.attendanceProvider,
    required this.auth
  });

  @override
  State<StudentAttendanceListScreen> createState() => _StudentAttendanceListScreenState();
}

class _StudentAttendanceListScreenState extends State<StudentAttendanceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.attendanceProvider.getStudents(
        empId: widget.auth.loginData!.empId,
        from: widget.auth.loginData!.currentyearfrom,
        to: widget.auth.loginData!.currentyearto,
        className: widget.attendanceClass.className,
        stream: widget.attendanceClass.streamName,
        section: widget.attendanceClass.sectionName,
      );
    });
  }

  void _refreshData() {
    widget.attendanceProvider.getStudents(
      empId: widget.auth.loginData!.empId,
      from: widget.auth.loginData!.currentyearfrom,
      to: widget.auth.loginData!.currentyearto,
      className: widget.attendanceClass.className,
      stream: widget.attendanceClass.streamName,
      section: widget.attendanceClass.sectionName,
    );
  }

  void _showBatchUpdateDialog(String action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // // Progress indicator
                // SizedBox(
                //   height: 120,
                //   width: 120,
                //   child: Lottie.asset(
                //     'assets/animations/Waiting.json',
                //     height: 80,
                //     width: 80,
                //     fit: BoxFit.contain,
                //     repeat: true,
                //   ),
                // ),

                // Description
                Text(
                  'Updating student attendance.\nThis process may take a few moments.\nThank you for your patience.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: CustomColor.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    action,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20.h),

                // Progress indicator with custom styling
                Container(
                  width: double.infinity,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _areAllStudentsPresent() {
    final attendableStudents = widget.attendanceProvider.students.where((s) => s.canMarkAttendance).toList();
    if (attendableStudents.isEmpty) return false;
    return attendableStudents.every((s) => s.isPresent);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.attendanceProvider,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Update Student Attendance',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: CustomColor.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),
        body: Consumer<EmpStudentAttendenceProvider>(
          builder: (context, controller, _) {
            if (controller.isLoadingStudents) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.h),
                    Text('Loading students...'),
                  ],
                ),
              );
            }

            if (controller.students.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text('No students found for this class'),
                  ],
                ),
              );
            }

            final attendableStudents = controller.students.where((s) => s.canMarkAttendance).toList();
            final tcStudents = controller.students.where((s) => s.isTransferCertificate).toList();

            return Column(
              children: [
                // Date and Class Info Header
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (controller.isUpdatingAttendance)
                            Row(
                              children: [
                                SizedBox(
                                  width: 16.h,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Saving...',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          else
                            controller.isCompleted.isNotEmpty && controller.isCompleted == "No" ?
                            Text(
                              'Auto Save',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                            : SizedBox.shrink()
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.selectedDate,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          controller.isCompleted.isNotEmpty && controller.isCompleted == "No" ?
                          Row(
                            children: [
                              Text(
                                'Save all',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10,),
                              SizedBox(
                                width: 40.h,
                                height: 30.h,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: _areAllStudentsPresent(),
                                    onChanged: (value) async {
                                      if (controller.isUpdatingAttendance) return;
                                      
                                      // Show confirmation dialog
                                      final bool? confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                            value ? 'Mark All Present?' : 'Mark All Absent?',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            'Are you sure you want to mark all students as ${value ? 'present' : 'absent'}? This action cannot be undone.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              style: TextButton.styleFrom(
                                                foregroundColor: value ? Colors.green : Colors.red,
                                              ),
                                              child: Text(value ? 'Mark Present' : 'Mark Absent'),
                                            ),
                                          ],
                                        ),
                                      );
                                      
                                      if (confirmed == true) {
                                        // Show loading dialog
                                        _showBatchUpdateDialog(value ? 'Marking All Present' : 'Marking All Absent');
                                        
                                        // Update all student attendance using batch API
                                        await controller.updateAll(
                                          empId: widget.auth.loginData!.empId,
                                          from: widget.auth.loginData!.currentyearfrom, 
                                          to: widget.auth.loginData!.currentyearto,
                                          markAllPresent: value, 
                                        );
                                        
                                        // Hide loading dialog
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.red,
                                    inactiveTrackColor: Colors.red.withOpacity(0.3),
                                    activeTrackColor: Colors.green.withOpacity(0.3),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ],
                          )
                          : SizedBox.shrink()
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Class',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            'Students',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'PR',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'AB',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.attendanceClass.classDisplay,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Text(
                            attendableStudents.length.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 35.w),
                          Text(
                            attendableStudents.where((s) => s.isPresent).length.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 35.w),
                          Text(
                            attendableStudents.where((s) => !s.isPresent).length.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Students List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: attendableStudents.length,
                      itemBuilder: (context, index) {
                        final student = attendableStudents[index];
                        return StudentAttendanceCard(
                          student: student,
                          onToggle: () async {
                            // Toggle the attendance state
                            final originalIndex = controller.students.indexOf(student);
                            controller.toggleStudentAttendance(originalIndex);

                            // Automatically save the attendance
                            await controller.updateSingleAttendance(
                              empId: widget.auth.loginData!.empId,
                              from: widget.auth.loginData!.currentyearfrom, 
                              to: widget.auth.loginData!.currentyearto, student: student,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Error/Success Message
                if (controller.errorMessage.isNotEmpty)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: controller.errorMessage.contains('successfully') ||
                          controller.errorMessage.contains('updated')
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: controller.errorMessage.contains('successfully') ||
                            controller.errorMessage.contains('updated')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.errorMessage.contains('successfully') ||
                              controller.errorMessage.contains('updated')
                              ? Icons.check_circle
                              : Icons.error,
                          color: controller.errorMessage.contains('successfully') ||
                              controller.errorMessage.contains('updated')
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            controller.errorMessage,
                            style: TextStyle(
                              color: controller.errorMessage.contains('successfully') ||
                                  controller.errorMessage.contains('updated')
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.clearMessage(),
                          icon: const Icon(Icons.close, size: 16),
                        ),
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

  Widget studentCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18.r, backgroundColor: Colors.white),
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
      ),
    );
  }

  Widget _shimmerBox({
    double? width,
    double? height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius ?? BorderRadius.circular(8.r),
      ),
    );
  }
}
