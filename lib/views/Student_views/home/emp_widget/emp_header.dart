import 'package:st_jude_school/models/employee/employee_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Employee_view/emp_profile/emp_profile.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/base64_image.dart';

class EmpHomeHeader extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onMenuToggle;
  final List<EmployeeOffice>? profile;
  final List<EmployeeBasic>? empData;
  final EmployeeDataResponse? allData;

  const EmpHomeHeader({
    super.key,
    required this.isMenuOpen,
    required this.onMenuToggle,
    required this.profile,
    required this.empData,
    required this.allData,
  });

  @override
  Widget build(BuildContext context) {
    if (empData == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: onMenuToggle,
              child: Container(
                width: 32.w,
                height: 32.h,
                color: Colors.transparent,
                child: isMenuOpen
                    ? Icon(
                        Icons.close,
                        color: CustomColor.colorWhite,
                        size: 28.sp,
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (row) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (col) {
                                return Container(
                                  margin: EdgeInsets.all(2.r),
                                  width: 6.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color: CustomColor.colorWhite,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            // Shimmer for text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    // ignore: deprecated_member_use
                    baseColor: CustomColor.colorWhite.withOpacity(0.4),
                    // ignore: deprecated_member_use
                    highlightColor: CustomColor.colorWhite.withOpacity(0.7),
                    child: Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: CustomColor.colorWhite,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Shimmer.fromColors(
                    // ignore: deprecated_member_use
                    baseColor: CustomColor.colorWhite.withOpacity(0.4),
                    // ignore: deprecated_member_use
                    highlightColor: CustomColor.colorWhite.withOpacity(0.7),
                    child: Container(
                      width: 80.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: CustomColor.colorWhite,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Shimmer for avatar
            Shimmer.fromColors(
              // ignore: deprecated_member_use
              baseColor: CustomColor.colorWhite.withOpacity(0.4),
              // ignore: deprecated_member_use
              highlightColor: CustomColor.colorWhite.withOpacity(0.7),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: CustomColor.colorWhite,
              ),
            ),
          ],
        ),
      );
    }

    //   When profile is loaded, show actual header
    final office = profile!.first;
    final employee = empData!.first;
    // final fullData = allData;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuToggle,
            child: Container(
              width: 32.w,
              height: 32.h,
              color: Colors.transparent,
              child: isMenuOpen
                  ? Icon(
                      Icons.close,
                      color: CustomColor.colorWhite,
                      size: 28.sp,
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (row) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (col) {
                              return Container(
                                margin: EdgeInsets.all(2.r),
                                width: 6.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: CustomColor.colorWhite,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.employeeName,
                  style: TextStyle(
                    color: CustomColor.colorWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  office.designation,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeProfileScreen(employee: allData),
                ),
              );
            },
            child: CircleAvatar(
              radius: 22.r,
              backgroundImage: buildEmpProfileImage(employee.profileImage),
            ),
          ),
        ],
      ),
    );
  }
}
