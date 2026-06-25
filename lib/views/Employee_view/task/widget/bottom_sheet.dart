// ignore_for_file: deprecated_member_use

import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../providers/employee/employee_task_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'employee_selection_dialog.dart';

class BottomSheetTask extends StatefulWidget {
  final Widget content;
  final DateTime selectedDate;
  final String? selectedEmployeeId;
  final String selectedEmployeeName;
  final Function(DateTime) onDateChanged;
  final Function(String, String) onEmployeeChanged;

  const BottomSheetTask({
    super.key,
    required this.content,
    required this.selectedDate,
    required this.selectedEmployeeId,
    required this.selectedEmployeeName,
    required this.onDateChanged,
    required this.onEmployeeChanged,
  });

  @override
  State<BottomSheetTask> createState() => _BottomSheetTaskState();
}

class _BottomSheetTaskState extends State<BottomSheetTask> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void _openEmployeeSelectionDialog() {
    final employeeTaskProvider = Provider.of<EmployeeTaskProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: employeeTaskProvider,
        child: EmployeeSelectionDialog(
          selectedUserId: widget.selectedEmployeeId,
          onEmployeeSelected: (empId, employeeName) {
            widget.onEmployeeChanged(empId, employeeName);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeTaskProvider = Provider.of<EmployeeTaskProvider>(context);
    final isLoading = employeeTaskProvider.isLoading;

    return Container(
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border(
          top: BorderSide(
            color: CustomColor.secondaryColor,
            width: 3.h,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _openEmployeeSelectionDialog,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.4),
                              highlightColor: Colors.white.withOpacity(0.8),
                              child: Container(
                                width: 100.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            )
                          : Text(
                              widget.selectedEmployeeName,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: CustomColor.colorWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                      SizedBox(width: 2.w),

                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.4),
                                highlightColor: Colors.white.withOpacity(0.8),
                                child: Container(
                                  width: 80.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              )
                            : Text(
                                _isToday(widget.selectedDate)
                                    ? 'Today'
                                    : DateFormat('dd MMM yyyy')
                                        .format(widget.selectedDate),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: widget.content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
