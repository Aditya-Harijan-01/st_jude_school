import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/common/common_post_method.dart';
import '../../../../constants/constant.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/employee_slot_wise_task_model.dart';
import '../../../../widgets/show_loading_dialog.dart';
import 'task_util.dart';

class AddTaskDialog extends StatefulWidget {
  final String empId;
  final SlotData? slot;
  final DateTime? time;
  final VoidCallback? onTaskAdded;

  const AddTaskDialog({
    super.key,
    required this.empId,
    this.onTaskAdded,
    this.slot,
    this.time,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  int selectedUrgency = 0;
  final TextEditingController detailsController = TextEditingController();
  bool isLoading = false;



  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding:  EdgeInsets.all(16.r),
        constraints:  BoxConstraints(
          maxWidth: 450.w,
          maxHeight: 700.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_task,
                    color: CustomColor.primaryColor,
                    size: 24.sp,
                  ),
                   SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Add New Task',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  Icon(Icons.close, size: 16.sp,),
                    padding: EdgeInsets.zero,
                    constraints:  BoxConstraints(),
                  ),
                ],
              ),

               SizedBox(height: 12.h),

              Text(
                'Urgency Level:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
               SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedUrgency,
                    isExpanded: true,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    dropdownColor: Colors.white,
                    items: urgencyLabels.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: urgencyColors[entry.key],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: urgencyColors[entry.key],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          selectedUrgency = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 12.h),
              Text(
                'Date:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  widget.time != null
                      ? '${widget.time!.day}/${widget.time!.month}/${widget.time!.year}'
                      : 'No date selected',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Slot Time:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  widget.slot?.slotTime ?? 'No slot selected',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Task Details:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: detailsController,
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter task details...',

                    border: InputBorder.none,
                    contentPadding:  EdgeInsets.all(12.sp),
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _canSubmit() && !isLoading
                        ? () => _showConfirmationDialog()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.primaryColor,
                      foregroundColor: Colors.white,
                      padding:  EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 4.sp,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ?  SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        :  Text(
                            'Add Task',
                            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    bool canSubmit = detailsController.text.trim().isNotEmpty &&
        widget.slot != null &&
        widget.time != null;

    return canSubmit;
  }

  Future<void> _showConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                'Confirm Task Creation',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Are you sure you want to create this task?',
                style: TextStyle(fontSize: 16.sp),
              ),
              //  SizedBox(height: 12.h),
              // Container(
              //   padding:  EdgeInsets.all(12.r),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Text('Urgency: '),
              //           Container(
              //             width: 8.w,
              //             height: 8.h,
              //             decoration: BoxDecoration(
              //               color: urgencyColors[selectedUrgency],
              //               shape: BoxShape.circle,
              //             ),
              //           ),
              //           SizedBox(width: 4.w),
              //           Text(urgencyLabels[selectedUrgency]!),
              //         ],
              //       ),
              //        SizedBox(height: 4.h),
              //       Text('Date: ${widget.time!.day}/${widget.time!.month}/${widget.time!.year}'),
              //        SizedBox(height: 4.h),
              //       Text('Time: ${widget.slot!.slotTime}'),
              //        SizedBox(height: 4.h),
              //       Text('Details: ${detailsController.text.trim()}'),
              //     ],
              //   ),
              // ),
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
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:  Text(
                'Confirm',
                style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _addTask();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today, ${date.day}/${date.month}/${date.year}';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateForAPI(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _addTask() async {
    if (!_canSubmit()) return;

    setState(() {
      isLoading = true;
    });
    showLoadingDialog(context);


    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final assignedBy = authProvider.loginData?.empId;

      final requestBody = {
        "taskType": "1",
        "urgency": selectedUrgency.toString(),
        "assignTo": widget.empId,
        "assignedBy": assignedBy,
        "startDate": _formatDateForAPI(widget.time!),
        "taskDate": _formatDateForAPI(widget.time!),
        "timeSlotId": widget.slot!.slotId,
        "details": detailsController.text.trim(),
        "status": "1",
      };

      final response = await postRequest(ApiEndpoints.addNewTask, requestBody);

      if (response != null && response['statusCode'] == 'Success') {
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Task added successfully for ${widget.slot!.slotTime} on ${_formatDate(widget.time!)}',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          widget.onTaskAdded?.call();
        }
      } else {
        throw Exception('Failed to add task: ${response?['statusMessage'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to add task: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
