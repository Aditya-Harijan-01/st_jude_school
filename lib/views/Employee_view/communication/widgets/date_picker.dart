import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/employee/emp_communication.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({super.key});

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmpCommunicationProvider>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),

            // Tappable Date Field
            GestureDetector(
              onTap: () async {
                DateTime initialDate = controller.selectedDate ?? DateTime.now();
                DateTime firstDate = DateTime(2000);
                DateTime lastDate = DateTime(2100);

                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if (picked != null) {
                  controller.selectDate(picked);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.formattedDate,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: controller.selectedDate == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendar({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime currentMonth;
  late DateTime today;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    currentMonth = widget.selectedDate ?? today;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E7E7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(currentMonth.month).toUpperCase()} ${currentMonth.year}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Icon(
                      Icons.chevron_left,
                      size: 20.sp,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Icon(
                      Icons.chevron_right,
                      size: 20.sp,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Days Header
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Container(
                  height: 32.h,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: (day == 'S') ? Colors.red : Colors.black54,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 8.h),

          _buildCalendarGrid(),
        ],
      ),
    );
  }

  // Calendar Grid
  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startDate =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));

    List<Widget> rows = [];

    for (int week = 0; week < 6; week++) {
      List<Widget> weekDays = [];

      for (int day = 0; day < 7; day++) {
        final date = startDate.add(Duration(days: week * 7 + day));
        final isCurrentMonth = date.month == currentMonth.month;
        final isToday = _isSameDate(date, today);
        final isSelected = widget.selectedDate != null &&
            _isSameDate(date, widget.selectedDate!);
        final isWeekend = date.weekday == 6 || date.weekday == 7;

        weekDays.add(
          Expanded(
            child: GestureDetector(
              onTap: isCurrentMonth ? () => widget.onDateSelected(date) : null,
              child: Container(
                height: 36.h,
                alignment: Alignment.center,
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF87EDEB).withAlpha(230)
                      : isToday
                          ? const Color(0xFF87EDEB).withAlpha(75)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        (isSelected || isToday) ? FontWeight.w600 : FontWeight.normal,
                    color: !isCurrentMonth
                        ? Colors.grey.shade400
                        : (isSelected || isToday)
                            ? Colors.white
                            : isWeekend
                                ? Colors.red
                                : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      rows.add(Row(children: weekDays));
    }

    return Column(children: rows);
  }

  bool _isSameDate(DateTime d1, DateTime d2) =>
      d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

// Triangle Pointer Painter (Converted to ScreenUtil)
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
