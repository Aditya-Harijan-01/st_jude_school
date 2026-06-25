// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/employee_slot_wise_task_model.dart';
import 'task_item_widget.dart';
import 'add_task_dialog.dart';

class SlotCardWidget extends StatelessWidget {
  final SlotData slot;
  final String selectedUserId;
  final DateTime selectedDate;
  final VoidCallback onTaskUpdated;

  const SlotCardWidget({
    super.key,
    required this.slot,
    required this.selectedUserId,
    required this.selectedDate,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final hasTask = slot.taskList != null && slot.taskList!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasTask ? CustomColor.primaryColor.withOpacity(0.3) : Colors.grey[200]!,
          width: hasTask ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSlotHeader(context, hasTask),
          
          if (hasTask)
            Column(
              children: slot.taskList!
                  .map((task) => TaskItemWidget(
                        task: task,
                        selectedUserId: selectedUserId,
                        selectedDate: selectedDate,
                        onTaskUpdated: onTaskUpdated,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSlotHeader(BuildContext context, bool hasTask) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: hasTask ? CustomColor.primaryColor.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: hasTask ? CustomColor.primaryColor: Colors.grey.shade500,
            size: 20.sp,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Row(
              children: [
                Text(
                  slot.slotTime ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color:  hasTask ? CustomColor.primaryColor: Colors.grey.shade800,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '(${slot.slotAssignTime ?? '0'} min)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddTaskDialog(
                  empId: selectedUserId,
                  slot: slot,
                  time: selectedDate,
                  onTaskAdded: onTaskUpdated,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.white),
              ),
              child: Text('+', style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}
