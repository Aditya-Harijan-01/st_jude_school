
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/employee/employee_by_category_provider.dart';
import '../../../../models/employee/employee_by_category_model.dart';
import '../leave/leave_screen.dart';
import 'appraisal_emp_management.dart';
import 'attendance_record_emp_manage_screen.dart';
import 'profile/profile_emp_other.dart';
class EmployeeListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  const EmployeeListScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}
class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEmployees();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _loadEmployees() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<EmployeeByCategoryProvider>(context, listen: false);

    // Ensure we have the necessary data before making the call
    if (authProvider.loginData != null) {
      provider.getEmployeeByCategory(
        categoryId: widget.categoryId,
        fromYear: authProvider.loginData!.currentyearfrom,
        toYear: authProvider.loginData!.currentyearto,
      );
    }
  }
  List<EmployeeData> _getFilteredEmployees(List<EmployeeData>? employees) {
    if (employees == null) return [];
    if (_searchQuery.isEmpty) return employees;
    return employees.where((employee) {
      final name = employee.empName?.toLowerCase() ?? '';
      final designation = employee.designation?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || designation.contains(query);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<EmployeeByCategoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildShimmerList();
                }
                if (provider.error != null) {
                  return _buildErrorState(provider.error!);
                }
                final filteredEmployees = _getFilteredEmployees(provider.employeeByCategoryData?.data);
                if (filteredEmployees.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    return _buildEmployeeCard(filteredEmployees[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.black87, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: 'Search employees...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
              prefixIcon: Icon(Icons.search_rounded, color: CustomColor.primaryColor, size: 22.sp),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear_rounded, color: Colors.grey[400], size: 20.sp),
                onPressed: () => _searchController.clear(),
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmployeeCard(EmployeeData employee) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: () {
            // Handle employee tap - maybe show details or actions
            _showEmployeeOptions(employee);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Hero(
                  tag: 'emp_${employee.empId}',
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColor.primaryColor.withOpacity(0.2), width: 2),
                      image: employee.profileImage != null && employee.profileImage!.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(employee.profileImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: (employee.profileImage == null || employee.profileImage!.isEmpty)
                        ? Center(
                      child: Text(
                        (employee.empName?.isNotEmpty == true)
                            ? employee.empName!.substring(0, 1).toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: CustomColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.empName ?? 'Unknown Name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: CustomColor.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          employee.designation ?? 'No Designation',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: Colors.grey[400],
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 80.h,
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _loadEmployees,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                foregroundColor: CustomColor.colorWhite,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 60.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            _searchQuery.isNotEmpty ? 'No matches found' : 'No employees in this category',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  void _showEmployeeOptions(EmployeeData employee) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: CustomColor.primaryColor.withOpacity(0.1),
                  backgroundImage: employee.profileImage != null && employee.profileImage!.isNotEmpty
                      ? NetworkImage(employee.profileImage!)
                      : null,
                  child: (employee.profileImage == null || employee.profileImage!.isEmpty)
                      ? Text(
                    (employee.empName?.isNotEmpty == true)
                        ? employee.empName!.substring(0, 1).toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  )
                      : null,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.empName ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        employee.designation ?? 'No Designation',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 10.h),
            _buildOptionItem(Icons.person_outline_rounded, 'Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeProfileScreen2(
                    employeeId: employee.empId ?? '',
                  ),
                ),
              );
            }),
            _buildOptionItem(Icons.calendar_today_rounded, 'Attendance', () {
              Navigator.push(
                  context, MaterialPageRoute(
                builder: (context)=> AttendanceRecordEmpManageScreen(empId: employee.empId ?? '', name: employee.empName ?? '',),
              ),
              );
            }),
            _buildOptionItem(Icons.event_note_rounded, 'Leave', () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaveScreen(
                    empId: employee.empId ?? '', 
                    name: employee.empName ?? '', 
                    type: "EMP",
                    image: employee.profileImage
                  ),
                ),
              );
            }),
            _buildOptionItem(Icons.trending_up_rounded, 'Appraisal', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppraisalEmpManagementScreen(
                    empId: employee.empId ?? '', name: employee.empName ?? '',
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: CustomColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: CustomColor.primaryColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}