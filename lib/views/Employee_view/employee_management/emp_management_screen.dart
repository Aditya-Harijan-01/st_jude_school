// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/employee/employee_counter_provider.dart';
import '../../../../models/employee/employee_counter_model.dart';
import 'emp_category_listing.dart';
import '../widget/access_denied_dialog.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeManagementScreen> {
  bool _hasShownAccessDeniedDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final empId = authProvider.loginData?.empId ?? '';
    final fromYear = authProvider.loginData?.currentyearfrom ?? '';
    final toYear = authProvider.loginData?.currentyearto ?? '';

    if (empId.isNotEmpty) {
      context.read<EmployeeCounterProvider>().getEmployeeCounter(
          empId: empId,
          fromYear: fromYear,
          toYear: toYear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:  AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
            "Employees",
            style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Consumer<EmployeeCounterProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildShimmerLoading();
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }

          if (provider.employeeCounterData == null) {
            return const Center(child: Text('No data available'));
          }

          final data = provider.employeeCounterData!;
          
          if (data.userAccessValue != null &&
              data.userAccessValue != 0 &&
              !_hasShownAccessDeniedDialog) {
            _hasShownAccessDeniedDialog = true;
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccessDeniedDialog(context, 'You do not have permission to view detailed employee management data.');
            });
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            color: CustomColor.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(data),
                  SizedBox(height: 30.h),
                  Text(
                    'Departments:',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildCategoryList(data.data ?? []),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(EmployeeCounterResponse data) {
    int total = 0;
    if (data.data != null) {
      for (var cat in data.data!) {
        total += int.tryParse(cat.totalEmployee ?? '0') ?? 0;
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColor.primaryColor, CustomColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Employees',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildCategoryList(List<EmployeeCategoryData> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            'No categories found',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
        ),
      );
    }

    int totalEmployees = 0;
    for (var cat in categories) {
      totalEmployees += int.tryParse(cat.totalEmployee ?? '0') ?? 0;
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = int.tryParse(category.totalEmployee ?? '0') ?? 0;
        final percentage = totalEmployees > 0 ? count / totalEmployees : 0.0;

        return _buildCategoryRow(category, count, percentage);
      },
    );
  }

  Widget _buildCategoryRow(EmployeeCategoryData category, int count, double percentage) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => EmployeeListScreen(
                 categoryId: category.categoryId ?? '',
                 categoryTitle: category.categoryName ?? '',
               ),
             ),
           );
        },        child: Row(
          children: [
            _buildCategoryIcon(category.categoryName ?? ''),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.categoryName ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColor.primaryColor,
                      ),
                      minHeight: 6.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${(percentage * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String categoryName) {
    IconData iconData;
    
    final lowerCaseName = categoryName.toLowerCase();
    if (lowerCaseName.contains('teaching') || lowerCaseName.contains('teacher')) {
      iconData = Icons.school_rounded;
    } else if (lowerCaseName.contains('admin')) {
      iconData = Icons.admin_panel_settings_rounded;
    } else if (lowerCaseName.contains('support')) {
      iconData = Icons.support_agent_rounded;
    } else if (lowerCaseName.contains('coach') || lowerCaseName.contains('sport')) {
      iconData = Icons.sports_basketball_rounded;
    } else if (lowerCaseName.contains('transport') || lowerCaseName.contains('bus')) {
      iconData = Icons.directions_bus_rounded;
    } else if (lowerCaseName.contains('security')) {
      iconData = Icons.security_rounded;
    } else if (lowerCaseName.contains('maintenance')) {
      iconData = Icons.handyman_rounded;
    } else {
      iconData = Icons.badge_rounded;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        iconData,
        color: CustomColor.primaryColor,
        size: 24.sp,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 24.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                foregroundColor: Colors.white,
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

}
