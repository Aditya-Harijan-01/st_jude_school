// ignore_for_file: deprecated_member_use

import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/colors.dart';
import '../../../models/employee/teacher_timetable.dart';
import '../../../providers/employee/emp_time_table.dart';
// import '../../../widgets/overflow_marquee.dart';

class TimetableScreenEmployee extends StatefulWidget {
  const TimetableScreenEmployee({super.key});

  @override
  State<TimetableScreenEmployee> createState() =>
      _TimetableScreenEmployeeState();
}

class _TimetableScreenEmployeeState extends State<TimetableScreenEmployee> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTimetableForSelectedDate();
    });
  }

  void _fetchTimetableForSelectedDate() {
    final auth = context.read<AuthProvider>();
    final provider = context.read<EmpTimetableProvider>();

    provider.fetchEmpTimetable(
      date: DateFormat('dd/MM/yyyy').format(selectedDate),
      regNo: auth.loginData!.empId,
      fromYear: auth.loginData!.currentyearfrom.toString(),
      toYear: auth.loginData!.currentyearto.toString(),
    );
  }

  Map<String, List<TimetableData>> _groupByPeriod(List<TimetableData> items) {
    final Map<String, List<TimetableData>> map = {};
    for (final item in items) {
      map.putIfAbsent(item.period, () => []).add(item);
    }
    return map;
  }

  bool _isDayEnabled(DateTime day) => day.weekday != DateTime.sunday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColor.colorWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MY TIMETABLE',
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: CustomColor.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: SizedBox(height: 110.h, child: _buildWeekCalendar()),
            ),
          ),

          SizedBox(height: 16.h),

          /// Selected Date
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE, d MMMM').format(selectedDate),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// Timetable Content
          Expanded(
            child: Consumer<EmpTimetableProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return _buildShimmerLoading();
                }

                if (provider.hasError || provider.timetableItemsEmp.isEmpty) {
                  return _buildEmptyState();
                }

                final grouped = _groupByPeriod(provider.timetableItemsEmp);
                final periods = grouped.keys.toList();

                return RefreshIndicator(
                  color: CustomColor.primaryColor,
                  onRefresh: () async {
                    final auth = context.read<AuthProvider>();
                    await provider.refreshTimetable(
                      regNo: auth.loginData!.empId,
                      empID: auth.loginData!.empId,
                      fromYear: auth.loginData!.currentyearfrom.toString(),
                      toYear: auth.loginData!.currentyearto.toString(),
                    );
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: periods.length,
                    itemBuilder: (_, index) {
                      return _buildTimetableCard(
                        periods[index],
                        grouped[periods[index]]!,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CALENDAR ----------------
  Widget _buildWeekCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2025, 4, 1),
      lastDay: DateTime.utc(2031, 3, 31),
      focusedDay: selectedDate,
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      enabledDayPredicate: _isDayEnabled,
      onDaySelected: (day, _) {
        if (!_isDayEnabled(day)) return;
        setState(() => selectedDate = day);
        _fetchTimetableForSelectedDate();
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        weekendTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        selectedDecoration: BoxDecoration(color: Colors.white),
        selectedTextStyle: TextStyle(
          color: CustomColor.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
        weekendStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }

  // ---------------- SHIMMER ----------------
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 6,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16.h, width: 80.w, color: Colors.white),
            SizedBox(height: 10.h),
            Container(
              height: 14.h,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget _buildTimetableCard(String period, List<TimetableData> items) {
    bool hasMultipleItems = items.length > 1;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          bottomLeft: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            bottomLeft: Radius.circular(12.r),
          ),
          border: Border(
            left: BorderSide(
              color: hasMultipleItems
                  ? CustomColor.barYellow
                  : CustomColor.primaryColor,
              width: 6.w,
            ),
            top: BorderSide(
              color: hasMultipleItems
                  ? CustomColor.barYellow
                  : CustomColor.primaryColor,
              width: 1.w,
            ),
            bottom: BorderSide(
              color: hasMultipleItems
                  ? CustomColor.barYellow
                  : CustomColor.primaryColor,
              width: 1.w,
            ),
          ),
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            TimetableData item = entry.value;
            bool isLast = index == items.length - 1;

            return Column(
              children: [
                _buildSingleItem(item, period, index == 0, hasMultipleItems),
                if (!isLast)
                  Divider(
                    color: CustomColor.barYellow,
                    thickness: 1,
                    height: 1,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSingleItem(
    TimetableData item,
    String period,
    bool showPeriod,
    bool hasMultipleItems,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subject,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Class - ${item.className} ${item.streamName} ${item.section}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showPeriod)
                  Container(
                    width: 95.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: hasMultipleItems
                          ? CustomColor.barYellow
                          : CustomColor.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: CustomColor.colorWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- EMPTY ----------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80.sp,
            color: CustomColor.primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 20.h),
          Text(
            'No classes for this day',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
