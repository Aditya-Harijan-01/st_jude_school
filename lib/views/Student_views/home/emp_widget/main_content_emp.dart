// ignore_for_file: deprecated_member_use

import 'package:st_jude_school/models/employee/emp_dashboard_model.dart';
import 'package:st_jude_school/providers/employee/employee_dashboard_provider.dart';
import 'package:st_jude_school/views/Employee_view/attendance/attendance_record_screen.dart';
import 'package:st_jude_school/views/Employee_view/calendar/calendar_emp.dart';
import 'package:st_jude_school/views/Student_views/notification_screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../calendar/calendar.dart';
import '../../notification_screen/widget/notification_attachment.dart';
import '../widgets/calender_widgets.dart';
import '../widgets/dashboard_shimmer_loading.dart';

class WeekCalendarEmp extends StatefulWidget {
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  const WeekCalendarEmp({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  State<WeekCalendarEmp> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendarEmp> {
  late DateTime startOfAcademicYear;
  late DateTime selectedDate;
  late int totalDays;
  late PageController _pageController;
  late int _focusedIndex;

  @override
  void initState() {
    super.initState();
    _initCalendarDate();
    _focusedIndex = widget.selectedDayIndex;
    selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialDate = startOfAcademicYear.add(
        Duration(days: widget.selectedDayIndex),
      );
      _fetchDashboardData(initialDate);
    });
  }

  void _initCalendarDate() {
    DateTime now = DateTime.now();
    int year = now.month >= 4 ? now.year : now.year - 1;
    startOfAcademicYear = DateTime(year, 4, 1);
    DateTime endOfAcademicYear = DateTime(year + 1, 3, 31);
    totalDays = endOfAcademicYear.difference(startOfAcademicYear).inDays + 1;
  }

  void _fetchDashboardData(DateTime date) {
    if (!mounted) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);

    Provider.of<EmpDashboardProvider>(
      context,
      listen: false,
    ).getEmpDashboardData(
      startDate: formattedDate,
      empId: auth.loginData!.empId,
      fromYear: auth.loginData!.currentyearfrom,
      toYear: auth.loginData!.currentyearto,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 60.w;

    double viewportFraction = (itemWidth / screenWidth).clamp(0.1, 1.0);

    _pageController = PageController(
      initialPage: widget.selectedDayIndex,
      viewportFraction: viewportFraction,
    );
  }

  @override
  void didUpdateWidget(WeekCalendarEmp oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDayIndex != oldWidget.selectedDayIndex) {
      // Optional: Move focus to the new selection if it changes externally
      // _focusedIndex = widget.selectedDayIndex;
      // _pageController.animateToPage(...)
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final centeredDate = startOfAcademicYear.add(Duration(days: _focusedIndex));

    return Column(
      children: [
        Container(
          height: 160.h,
          padding: EdgeInsets.symmetric(vertical: 15.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColor.primaryColor,
                CustomColor.primaryColor,
                CustomColor.lightPrGreen,
              ],
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
            ),

            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                child: Text(
                  DateFormat('MMMM yyyy').format(centeredDate).toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalDays,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _focusedIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final date = startOfAcademicYear.add(Duration(days: index));
                    final isSelected = index == widget.selectedDayIndex;
                    final dayName = DateFormat('E').format(date);
                    final dayNumber = date.day.toString();

                    return GestureDetector(
                      onTap: () {
                        widget.onDaySelected(index);
                        _fetchDashboardData(date);
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          selectedDate = date;
                          _focusedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.w,
                              height: 90.h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? CustomColor.secondaryColor
                                    : CustomColor.colorWhite,
                                borderRadius: BorderRadius.circular(30),
                                border: isSelected
                                    ? Border.all(
                                        color: CustomColor.lightPrGreen,
                                      )
                                    : null,
                                boxShadow: [
                                  if (!isSelected)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(4.r),
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: CustomColor.colorWhite,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      dayNumber,
                                      style: TextStyle(
                                        color: CustomColor.primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      color: isSelected
                                          ? CustomColor.colorWhite
                                          : CustomColor.primaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(child: _buildDashboardData(selectedDate)),
      ],
    );
  }

  Widget _buildDashboardData(DateTime date) {
    return Consumer<EmpDashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const DashboardShimmerLoading();
        }

        final model = provider.empDashboardModel;
        if (model == null) return SizedBox.shrink();

        final hasEvents = model.dataCalendar?.isNotEmpty ?? false;
        final hasNotices = model.dataNotice?.isNotEmpty ?? false;

        // if (!hasEvents && !hasNotices && !hasAssignments && !hasFee && !hasAttendace) {
        //   return Container(
        //     padding: EdgeInsets.all(20.r),
        //     alignment: Alignment.center,
        //     child: Text(
        //       "No events or notices for this day",
        //       style: TextStyle(
        //         color: CustomColor.colorGrey,
        //         fontSize: 14.sp,
        //       ),
        //     ),
        //   );
        // }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasEvents)
                ...model.dataCalendar!.expand((calendar) {
                  final Map<String, List<dynamic>> groupedEvents = {};

                  for (final event in calendar.eventName ?? []) {
                    final typeCode = event.typeCode ?? 'UNKNOWN';
                    groupedEvents.putIfAbsent(typeCode, () => []);
                    groupedEvents[typeCode]!.add(event);
                  }

                  return groupedEvents.entries.map((entry) {
                    final typeCode = entry.key;
                    final events = entry.value;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainCalendarScreen(),
                          ),
                        );
                      },

                      child: buildCalendarInfoCard(
                        color: Colors.white,
                        title: typeCode,
                        date: DateFormat.yMMMd().format(date),
                        children: events
                            .map((e) => buildInfoRow(e.eventDetails ?? 'N/A'))
                            .toList(),
                      ),
                    );
                  });
                }).toList()
              else
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmpCalendarScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: CustomColor.primaryColor),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _buildEmptyState(
                      "No Events for this day",
                      Icons.event_busy,
                      color: CustomColor.primaryColor,
                    ),
                  ),
                ),

              //
              // EmployeeAttendanceStats(),
              // StudentAttendanceStats(),
              // PaymentCollectedStats(),

              //Notice
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: CustomColor.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        CustomColor.primaryOne,
                        CustomColor.primaryColor,
                      ],
                      begin: AlignmentGeometry.topLeft,
                      end: AlignmentGeometry.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h, left: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_on,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                                _buildSectionTitle("Notices"),
                                SizedBox(width: 10.w),
                                Text(
                                  "{Last 7 days}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.colorWhite,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      if (hasNotices) ...[
                        ...model.dataNotice!.map(
                          (notice) => _buildNoticeCard(notice),
                        ),
                      ] else ...[
                        _buildEmptyState(
                          "No Notices Found",
                          Icons.notifications_off_outlined,
                          color: CustomColor.colorWhite,
                        ),
                      ],

                      // if (hasNotices)
                      //   ...model.dataNotice!

                      //       .map((notice) => _buildNoticeCard(notice))
                      // else
                      //   _buildEmptyState("No Notices Found", Icons.notifications_off_outlined, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              //Attendance
              ...model.dataAttendance!
                  .map(
                    (attendance) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AttendanceRecordScreenEmp(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: _buildAttendanceCard(attendance),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(DataAttendance attendance) {
    double percentage = double.tryParse(attendance.presentPer ?? '0') ?? 0.0;
    double progressValue = (percentage / 100).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColor.attendanceGreen,
            CustomColor.attendanceGreen.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.attendanceGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.co_present_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  percentage.toStringAsFixed(1) == "NaN"
                      ? "0 %"
                      : "${percentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Progress Bar
          Container(
            height: 8.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressValue,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAttendanceStat("Total Days", attendance.totalDay ?? "0"),
              Container(
                height: 40.h,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildAttendanceStat("Present", attendance.totalPresent ?? "0"),
              Container(
                height: 40.h,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildAttendanceStat("Absent", attendance.totalAbsent ?? "0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon, {Color? color}) {
    return Container(
      padding: EdgeInsets.all(20.r),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 40.sp,
            color: color ?? Colors.white.withOpacity(0.8),
          ),
          SizedBox(height: 10.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: color ?? Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildNoticeCard(DataNotice notice) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border(
            left: BorderSide(color: CustomColor.primaryColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColor.colorShadow.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: CustomColor.secondaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              notice.announcementTopic ?? "Notice",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomColor.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.co_present_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notice.noticeAttachments != null &&
                    notice.noticeAttachments!.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          padding: EdgeInsets.all(20.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40.w,
                                  height: 4.h,
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                              Text(
                                "Attachments",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.primaryColor,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              AttachmentNotification(
                                attachments: notice.noticeAttachments!,
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Transform.rotate(
                          angle: 0.785,
                          child: Icon(
                            Icons.attach_file,
                            color: CustomColor.primaryColor,
                            size: 22.sp,
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16.w,
                              minHeight: 16.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              notice.noticeAttachments!.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.h),
            ReadMoreText(
              notice.announcementDetails ?? "",
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Read less',
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              moreStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: CustomColor.colorBlue,
              ),
              lessStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: CustomColor.colorBlue,
              ),
            ),
            // if (notice.noticeAttachments != null && notice.noticeAttachments!.isNotEmpty)
            //   AttachmentNotification(attachments: notice.noticeAttachments!),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        notice.profileImage!,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 30.w,
                            height: 30.w,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 20.sp,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 30.w,
                            height: 30.w,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 20.sp,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      notice.fullname ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 16.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(
                            DateFormat(
                              'dd/MM/yyyy hh:mm:ss a',
                            ).parse(notice.publishedDate!),
                          )
                          .toLowerCase(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
