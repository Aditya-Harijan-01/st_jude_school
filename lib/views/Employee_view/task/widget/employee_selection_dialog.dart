// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/employee/employee_task_provider.dart';

class EmployeeSelectionDialog extends StatefulWidget {
  final String? selectedUserId;
  final Function(String empId, String employeeName) onEmployeeSelected;

  const EmployeeSelectionDialog({
    super.key,
    this.selectedUserId,
    required this.onEmployeeSelected,
  });

  @override
  State<EmployeeSelectionDialog> createState() => _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<EmployeeSelectionDialog> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 8,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        height: 0.75.sh,
        width: 1.sw,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Select Employee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.sp,
                        letterSpacing: 0.5.sp,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: CustomColor.primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  hintText: 'Search by name',
                  hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search_rounded, color: CustomColor.primaryColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: Icon(Icons.clear_rounded, color: Colors.grey[600]),
                        )
                      : null,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ),

            // Employee List
            Expanded(
              child: Consumer<EmployeeTaskProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: CustomColor.primaryColor,
                      ),
                    );
                  }

                  if (provider.employeeList == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 56.sp,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Error loading employees',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredEmployees = provider.employeeList!.where((employee) {
                    final name = employee.employeeName?.toLowerCase() ?? '';
                    return name.contains(_searchQuery) ;
                  }).toList();

                  if (filteredEmployees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_search_rounded,
                              size: 48.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _searchQuery.isEmpty ? 'No employees found' : 'No matching employees',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: filteredEmployees.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      final isSelected = employee.empid == widget.selectedUserId;


                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.onEmployeeSelected(
                              employee.empid ?? '',
                              employee.employeeName ?? '',
                            );
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColor.primaryColor.withOpacity(0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected ? CustomColor.primaryColor : Colors.grey[200]!,
                                width: isSelected ? 2.w : 1.w,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: CustomColor.primaryColor.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          employee.employeeName ?? 'Unknown',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            color: isSelected ? CustomColor.primaryColor : Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: CustomColor.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
