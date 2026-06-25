
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/student/student_monthly_attendance_detail_provider.dart';
import '../../../Student_views/attendance/widgets/att_details_circular_graph.dart';
import '../../../Student_views/attendance/widgets/attendance_detail_month_shimmer.dart';
import '../../attendance/widgets/calender_monthly_attendance.dart';

class AttendanceDetailMonth2 extends StatefulWidget {
  final String toYear;
  final String fromYear;
  final String regId;
  const AttendanceDetailMonth2({
    super.key, required this.toYear, required this.fromYear, required this.regId,

  });

  @override
  State<AttendanceDetailMonth2> createState() => _AttendanceDetailMonthState();
}
String _getMonthName(int month) {
  const monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return monthNames[month - 1];
}
class _AttendanceDetailMonthState extends State<AttendanceDetailMonth2> {
  late StudentMonthlyAttendanceDetailProvider _attendanceProvider;
  bool _isLoading = true;
  late String monthId;
  
  @override
  void initState() {
    super.initState();
    monthId = DateTime.now().month.toString();
    _attendanceProvider = Provider.of<StudentMonthlyAttendanceDetailProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttendanceData();
    });
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      _isLoading = true;
    });

    final fromYear = widget.fromYear;
    final toYear = widget.toYear;

    await _attendanceProvider.getStudentMonthwiseAttendanceDetail(
      regno: widget.regId,
      fromyear: fromYear,
      toyear: toYear,
      monthid: monthId,
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _onMonthChanged(String newMonthId) {
    setState(() {
      monthId = newMonthId;
    });
    _loadAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    _attendanceProvider = Provider.of<StudentMonthlyAttendanceDetailProvider>(context, listen: false);

    final int presentDays = _attendanceProvider.totalPresentDays;
    final int totalDays = _attendanceProvider.monthlyAttendanceDetail?.data?.monthwiseAttendance?.length ?? 0;
    final int absentDays = totalDays > presentDays ? totalDays - presentDays : 0;
    final double presentPercentage = totalDays > 0 ? (presentDays / totalDays) * 100 : 0.0;


    final List<ChartAttendanceMonth> chartData = [
      ChartAttendanceMonth('Present', presentDays.toDouble()),
      ChartAttendanceMonth('Absent', absentDays.toDouble()),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Attendance Detail'),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: CustomColor.colorWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const AttendanceDetailMonthShimmer()
          : Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  AttDetailsCircularGraph(
                    title: '${_getMonthName(int.parse(monthId))} (${widget.fromYear}-${widget.toYear})',
                    percentage: '${presentPercentage.toStringAsFixed(2)}%',
                    presentDays: presentDays,
                    totalDays: totalDays,
                    chartData: chartData,
                  ),
                  CalendarScreen(
                    monthId: monthId,
                    toYear: widget.toYear,
                    fromYear: widget.fromYear,
                    onMonthChanged: _onMonthChanged,
                  ),
                ],
              ),
            ),

    );
  }
}
