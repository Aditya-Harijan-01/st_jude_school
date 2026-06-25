import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/employee/emp_attendance_summary.dart';
import '../../../providers/employee/emp_attendance_summary_provider.dart';
import '../../../providers/student/get_session.dart';
import '../../../widgets/common_info_card.dart';
import '../../Student_views/attendance/widgets/attendance_record_shimmer.dart';
import '../../Student_views/attendance/widgets/monthly_breakdown.dart';
import '../attendance/widgets/week_status_widget.dart';
import 'month_breakdown_emp_attendance.dart';
import 'widgets/attendance_bottom_sheet2_manage.dart';


class AttendanceRecordEmpManageScreen extends StatefulWidget {
  final String empId;
  final String name;
  const AttendanceRecordEmpManageScreen({super.key, required this.empId, required this.name});

  @override
  State<AttendanceRecordEmpManageScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordEmpManageScreen> {
  String toYear = '';
  String fromYear = '';
  bool _isSessionLoaded = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    toYear = auth.loginData!.currentyearto;
    fromYear=auth.loginData!.currentyearfrom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sessionLoad(fromYear, toYear);
        _fetchAttendanceData(toYear, fromYear);
      }
    });


  }

  Future<void> _fetchAttendanceData(String to,String from) async {
    final attendanceProvider = Provider.of<EmployeeAttendanceSummaryProvider>(context, listen: false);

    attendanceProvider.clear();
    await attendanceProvider.getEmployeeAttendanceSummary(
      fromyear: from,
      toyear: to,
      tid: widget.empId,
    );
  }
  Future<void> _sessionLoad(String fYear, String tYear) async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    sessProvider.selectedSession2 = null;
    await sessProvider.getSessionSecondary(widget.empId, fYear, tYear, "Emp");
    if (mounted) {
      setState(() {
        _isSessionLoaded = true;
      });
    }
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
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: CustomColor.colorWhite,
                size: 20.sp,
              ),
            ),
            title: Text(
                "Attendance Record",
                style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
            ),
            centerTitle: true,
            backgroundColor: CustomColor.primaryColor,
            elevation: 0,
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
                        builder: (ctx) => AttendanceDetailMonthEmpManage(
                           toYear: toYear, fromYear: fromYear, empId: widget.empId,
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
                          builder: (ctx) => AttendanceDetailMonthEmpManage(
                            toYear: toYear, fromYear: fromYear, empId: widget.empId,
                          ),
                        ),
                      );
                    },
                    child: MonthWiseBreakdownWidget(chartData: chartData)),
                SizedBox(height: 8.h),
                InfoCard(
                  icon: Icons.event_available,
                  iconColor: Colors.green,
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

          bottomSheet: _isSessionLoaded ? AttendanceBottomSheet2Manage(onSessionChange: (from, to) async {
           await _fetchAttendanceData(to,from);
           setState(() {
             toYear=to;
             fromYear=from;
           });
          },
            percentage: attendanceSummary?.data?.EmpAddtendanceSummeryInfo?.presentPer?.toString() ?? '0',
            name: widget.name,
            fromYear: fromYear,
            toYear: toYear,
            loading: attendanceProvider.isLoading,
          ) : SizedBox.shrink(),
        );
      },
    );
  }
}
