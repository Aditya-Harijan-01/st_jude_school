// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/employee/employee_slot_wise_task_model.dart';
import '../../../../providers/employee/employee_task_provider.dart';
import 'task_functions.dart';
import 'task_util.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final String selectedUserId;
  final DateTime selectedDate;
  final VoidCallback onTaskUpdated;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.selectedUserId,
    required this.selectedDate,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.iscompleted == '1';
    final borderColor = TaskFunctions.parseColor(
      task.taskBorderColor,
      CustomColor.primaryColor,
    );

    return GestureDetector(
      onLongPress: () => !isCompleted
          ? TaskFunctions.moveTaskToAnotherSlot(
              context,
              task: task,
              empId: selectedUserId,
              daySlots:
                  context.read<EmployeeTaskProvider>().slotWiseTaskList ?? [],
              onTaskUpdated: onTaskUpdated,
            )
          : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5.w,
                  color: isCompleted ? Colors.green : borderColor,
                ),
                // Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isCompleted),
                        SizedBox(height: 8.h),
                        _buildMetaInfo(context, isCompleted),
                        SizedBox(height: 8.h),
                        Divider(height: 1.h, thickness: 0.5),
                        SizedBox(height: 8.h),
                        _buildActions(context, isCompleted),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.head != null &&
                  task.head!.isNotEmpty &&
                  task.head != '') ...[
                Text(
                  task.head ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey[600] : Colors.grey[900],
                    decoration: task.isUnderline == 'Yes'
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ],
              Text(
                TaskFunctions.parseHtmlString(task.details!),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (!isCompleted)
          GestureDetector(
            onTap: () => TaskFunctions.deleteTask(
              context,
              task,
              selectedUserId,
              onTaskUpdated,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20.sp,
              ),
            ),
          ),
      ],
    );
  }

  // Widget _buildDetails(BuildContext context) {
  //   return ;
  // }

  Widget _buildMetaInfo(BuildContext context, bool isCompleted) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        if (!isCompleted)
          _buildChip(
            label: task.taskstatus ?? 'Pending',
            color: Colors.orange.shade700.withAlpha(200),
            backgroundColor: Colors.orange.shade50,
          ),
        if (!isCompleted &&
            task.urgency != null &&
            task.urgency!.isNotEmpty &&
            task.urgency != '0')
          _buildChip(
            label: urgencyLabels[int.tryParse(task.urgency!) ?? 0] ?? 'N/A',
            color:
                urgencyColors[int.tryParse(task.urgency!) ?? 0] ?? Colors.grey,
            backgroundColor:
                (urgencyColors[int.tryParse(task.urgency!) ?? 0] ?? Colors.grey)
                    .withAlpha(30),
          ),
        if (task.assignbyname != null && task.assignbyname!.isNotEmpty)
          _buildChip(
            label: 'By: ${task.assignbyname}',
            color: Colors.blue.shade700.withAlpha(200),
            backgroundColor: Colors.blue.shade50.withAlpha(200),
          ),
        if (isCompleted &&
            task.completedate != null &&
            task.completedate!.isNotEmpty)
          _buildChip(
            label: 'Completed: ${task.completedate}',
            color: Colors.green.shade700..withAlpha(200),
            backgroundColor: Colors.green.shade50.withAlpha(200),
            icon: Icons.check_circle_outline,
          ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required Color color,
    Color? backgroundColor,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withAlpha(35),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isCompleted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: () => TaskFunctions.editTask(
                context,
                task,
                selectedDate,
                onTaskUpdated,
              ),
            ),
            Container(
              height: 12.h,
              width: 1,
              color: Colors.grey[300],
              margin: EdgeInsets.symmetric(horizontal: 8.w),
            ),
            _buildActionButton(
              context,
              icon: Icons.repeat,
              label: 'Repeat',
              onTap: () => TaskFunctions.repeatTask(
                context,
                task,
                selectedUserId,
                selectedDate,
                onTaskUpdated,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Status",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: CustomColor.primaryColor,
              ),
            ),
            SizedBox(
              height: 25.h,
              width: 40.w,
              child: Transform.scale(
                scale: 0.5,
                child: Switch(
                  padding: EdgeInsets.zero,
                  value: isCompleted,
                  onChanged: (bool value) => TaskFunctions.changeTaskStatus(
                    context,
                    task,
                    selectedUserId,
                    onTaskUpdated,
                  ),
                  activeColor: Colors.green,
                  activeTrackColor: Colors.green.shade100,
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: CustomColor.primaryColor),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: CustomColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
