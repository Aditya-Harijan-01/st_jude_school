// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/common/common_post_method.dart';
import '../../../../providers/employee/employee_task_provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../constants/constant.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/employee_slot_wise_task_model.dart';
import '../../../../models/employee/pending_task_model.dart';
import 'task_functions.dart';

class SlotSelectionDialog extends StatefulWidget {
  final PendingTaskData task;
  final String empId;
  final VoidCallback? onTaskAdded;

  const SlotSelectionDialog({
    super.key,
    required this.task,
    this.onTaskAdded,
    required this.empId,
  });

  @override
  State<SlotSelectionDialog> createState() => _SlotSelectionDialogState();
}

class _SlotSelectionDialogState extends State<SlotSelectionDialog> {
  SlotData? selectedSlot;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(
          maxWidth: 400.w,
          maxHeight: 600.h, // Increased height to accommodate date field
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog Header
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: CustomColor.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Add Task to Slot',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Text(
              'Select Date:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 12.h),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: CustomColor.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          TaskFunctions.formatDate(selectedDate),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Slot Selection
            Text(
              'Select Time Slot:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: 12.h),

            Consumer<EmployeeTaskProvider>(
              builder: (context, slotProvider, child) {
                if (slotProvider.isLoadingSlotWiseTask) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (slotProvider.slotWiseTaskList == null ||
                    slotProvider.slotWiseTaskList!.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[600]),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'No time slots available',
                            style: TextStyle(color: Colors.orange[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SlotData>(
                      value: selectedSlot,
                      isExpanded: true,
                      hint: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: const Text('Select a time slot'),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 300.h,
                      items: slotProvider.slotWiseTaskList!.map((slot) {
                        return DropdownMenuItem<SlotData>(
                          value: slot,
                          child: _buildSlotItem(slot),
                        );
                      }).toList(),
                      onChanged: (SlotData? value) {
                        setState(() {
                          selectedSlot = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: selectedSlot == null || isLoading
                      ? null
                      : () => _showConfirmationDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Add to Slot',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotItem(SlotData slot) {
    // final taskCount = slot.taskList?.length ?? 0; // Unused

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Time Icon
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: CustomColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.access_time,
              size: 16.sp,
              color: CustomColor.primaryColor,
            ),
          ),

          SizedBox(width: 12.w),

          // Slot Info
          Text(
            slot.slotTime ?? '',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: CustomColor.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Confirm Task Assignment',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to add this task on ${selectedSlot!.slotTime}, ${TaskFunctions.formatDate(selectedDate)}?',
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _addTaskToSlot();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Allow up to 1 year ahead
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: CustomColor.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Reset selected slot when date changes
        selectedSlot = null;
      });

      // Refresh slots based on the selected date
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final slotProvider = Provider.of<EmployeeTaskProvider>(
        context,
        listen: false,
      );

      await slotProvider.getEmployeeSlotWiseTask(
        empId: widget.empId,
        fromYear: authProvider.loginData?.currentyearfrom ?? '',
        fromDate: _formatDateForAPI(selectedDate),
        toDate: _formatDateForAPI(selectedDate),
      );
    }
  }

  String _formatDateForAPI(DateTime date) {
    // Format date as DD/MM/YYYY for API
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _addTaskToSlot() async {
    if (selectedSlot == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final Map<String, dynamic> body = {
        "fromyear": authProvider.loginData?.currentyearfrom,
        "empid": widget.empId,
        "task_id": widget.task.id,
        "task_date": _formatDateForAPI(selectedDate),
        "time_slot_id": selectedSlot!.slotId,
      };

      final response = await postRequest(ApiEndpoints.taskAllotment, body);

      if (response != null && response['statusCode'] == 'Success') {
        if (mounted) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Task "${widget.task.head}" added to ${selectedSlot!.slotTime} on ${TaskFunctions.formatDate(selectedDate)}',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );

          final slotProvider = Provider.of<EmployeeTaskProvider>(
            context,
            listen: false,
          );
          await slotProvider.getEmployeeSlotWiseTask(
            empId: widget.empId,
            fromYear: authProvider.loginData?.currentyearfrom ?? '',
            fromDate: _formatDateForAPI(selectedDate),
            toDate: _formatDateForAPI(selectedDate),
          );

          widget.onTaskAdded?.call();
        }
      } else {
        log('Error: ${response?['message'] ?? 'Unknown error'}');
        throw Exception(
          'Failed to add task: ${response?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Exception: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('Failed to add task to slot: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    }
  }
}
