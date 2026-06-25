// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/employee/pending_task_provider.dart';
import '../../../../constants/colors.dart';

import '../../../models/employee/employee_slot_wise_task_model.dart';
import '../../../models/employee/pending_task_model.dart';
import 'widget/edit_task_dialog.dart';
import 'widget/shimmer_task.dart';
import 'widget/slot_selection_dialog.dart';
import 'widget/add_pending_task_dialog.dart';
import 'widget/task_functions.dart';
import 'widget/task_util.dart';

class PendingTasksScreen extends StatefulWidget {
  final String? empId;
  const PendingTasksScreen({super.key, required this.empId});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPendingTasks();
    });
  }

  void _loadPendingTasks() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final fromYear = authProvider.loginData?.currentyearfrom;
    final toYear = authProvider.loginData?.currentyearto;

    if (widget.empId != null && fromYear != null && toYear != null) {
      context.read<PendingTaskProvider>().getEmployeePendingTask(
        empId: widget.empId!,
        fromYear: fromYear,
        toYear: toYear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColor.colorWhite,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pending Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CustomColor.colorWhite,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: CustomColor.primaryColor,
        child: Icon(Icons.add, color: CustomColor.colorWhite, size: 24.sp),
      ),
      body: Consumer<PendingTaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const TaskShimmerWidget(pending: 1);
          }
          if (provider.pendingTaskList == null && !provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No tasks found or error loading',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: _loadPendingTasks,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.primaryColor,
                      foregroundColor: CustomColor.colorWhite,
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.pendingTaskList!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'No pending tasks',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'All caught up!',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            itemCount: provider.pendingTaskList!.length,
            itemBuilder: (context, index) {
              final task = provider.pendingTaskList![index];
              return _buildTaskCard(task);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(PendingTaskData task) {
    final borderColor = TaskFunctions.parseColor(
      task.fontColor,
      CustomColor.primaryColor,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withOpacity(0.05),
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
              Container(width: 5.w, color: borderColor),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(task),
                      SizedBox(height: 8.h),
                      _buildMetaInfo(task),
                      SizedBox(height: 8.h),
                      Divider(height: 1.h, thickness: 0.5),
                      SizedBox(height: 8.h),
                      _buildActions(task),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(PendingTaskData task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.head.isNotEmpty)
          Text(
            task.head,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        if (task.details.isNotEmpty)
          Text(
            TaskFunctions.parseHtmlString(task.details),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
      ],
    );
  }

  Widget _buildMetaInfo(PendingTaskData task) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        _buildChip(
          label: task.tasktype == '1' ? 'General' : 'Scheduled',
          color: CustomColor.primaryOne,
        ),
        if (task.urgencyText.isNotEmpty && task.urgencyText != 'NA')
          _buildChip(
            label: task.urgencyText,
            color:
                urgencyColors[int.tryParse(task.urgency) ?? 0] ??
                CustomColor.colorGrey,
          ),
        if (task.startdate.isNotEmpty)
          _buildChip(
            label: 'Start: ${task.startdate}',
            color: Colors.green.shade700,
            backgroundColor: Colors.green.shade50,
          ),
        if (task.assignbyname.isNotEmpty)
          _buildChip(
            label: 'By: ${task.assignbyname}',
            color: Colors.blue.shade700,
            backgroundColor: Colors.blue.shade50,
          ),
      ],
    );
  }

  Widget _buildActions(PendingTaskData task) {
    return Row(
      children: [
        if (task.tasktype != "2") ...[
          _buildActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit',
            onTap: () => _editTask(task),
          ),
          Container(
            height: 12.h,
            width: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),
        ],
        _buildActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add to Slot',
          onTap: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SlotSelectionDialog(
              task: task,
              onTaskAdded: _loadPendingTasks,
              empId: widget.empId ?? '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
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

  Widget _buildChip({
    required String label,
    required Color color,
    Color? backgroundColor,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
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

  void _editTask(PendingTaskData task) {
    final taskForEdit = Task(
      id: task.id,
      details: task.details,
      urgency: task.urgency,
    );

    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: taskForEdit,
        onTaskUpdated: () {
          _loadPendingTasks();
        },
        time: null,
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPendingTaskDialog(
        empId: widget.empId ?? '',
        onTaskAdded: () {
          _loadPendingTasks();
        },
      ),
    );
  }
}
