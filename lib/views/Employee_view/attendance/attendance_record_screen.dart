import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/employee/emp_attendance_summary.dart';
import '../../../providers/employee/emp_attendance_summary_provider.dart';
import '../../../widgets/common_info_card.dart';
import '../../Student_views/attendance/widgets/attendance_record_shimmer.dart';
import '../../Student_views/attendance/widgets/monthly_breakdown.dart';
import 'attendance_detail_month.dart';
import 'widgets/attendance_bottom_sheet.dart';
import 'widgets/week_status_widget.dart';

class AttendanceRecordScreenEmp extends StatefulWidget {
  const AttendanceRecordScreenEmp({super.key});

  @override
  State<AttendanceRecordScreenEmp> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreenEmp> {
  String toYear = '';
  String fromYear = '';
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    toYear = auth.loginData!.currentyearto;
    fromYear=auth.loginData!.currentyearfrom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendanceData(auth.loginData!.currentyearto,auth.loginData!.currentyearfrom);
    });
  }

  Future<void> _fetchAttendanceData(String to,String from) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<EmployeeAttendanceSummaryProvider>(context, listen: false);

    final empId = authProvider.loginData!.empId;
    attendanceProvider.clear();
    await attendanceProvider.getEmployeeAttendanceSummary(
      fromyear: from,
      toyear: to,
      tid: empId,
    );
  }


  List<ChartData> _convertMonthWiseBreakdown(List<MonthWiseBreakdown>? monthWiseBreakdowns) {
    if (monthWiseBreakdowns == null) return [];

    return monthWiseBreakdowns.map((month) {
      return ChartData(
        month.monthName?.substring(0,3) ?? '',
        month.presentPercentage ?? 0.0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<EmployeeAttendanceSummaryProvider>(
      builder: (context, attendanceProvider, child) {
        final attendanceSummary = attendanceProvider.attendanceSummary;
        final chartData = _convertMonthWiseBreakdown(attendanceSummary?.data?.monthWiseBreakdown);
        final dateString = attendanceSummary?.data?.EmpAddtendanceSummeryInfo?.currentDate;
        
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
            title: const Text('Attendance Record'),
            backgroundColor: CustomColor.primaryColor,
            foregroundColor: CustomColor.colorWhite,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: attendanceProvider.isLoading  ? AttendanceRecordShimmer():

          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AttendanceDetailMonthEmp(
                           toYear: toYear, fromYear: fromYear,
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
                          builder: (ctx) => AttendanceDetailMonthEmp(
                            toYear: toYear, fromYear: fromYear,
                          ),
                        ),
                      );
                    },
                    child: MonthWiseBreakdownWidget(chartData: chartData)),
                SizedBox(height: 8.h),
                InfoCard(
                  icon: Icons.event_available,
                  iconColor: CustomColor.colorGreen,
                  title: 'Total Present',
                  count: attendanceSummary?.data?.EmpAddtendanceSummeryInfo?.totalPresent?.toString() ?? '0',
                ),
                InfoCard(
                  icon: Icons.watch_later_outlined,
                  iconColor: Colors.orange.shade700,
                  title: 'Total Absent',
                  count: attendanceSummary?.data?.EmpAddtendanceSummeryInfo?.totalAbsent?.toString() ?? '0',
                ),
              ],
            ),
          ),
          bottomSheet: AttendanceBottomSheet(onSessionChange: (from, to) async {
           await _fetchAttendanceData(to,from);
           setState(() {
             toYear=to;
             fromYear=from;
           });
          },percentage: attendanceSummary?.data?.EmpAddtendanceSummeryInfo?.presentPer?.toString() ?? '0', loading: attendanceProvider.isLoading,),
        );
      },
    );
  }
}
