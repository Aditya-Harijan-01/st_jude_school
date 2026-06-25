import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/colors.dart';

class BottomCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final String fromYear;
  final String toYear;

  final Function(DateTime) onDateSelected;

  const BottomCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.fromYear,
    required this.toYear,
    required this.onDateSelected,
  });

  @override
  State<BottomCalendarWidget> createState() => _BottomCalendarWidgetState();
}

class _BottomCalendarWidgetState extends State<BottomCalendarWidget> {
  bool _isDayEnabled(DateTime day) {
    return day.weekday != DateTime.sunday;
  }

  ({DateTime firstDay, DateTime lastDay}) _sessionRange() {
    final selected = DateTime.utc(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
    final from = int.tryParse(widget.fromYear) ?? selected.year;
    final to = int.tryParse(widget.toYear) ?? (from + 1);

    final first = DateTime.utc(from, 4, 1);
    final fallbackLast = DateTime.utc(from + 1, 3, 31);
    final last = DateTime.utc(to, 3, 31);

    return (
      firstDay: first,
      lastDay: first.isAfter(last) ? fallbackLast : last,
    );
  }

  DateTime _clampToRange(DateTime day, DateTime firstDay, DateTime lastDay) {
    final normalized = DateTime.utc(day.year, day.month, day.day);
    if (normalized.isBefore(firstDay)) return firstDay;
    if (normalized.isAfter(lastDay)) return lastDay;
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final range = _sessionRange();
    final safeSelectedDate = _clampToRange(
      widget.selectedDate,
      range.firstDay,
      range.lastDay,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: CustomColor.primaryColor,
            borderRadius:  BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               SizedBox(height: 40.h),
              _buildWeekCalendar(
                firstDay: range.firstDay,
                lastDay: range.lastDay,
                focusedDay: safeSelectedDate,
              ),
               SizedBox(height: 10.h),
            ],
          ),
        ),
        Positioned(
          top: -20.h,
          right: 0,
          left: 0,
          child: Container(
            margin:  EdgeInsets.symmetric(horizontal: 26.w),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: CustomColor.primaryColor,
                width: 1
              )
            ),
            child: Text(
              _formatSelectedDate(safeSelectedDate),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColor.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatSelectedDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    String dayName = days[date.weekday - 1];
    String monthName = months[date.month - 1];

    return '$dayName, ${date.day} $monthName';
  }

  Widget _buildWeekCalendar({
    required DateTime firstDay,
    required DateTime lastDay,
    required DateTime focusedDay,
  }) {
    return TableCalendar<dynamic>(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(focusedDay, day),
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats:  {
        CalendarFormat.week: 'Week',
      },
      headerVisible: false,
      enabledDayPredicate: _isDayEnabled,
      onDaySelected: (selectedDay, focusedDay) {
        if (_isDayEnabled(selectedDay)) {
          final safeDay = _clampToRange(selectedDay, firstDay, lastDay);
          setState(() {
            widget.onDateSelected(safeDay);
          });
        }
      },
      onPageChanged: (focusedDay) {
        final safeDay = _clampToRange(focusedDay, firstDay, lastDay);
        setState(() {
          widget.onDateSelected(safeDay);
        });
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle:  TextStyle(
          color: CustomColor.colorWhite,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        defaultTextStyle:  TextStyle(
          color: CustomColor.colorWhite,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        selectedTextStyle: TextStyle(
          color: CustomColor.primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        todayTextStyle: TextStyle(
          color: CustomColor.primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        disabledTextStyle: TextStyle(
          // ignore: deprecated_member_use
          color: CustomColor.colorWhite.withOpacity(0.3),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        selectedDecoration:  BoxDecoration(
          color: CustomColor.colorWhite,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: CustomColor.colorWhite.withOpacity(0.3),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        defaultDecoration:  BoxDecoration(),
        weekendDecoration:  BoxDecoration(),
        outsideDecoration:  BoxDecoration(),
        disabledDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        markerDecoration:  BoxDecoration(),
        cellMargin:  EdgeInsets.all(4.r),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:  TextStyle(
          color: CustomColor.colorWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        weekendStyle:  TextStyle(
          color: CustomColor.colorWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
