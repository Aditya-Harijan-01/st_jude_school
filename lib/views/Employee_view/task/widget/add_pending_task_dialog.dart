import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/constant.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/common/common_post_method.dart';
import 'task_util.dart';

class AddPendingTaskDialog extends StatefulWidget {
  final String empId;
  final VoidCallback? onTaskAdded;

  const AddPendingTaskDialog({
    super.key,
    required this.empId,
    this.onTaskAdded,
  });

  @override
  State<AddPendingTaskDialog> createState() => _AddPendingTaskDialogState();
}

class _AddPendingTaskDialogState extends State<AddPendingTaskDialog> {
  int selectedUrgency = 0; // 0 - N/A, 1 - Low, 2 - Medium, 3 - High
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
        padding: EdgeInsets.all(20.r),
        constraints: BoxConstraints(
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
                      'Add New Pending Task',
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

              SizedBox(height: 16.h),

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
                              height: 12.w,
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

              SizedBox(height: 16.h),

              // Details Input
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
                  borderRadius: BorderRadius.circular(8.r),
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
                    contentPadding: EdgeInsets.all(12.r),
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Action Buttons
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
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed:  detailsController.text.trim().isNotEmpty && !isLoading
                        ? () => _showConfirmationDialog()
                        : null,
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
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Add Task',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
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
                'Are you sure you want to create this pending task?',
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
      _addPendingTask();
    }
  }

  Future<void> _addPendingTask() async {
    if (! detailsController.text.trim().isNotEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      final requestBody = {
        "taskType": "1",
        "urgency": selectedUrgency.toString(),
        "assignedBy": auth.loginData?.empId ,
        "assignTo": widget.empId,
        "details": detailsController.text.trim(),
        "status": "0",
      };

      final response = await postRequest(ApiEndpoints.addNewTask, requestBody);

      if (response != null && response['statusCode'] == 'Success') {
        if (mounted) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Expanded(
                    child: Text(
                      'Task was added successfully',
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

          // Call the callback to refresh the parent widget
          widget.onTaskAdded?.call();
        }
      } else {
        throw Exception('Failed to add pending task');
      }
    } catch (e) {
      log('Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('Failed to add pending task: ${e.toString()}'),
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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
