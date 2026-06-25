// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/emp_student_attendence.dart';
import '../../../../providers/employee/emp_student_attendance.dart';

class AttendanceDatePicker extends StatefulWidget {
  final String selectedDate;
  final Function(String) onDateSelected;
  final String fromYear;
  final String toYear;

  const AttendanceDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.fromYear,
    required this.toYear,
  });

  @override
  State<AttendanceDatePicker> createState() => _AttendanceDatePickerState();
}

class _AttendanceDatePickerState extends State<AttendanceDatePicker> {
  List<SessionDate> _sessionDates = [];
  bool _isLoadingSessionDates = false;

  @override
  void initState() {
    super.initState();
    _loadSessionDates();
  }

  @override
  void didUpdateWidget(AttendanceDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload session dates when fromYear or toYear changes
    if (oldWidget.fromYear != widget.fromYear || oldWidget.toYear != widget.toYear) {
      _loadSessionDates();
    }
  }

  Future<void> _loadSessionDates() async {
    setState(() {
      _isLoadingSessionDates = true;
    });

    try {
      final attendanceController = EmpStudentAttendenceProvider();
      final sessionDates = await attendanceController.getSessionDates(widget.fromYear, widget.toYear);
      if (mounted) {
        setState(() {
          _sessionDates = sessionDates;
          _isLoadingSessionDates = false;
        });
      }
    } catch (e) {
      log('Error loading session dates: $e');
      if (mounted) {
        setState(() {
          _sessionDates = [];
          _isLoadingSessionDates = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.blue[600],
            size: 20,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.selectedDate,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Show session date range if available
                if (_sessionDates.isNotEmpty)
                  Text(
                    'Session: ${_sessionDates.first.formattedStartDate} - ${_sessionDates.first.formattedEndDate}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  )
                else if (_isLoadingSessionDates)
                  Text(
                    'Loading session dates...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  )
                else
                  Text(
                    'Session: ${widget.fromYear}-${widget.toYear}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showDatePicker(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Change',
              style: TextStyle(
                color: CustomColor.colorWhite,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    if (_sessionDates.isEmpty && !_isLoadingSessionDates) {
      // Show loading dialog while fetching session dates
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Fetch session dates from API using current session years
        final attendanceController = EmpStudentAttendenceProvider();
        final sessionDates = await attendanceController.getSessionDates(widget.fromYear, widget.toYear);

        // Close loading dialog
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        if (sessionDates.isEmpty) {
          // Fallback to year-based date range if no API data
          _showFallbackDatePicker(context);
          return;
        }

        setState(() {
          _sessionDates = sessionDates;
        });
      } catch (e) {
        // Close loading dialog if still open
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Show error and fallback to year-based picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load session dates. Using fallback date range.'),
            backgroundColor: Colors.orange,
          ),
        );
        _showFallbackDatePicker(context);
        return;
      }
    }

    if (_sessionDates.isEmpty) {
      _showFallbackDatePicker(context);
      return;
    }

    // Use the session date range
    final sessionDate = _sessionDates.first;
    final today = DateTime.now();

    // Determine initial date for picker
    DateTime initialDate;
    if (widget.selectedDate.isNotEmpty) {
      try {
        final currentSelected = _parseDate(widget.selectedDate);
        // Check if current selected date is within session range
        if (sessionDate.isDateInSession(currentSelected)) {
          initialDate = currentSelected;
        } else {
          // Current selected is outside range, use today if in range, otherwise start date
          if (sessionDate.isDateInSession(today)) {
            initialDate = today;
          } else {
            initialDate = sessionDate.startDate;
          }
        }
      } catch (e) {
        initialDate = sessionDate.isDateInSession(today) ? today : sessionDate.startDate;
      }
    } else {
      initialDate = sessionDate.isDateInSession(today) ? today : sessionDate.startDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: sessionDate.startDate,
      lastDate: sessionDate.endDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: CustomColor.colorWhite,
              surface: CustomColor.colorWhite,
              onSurface: CustomColor.colorBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      widget.onDateSelected(formattedDate);
    }
  }

  void _showFallbackDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(widget.selectedDate),
      firstDate: DateTime(int.parse(widget.fromYear), 1, 1),
      lastDate: DateTime(int.parse(widget.toYear), 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: CustomColor.colorWhite,
              surface: CustomColor.colorWhite,
              onSurface: CustomColor.colorBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      widget.onDateSelected(formattedDate);
    }
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }
}
