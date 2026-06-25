import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../../../../providers/employee/emp_attendance_monthwise.dart';

class CalendarScreen extends StatefulWidget {
  final String monthId;
  final String toYear;
  final String fromYear;
  final Function(String) onMonthChanged;
  const CalendarScreen({
    super.key,
    required this.monthId,
    required this.onMonthChanged,
    required this.toYear,
    required this.fromYear,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ScrollController _monthScrollController = ScrollController();

  DateTime _focusedDay = DateTime.now();
  String _currentMonth = '';
  late int _currentYear;

  final List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Map<int, String> monthNameMap = {
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
  };

  @override
  void initState() {
    super.initState();
    _currentYear = int.parse(widget.monthId) > 3
        ? int.parse(widget.fromYear)
        : int.parse(widget.toYear);
    _currentMonth = monthNameMap[int.parse(widget.monthId)] ?? '';
    _focusedDay = DateTime(_currentYear, int.parse(widget.monthId), 1);

    // Ensure initial selected month chip is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  @override
  void didUpdateWidget(CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monthId != widget.monthId) {
      setState(() {
        _currentMonth = monthNameMap[int.parse(widget.monthId)] ?? 'Nov';
        _focusedDay = DateTime(_currentYear, int.parse(widget.monthId), 1);
      });

      // When parent-provided monthId changes, keep selected chip in view
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedMonth();
      });
    }
  }

  void _scrollToSelectedMonth() {
    if (!_monthScrollController.hasClients) return;

    final List<String> orderedMonths = [
      for (int m = 4; m <= 12; m++) monthNameMap[m]!,
      for (int m = 1; m <= 3; m++) monthNameMap[m]!,
    ];

    final int index = orderedMonths.indexOf(_currentMonth);
    if (index == -1) return;

    final double chipWidth = 50.w;
    final double spacing = 8.w;
    final double targetOffset = index * (chipWidth + spacing);

    _monthScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _changeMonth(String monthName) {
    setState(() {
      _currentMonth = monthName;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });

    // Find the month ID and notify parent
    int monthId = monthNameMap.entries
        .firstWhere(
          (entry) => entry.value == monthName,
          orElse: () => const MapEntry(11, 'Nov'),
        )
        .key;

    widget.onMonthChanged(monthId.toString());
  }

  String? _getDateStatus(
    DateTime day,
    EmployeeMonthlyAttendanceDetailProvider provider,
  ) {
    final dateString =
        "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}";
    return provider.getAttendanceStatus(dateString);
  }

  bool _isHoliday(
    DateTime day,
    EmployeeMonthlyAttendanceDetailProvider provider,
  ) {
    final dateString =
        "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}";
    return provider.isHoliday(dateString);
  }

  String? _getHolidayDetails(
    DateTime day,
    EmployeeMonthlyAttendanceDetailProvider provider,
  ) {
    // Format date as "dd/MM/yyyy" to match the API response
    final dateString =
        "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}";
    return provider.getHolidayDetails(dateString);
  }

  bool _hasAttendanceRecord(
    DateTime day,
    EmployeeMonthlyAttendanceDetailProvider provider,
  ) {
    final dateString =
        "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}";
    return provider.getAttendanceStatus(dateString) != null ||
        provider.isHoliday(dateString);
  }

  Color _getHighlightColor(
    DateTime day,
    EmployeeMonthlyAttendanceDetailProvider provider,
  ) {
    if (_isHoliday(day, provider)) {
      return Colors.blueAccent;
    }

    String? status = _getDateStatus(day, provider);
    if (status == "Present") {
      return CustomColor.primaryColor;
    } else if (status == "Absent") {
      return CustomColor.colorRed;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeMonthlyAttendanceDetailProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SingleChildScrollView(
                controller: _monthScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...() {
                      final List<Widget> chips = [];

                      for (int month = 4; month <= 12; month++) {
                        final monthName = monthNameMap[month]!;
                        chips.add(
                          _buildMonthChip(
                            monthName,
                            _currentMonth == monthName,
                            () => _changeMonth(monthName),
                          ),
                        );
                        chips.add(SizedBox(width: 8.w));
                      }

                      for (int month = 1; month <= 3; month++) {
                        final baseName = monthNameMap[month]!;
                        chips.add(
                          _buildMonthChip(
                            baseName,
                            _currentMonth == baseName,
                            () => _changeMonth(baseName),
                          ),
                        );
                        chips.add(SizedBox(width: 8.w));
                      }

                      if (chips.isNotEmpty) {
                        chips.removeLast(); // Remove trailing spacing
                      }
                      return chips;
                    }(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: CustomColor.colorBlack.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar(
                availableGestures: AvailableGestures.none,
                firstDay: DateTime(int.parse(widget.fromYear), 4, 1),
                lastDay: DateTime(int.parse(widget.toYear), 3, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => false,
                onDaySelected: null,
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                daysOfWeekHeight: 40.h,
                rowHeight: 46.h,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  outsideTextStyle: TextStyle(color: Colors.grey[300]),
                  defaultTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.sp,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  prioritizedBuilder: (context, day, focusedDay) {
                    if (day.weekday == DateTime.sunday) {
                      return Center(
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: CustomColor.colorRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    final hasRecord = _hasAttendanceRecord(day, provider);
                    final isHoliday = _isHoliday(day, provider);
                    final textColor = isHoliday ? CustomColor.colorGreen : Colors.black87;

                    return Center(
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: hasRecord
                            ? BoxDecoration(
                                color: _getHighlightColor(day, provider),
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: hasRecord
                                  ? CustomColor.colorWhite
                                  : textColor,
                              fontWeight: hasRecord
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final hasRecord = _hasAttendanceRecord(day, provider);
                    final isHoliday = _isHoliday(day, provider);
                    final textColor = isHoliday ? CustomColor.colorGreen : Colors.black87;

                    return Center(
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: hasRecord
                            ? BoxDecoration(
                                color: _getHighlightColor(day, provider),
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: hasRecord
                                  ? CustomColor.colorWhite
                                  : textColor,
                              fontWeight: hasRecord
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14.sp,

                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Legend
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(CustomColor.primaryColor, 'Present'),
                  _buildLegendItem(CustomColor.colorRed, 'Absent'),
                  _buildLegendItem(Colors.blueAccent, 'Holiday'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthChip(String month, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? CustomColor.primaryColor : Colors.grey[300]!,
            width: 1.w,
          ),
        ),
        child: Text(
          month,
          style: TextStyle(
            color: isSelected ? CustomColor.colorWhite : Colors.black87,
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18.w,
          height: 18.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
