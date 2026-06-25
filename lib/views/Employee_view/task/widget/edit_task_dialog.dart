import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constant.dart';
import '../../../../models/employee/employee_slot_wise_task_model.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/common/common_post_method.dart';
import '../../../../widgets/parse_html_to_text.dart';
import '../../../../widgets/show_loading_dialog.dart';

class EditTaskDialog extends StatefulWidget {
  final Task? task;
  final DateTime? time;
  final VoidCallback? onTaskUpdated;

  const EditTaskDialog({
    super.key,
    this.task,
    this.onTaskUpdated,
    this.time,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  int selectedUrgency = 0;
  final TextEditingController detailsController = TextEditingController();

  bool isLoading = false;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _initializeFields();
  }

  void _initializeFields() {
    detailsController.text = widget.task?.details != null
        ? parseHtmlToText(widget.task!.details)
        : '';

    selectedUrgency = _parseUrgencyFromTask();
  }

  int _parseUrgencyFromTask() {
    return int.tryParse(widget.task?.urgency ?? '0') ?? 0;
  }

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
        padding: EdgeInsets.all(20.w),
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
                    Icons.edit,
                    color: CustomColor.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Edit Task',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 24.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if(widget.time != null)...[
                Text(
                  'Date:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[50],
                  ),
                  child: Text(
                    widget.time != null
                        ? '${widget.time!.day}/${widget.time!.month}/${widget.time!.year}'
                        : 'No date available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
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
                    contentPadding: EdgeInsets.all(12.w),
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
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
                        fontSize: 14.sp,
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
                      'Update Task',
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

  bool _canSubmit() {
    bool canSubmit = detailsController.text.trim().isNotEmpty;
    return canSubmit;
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
                'Confirm Task Update',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to update this task?',
                style: TextStyle(fontSize: 16.sp),
              ),
              // SizedBox(height: 12.h),
              // Container(
              //   padding: EdgeInsets.all(12.w),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     borderRadius: BorderRadius.circular(8.r),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Text('Urgency: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp)),
              //           Container(
              //             width: 8.w,
              //             height: 8.w,
              //             decoration: BoxDecoration(
              //               color: urgencyColors[selectedUrgency],
              //               shape: BoxShape.circle,
              //             ),
              //           ),
              //           SizedBox(width: 4.w),
              //           Text(urgencyLabels[selectedUrgency]!, style: TextStyle(fontSize: 14.sp)),
              //         ],
              //       ),
              //       SizedBox(height: 4.h),
              //       if (widget.time != null)
              //         Text('Date: ${widget.time!.day}/${widget.time!.month}/${widget.time!.year}', style: TextStyle(fontSize: 14.sp)),
              //       SizedBox(height: 4.h),
              //       Text('Details: ${detailsController.text.trim()}', style: TextStyle(fontSize: 14.sp)),
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
                  fontSize: 14.sp,
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
              child: Text(
                'Update',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _updateTask();
    }
  }

  Future<void> _updateTask() async {
    if (!_canSubmit()) return;

    setState(() {
      isLoading = true;
    });
    showLoadingDialog(context);
    try {
      final requestBody = {
        "empid": _authProvider!.loginData!.empId,
        "task_id": widget.task?.id,
        "task_detail": detailsController.text.trim(),
        "underline": 0
      };

      final response = await postRequest(ApiEndpoints.editTaskDetail, requestBody);

      if (response != null) {
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Expanded(
                    child: Text('Task updated successfully'),
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

          widget.onTaskUpdated?.call();
        }
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      log('Update Exception: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('Failed to update task: ${e.toString()}'),
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

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}