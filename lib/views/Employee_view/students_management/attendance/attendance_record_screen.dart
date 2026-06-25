import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/Students/student_attendance_summary.dart';
import '../../../../providers/student/get_session.dart';
import '../../../../providers/student/student_attendance_summary_provider.dart';
import '../../../../widgets/common_info_card.dart';
import '../../../Student_views/attendance/widgets/attendance_record_shimmer.dart';
import '../../../Student_views/attendance/widgets/monthly_breakdown.dart';
import '../../../Student_views/attendance/widgets/week_status_widget.dart';
import 'attendance_detail_month.dart';
import 'widgets/attendance_bottom_sheet_from_emp.dart';



class AttendanceRecordScreenFromEmp extends StatefulWidget {
  final String regNo;
  final String fromYear;
  final String toYear;
  final String name;
  const AttendanceRecordScreenFromEmp({super.key, required this.regNo, required this.fromYear, required this.toYear, required this.name});

  @override
  State<AttendanceRecordScreenFromEmp> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreenFromEmp> {
  String toYear = '';
  String fromYear = '';
  @override
  void initState() {
    super.initState();

    toYear = widget.toYear;
    fromYear= widget.fromYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendanceData(toYear,fromYear);
      _sessionLoad(fromYear, toYear);
    });
  }
  Future<void> _sessionLoad(String fYear, String tYear) async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    await sessProvider.getSessionSecondary(widget.regNo, fYear, tYear, "Student");
  }
  Future<void> _fetchAttendanceData(String to,String from) async {
    final attendanceProvider = Provider.of<StudentAttendanceSummaryProvider>(context, listen: false);

    await attendanceProvider.getStudentAttendanceSummary(
      regno: widget.regNo,
      fromyear: from,
      toyear: to,
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

    return Consumer2<StudentAttendanceSummaryProvider, SessionProvider>(
      builder: (context, attendanceProvider,ss, child) {
        final attendanceSummary = attendanceProvider.attendanceSummary;
        final chartData = _convertMonthWiseBreakdown(attendanceSummary?.data?.monthWiseBreakdown);
        final dateString = attendanceSummary?.data?.studentAddtendanceSummeryInfo?.currentDate;
        
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
            title:  Text('Attendance Record',
                 style: TextStyle(
                   fontSize: 24.sp
                 ),
            ),
            backgroundColor: CustomColor.primaryColor,
            foregroundColor: CustomColor.colorWhite,
            leading: IconButton(
              icon:  Icon(Icons.arrow_back, size: 24.sp,),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
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
                        builder: (ctx) => AttendanceDetailMonth2(
                           toYear: toYear, fromYear: fromYear, regId: widget.regNo,
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
                          builder: (ctx) => AttendanceDetailMonth2(
                            toYear: toYear, fromYear: fromYear, regId: widget.regNo,
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
                  count: attendanceSummary?.data?.studentAddtendanceSummeryInfo?.totalPresent?.toString() ?? '0',
                ),
                InfoCard(
                  icon: Icons.watch_later_outlined,
                  iconColor: Colors.orange.shade700,
                  title: 'Total Absent',
                  count: attendanceSummary?.data?.studentAddtendanceSummeryInfo?.totalAbsent?.toString() ?? '0',
                ),
              ],
            ),
          ),
          bottomSheet: !ss.isLoading ? AttendanceBottomSheet2(onSessionChange: (from, to) async {
           await _fetchAttendanceData(to,from);
           setState(() {
             toYear=to;
             fromYear=from;
           });
          },percentage: attendanceSummary?.data?.studentAddtendanceSummeryInfo?.presentPer?.toString() ?? '0', loading: attendanceProvider.isLoading, name: widget.name, fYear: fromYear, toYear: toYear,) :
          SizedBox.shrink(),
        );
      },
    );
  }
}
