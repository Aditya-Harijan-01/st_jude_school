import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/employee_task_provider.dart';
import '../widget/access_denied_dialog.dart';
import 'pending_screen.dart';
import 'widget/bottom_sheet.dart';
import 'widget/shimmer_task.dart';
import 'widget/slot_card_widget.dart';
import 'widget/task_functions.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedEmployeeName = 'Loading...';
  String? _selectedEmployeeId;
  bool _hasShownAccessDeniedDialog = false; // Add this flag

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _selectedEmployeeId = authProvider.loginData?.empId;
      _selectedEmployeeName = authProvider.loginData?.tname ?? 'Name';
    });

    await _loadEmployeeList();
    await _loadSlotWiseTasks();
  }

  Future<void> _loadEmployeeList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final empId = authProvider.loginData?.empId;
    final fromYear = authProvider.loginData?.currentyearfrom;
    final toYear = authProvider.loginData?.currentyearto;

    await Provider.of<EmployeeTaskProvider>(
      context,
      listen: false,
    ).getEmployeeListForTask(
      empId: empId ?? '',
      fromYear: fromYear ?? '',
      toYear: toYear ?? '',
    );
  }

  Future<void> _loadSlotWiseTasks() async {
    if (_selectedEmployeeId == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final fromYear = authProvider.loginData?.currentyearfrom;

    final dateStr =
        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

    await Provider.of<EmployeeTaskProvider>(
      context,
      listen: false,
    ).getEmployeeSlotWiseTask(
      empId: _selectedEmployeeId!,
      fromYear: fromYear ?? '',
      fromDate: dateStr,
      toDate: dateStr,
    );
  }

  void _onEmployeeChanged(String empId, String empName) {
    setState(() {
      _selectedEmployeeId = empId;
      _selectedEmployeeName = empName;
    });
    _loadSlotWiseTasks();
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadSlotWiseTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
          "Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Consumer<EmployeeTaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingSlotWiseTask || provider.isLoading) {
            return const Center(child: TaskShimmerWidget());
          }
          if (provider.accessValue != 0 &&
              provider.accessValue != null &&
              !_hasShownAccessDeniedDialog) {
            _hasShownAccessDeniedDialog = true;
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccessDeniedDialog(
                context,
                'You do not have permission to view the task management.',
              );
            });
          }
          if (provider.slotWiseTaskList == null ||
              provider.slotWiseTaskList!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'No time slots available',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'for ${TaskFunctions.getDateDisplayText(_selectedDate)}',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: provider.slotWiseTaskList!.length,
            itemBuilder: (context, index) {
              final slot = provider.slotWiseTaskList![index];
              return SlotCardWidget(
                slot: slot,
                selectedUserId: _selectedEmployeeId ?? '',
                selectedDate: _selectedDate,
                onTaskUpdated: _loadSlotWiseTasks,
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomSheetTask(
        selectedDate: _selectedDate,
        selectedEmployeeId: _selectedEmployeeId,
        selectedEmployeeName: _selectedEmployeeName,
        onDateChanged: _onDateChanged,
        onEmployeeChanged: _onEmployeeChanged,
        content: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PendingTasksScreen(empId: _selectedEmployeeId),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Text(
              '+ import task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColor.primaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
