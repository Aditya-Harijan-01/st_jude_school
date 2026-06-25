import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/student_management/active_class_model.dart';
import '../../../../providers/employee/student_management.dart';
import '../../../../providers/auth_provider/auth_provider.dart';

class ClassDropdownWidget extends StatelessWidget {
  final String fromYear;
  final String toYear;
  const ClassDropdownWidget({super.key, required this.fromYear, required this.toYear});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentManagementProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  Container(
                    width: 150.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          );
        }
        if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }
        if (provider.classList.isEmpty) {
          return const Center(child: Text("No classes available"));
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ClassModel>(
              value: provider.selectedClass,
              isExpanded: true,
              hint: const Text("Select Class"),
              items: provider.classList.map((ClassModel classItem) {
                return DropdownMenuItem<ClassModel>(
                  value: classItem,
                  child: Text(
                    classItem.className,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryOne),
                  ),
                );
              }).toList(),
              onChanged: (ClassModel? newValue) {
                if (newValue != null) {
                  provider.setSelectedClass(newValue);
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  provider.getStudentList(
                    auth.loginData!.empId,
                    fromYear,
                    toYear
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
