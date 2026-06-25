import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/compensession_model.dart';
import '../../../../providers/employee/emp_compensation.dart';

Widget buildSalaryList(BuildContext context, List<CompensationModel> salaryList) {
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: salaryList.length,
      itemBuilder: (context, index) {
        final data = salaryList[index];
        return _buildSalaryCard(context, data);
      },
    ),
  );
}

Widget _buildSalaryCard(BuildContext context,CompensationModel data) {
  final empComp = Provider.of<EmpCompensationProvider>(context, listen: false);
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 8.h, 
      horizontal: 12.w
    ),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: CustomColor.primaryColor,
        width: 1.w
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month + Pay Slip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "MONTH: ${data.monthName}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: CustomColor.primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                empComp.downloadPaySlip(
                  context,
                  empComp.empId,
                  empComp.fromYear,
                  empComp.toYear,
                  data.monthId,
                );
              },
              child: Row(
                children: [
                  Icon(Icons.cloud_download,
                    color: CustomColor.colorBlue, size: 22.sp),
                  SizedBox(width: 4.w),
                  Text(
                    "Pay Slip",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: CustomColor.colorBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gross Salary: ",
              style: TextStyle(fontSize: 14.sp)),
            Text("₹${data.grossSalary}",
              style: TextStyle(fontSize: 14.sp)),
          ],
        ),

        SizedBox(height: 6.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Deduction: ",
              style: TextStyle(
                fontSize: 14.sp
              )
            ),
            Text("₹${data.deduction}",
              style: TextStyle(
                fontSize: 14.sp
              )
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: CustomColor.colorGreyBack,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Salary: ",
                style: TextStyle(
                  color: CustomColor.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "₹${data.netSalary}",
                style: TextStyle(
                  color: CustomColor.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
