import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/Students/student_attendance_summary.dart';
import '../../../providers/student/student_attendance_summary_provider.dart';
import '../../../widgets/common_info_card.dart';
import 'attendance_detail_month.dart';
import 'widgets/attendance_bottom_sheet.dart';
import 'widgets/attendance_record_shimmer.dart';
import 'widgets/monthly_breakdown.dart';
import 'widgets/week_status_widget.dart';

class AttendanceRecordScreen extends StatefulWidget {
  const AttendanceRecordScreen({super.key});

  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  String toYear = '';
  String fromYear = '';
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    toYear = auth.loginData!.currentyearto;
    fromYear = auth.loginData!.currentyearfrom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendanceData(
        auth.loginData!.currentyearto,
        auth.loginData!.currentyearfrom,
      );
    });
  }

  Future<void> _fetchAttendanceData(String to, String from) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<StudentAttendanceSummaryProvider>(
      context,
      listen: false,
    );

    final regno = authProvider.loginData!.regno;

    await attendanceProvider.getStudentAttendanceSummary(
      regno: regno,
      fromyear: from,
      toyear: to,
    );
  }

  List<ChartData> _convertMonthWiseBreakdown(
    List<MonthWiseBreakdown>? monthWiseBreakdowns,
  ) {
    if (monthWiseBreakdowns == null) return [];

    return monthWiseBreakdowns.map((month) {
      return ChartData(
        month.monthName?.substring(0, 3) ?? '',
        month.presentPercentage ?? 0.0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentAttendanceSummaryProvider>(
      builder: (context, attendanceProvider, child) {
        final attendanceSummary = attendanceProvider.attendanceSummary;
        final chartData = _convertMonthWiseBreakdown(
          attendanceSummary?.data?.monthWiseBreakdown,
        );
        final dateString =
            attendanceSummary?.data?.studentAddtendanceSummeryInfo?.currentDate;

        // Handle null dateString safely
        DateTime today;
        try {
          today = dateString != null
              ? DateFormat('dd/MM/yyyy').parse(dateString)
              : DateTime.now();
        } catch (e) {
          today = DateTime.now();
        }

        return Scaffold(
          backgroundColor: CustomColor.colorWhite,
          appBar: AppBar(
            title: Text('Attendance Record', style: TextStyle(fontSize: 24.sp)),
            backgroundColor: CustomColor.primaryColor,
            foregroundColor: CustomColor.colorWhite,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 24.sp),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
          ),
          body: attendanceProvider.isLoading
              ? AttendanceRecordShimmer()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AttendanceDetailMonth(
                                toYear: toYear,
                                fromYear: fromYear,
                              ),
                            ),
                          );
                        },
                        child: WeekStatusWidget(
                          currentDate: today,
                          weekStatus: attendanceSummary?.data?.weekStatus,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AttendanceDetailMonth(
                                toYear: toYear,
                                fromYear: fromYear,
                              ),
                            ),
                          );
                        },
                        child: MonthWiseBreakdownWidget(chartData: chartData),
                      ),
                      SizedBox(height: 8.h),
                      InfoCard(
                        icon: Icons.event_available,
                        iconColor: Colors.green,
                        title: 'Total Present',
                        count:
                            attendanceSummary
                                ?.data
                                ?.studentAddtendanceSummeryInfo
                                ?.totalPresent
                                ?.toString() ??
                            '0',
                      ),
                      InfoCard(
                        icon: Icons.watch_later_outlined,
                        iconColor: Colors.orange.shade700,
                        title: 'Total Absent',
                        count:
                            attendanceSummary
                                ?.data
                                ?.studentAddtendanceSummeryInfo
                                ?.totalAbsent
                                ?.toString() ??
                            '0',
                      ),
                    ],
                  ),
                ),
          bottomSheet: AttendanceBottomSheet(
            onSessionChange: (from, to) async {
              await _fetchAttendanceData(to, from);
              setState(() {
                toYear = to;
                fromYear = from;
              });
            },
            percentage:
                attendanceSummary
                    ?.data
                    ?.studentAddtendanceSummeryInfo
                    ?.presentPer
                    ?.toString() ??
                '0',
            loading: attendanceProvider.isLoading,
          ),
        );
      },
    );
  }
}
